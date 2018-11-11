class Home < Hyperloop::Component
  state search: '', type: String
  state stores: [], type: []
  state fetching: false
  state error: '', type: String

  render(DIV) do
    Polaris::TextField(type: :search, value: state.search, onChange: ->(value) { mutate.search value } )
    Polaris::Button(loading: state.fetching ? true : false ) { 'Buscar' }.on(:click) { fetch_search }
    Polaris::DescriptionList(items: serialized_stores)
  end

  private

  def serialized_stores
    state.stores.map { |store| `{term: 'tienda', description: #{store}}` }
  end

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
