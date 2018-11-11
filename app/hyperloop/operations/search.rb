class Search < Hyperloop::ServerOp
  param acting_user: nil, nils: true
  param :text

  step { @browser = Watir::Browser.new :chrome }
  step { SearchFarmatodo.run(text: params.text, browser: @browser) }
  step { |result| @locations = result }
  step { @browser.close }
  step { @locations }

end
