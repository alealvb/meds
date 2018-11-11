class SearchFarmatodo < Hyperloop::ServerOp
  param acting_user: nil, nils: true
  param :text
  param :browser
  param farmatodo_url: 'https://www.farmatodo.com.ve'

  step :go_to_url
  step :search_product
  step :set_item_count
  step :search_location

  def go_to_url
    params.browser.goto params.farmatodo_url
  end

  def search_product
    params.browser.text_field(class: 'farma-input-header')
          .when_present.set params.text
  end

  def set_item_count
    params.browser.div(class: 'items-container').wait_until_present
    @items_count = params.browser.divs(class: 'item').size
  end

  def search_location
    locations = []
    @items_count.times do |index|
      navitage_item(index)
      if modal_button.present?
        modal_button.click!
      else
        find_stores { |stores| locations += stores.map(&:text) }
      end
    end
    locations
  end

  private

  def navitage_item(index)
    params.browser.div(class: 'items-container').wait_until_present
    params.browser.divs(class: 'item')[index].as.last.click!
    Watir::Wait.until { modal_button.present? || municipality_button.present? }
  end

  def find_stores
    municipality_button.click!
    municipality = params.browser.div(id: 'Caracas')
    stores = municipality.divs(data_ng_repeat: 'storeGroup in municipality.storeGroupList')
    yield stores
    params.browser.a(class: 'farma-button-back-detail').click!
  end

  def modal_button
    params.browser.div(ng_click: 'closeRemoveModalItemNotAvailable();')
  end

  def municipality_button
    params.browser.a(data_target: '#Caracas')
  end
end
