- dashboard: dashboard_a
  title: Dashboard_A
  layout: newspaper
  embed_style:
    background_color: "#f6f8fa"
    show_title: true
    title_color: "#3a4245"
    show_filters_bar: true
    tile_text_color: "#3a4245"
    text_tile_text_color: "#ff433c"
  elements:
  - title: Country Count
    name: Country Count
    model: sandbox
    explore: users
    type: looker_pie
    fields:
    - users.count
    - users.country
    sorts:
    - users.count desc
    limit: 10
    query_timezone: America/Los_Angeles
    series_types: {}
    listen:
      Country: users.country
    row: 0
    col: 0
    width: 8
    height: 6
  - title: Testing Tile for Private Embed
    name: Testing Tile for Private Embed
    model: sandbox
    explore: users
    type: single_value
    fields:
    - users.count
    limit: 500
    show_view_names: 'true'
    series_types: {}
    listen: {}
    row: 0
    col: 8
    width: 8
    height: 6
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: sandbox
    explore: users
    listens_to_filters: []
    field: users.country
  - name: date
    title: date
    type: field_filter
    default_value: 2018/10/20 23:48 to 2018/11/20 23:48
    allow_multiple_values: true
    required: false
    model: sandbox
    explore: users
    listens_to_filters: []
    field: users.date_filter
