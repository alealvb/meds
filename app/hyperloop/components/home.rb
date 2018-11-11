class Home < Hyperloop::Component
  state search: ''
  state stores: []
  state fetching: false
  state error: ''

  render(DIV) do
    if state.fetching
      'Cargando...'
    else
      INPUT(type: :search).on(:change) { |e| mutate.search e.target.value }
      BUTTON { 'Buscar' }.on(:click) { fetch_search }
      UL do
        state.stores.each do |store_data|
          LI { store_data }
        end
      end if state.stores.any?
    end
  end

  private

  def fetch_search
    mutate.stores []
    mutate.fetching true
    Search.run(text: state.search)
          .then { |stores| update_stores(stores) }
          .fail { |err| notify_error(err) }
  end

  def update_stores(stores)
    mutate.stores stores
    mutate.fetching false
  end

  def notify_error(err)
    puts err
    mutate.fetching false
  end
end
