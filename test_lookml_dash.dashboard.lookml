- dashboard: users
  title: Users
  layout: newspaper
  elements:
  - name: merge-LfkbjIjFJE07dTy3FUg5wW-5
    type: text
    title_text: Merged Results
    subtitle_text: This item contains data that can no longer be displayed.
    body_text: This item contains results merged from two or more queries. This is
      currently not supported in LookML dashboards.
    row: 15
    col: 0
    width: 8
    height: 6
  - title: Lookless Tile
    name: Lookless Tile
    model: sandbox
    explore: user_data
    type: looker_column
    fields:
    - users.count
    - users.state
    sorts:
    - users.count desc
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 15
    col: 8
    width: 8
    height: 6
  - name: User Age with Pivot on Gender
    title: User Age with Pivot on Gender
    model: sandbox
    explore: users
    type: looker_bar
    fields:
    - users.count
    - users.gender
    - users.age_groups
    - users.state
    pivots:
    - users.gender
    - users.age_groups
    sorts:
    - users.count desc 0
    - users.gender
    - users.age_groups
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    font_size: 12
    leftAxisLabelVisible: false
    leftAxisLabel: ''
    rightAxisLabelVisible: false
    rightAxisLabel: ''
    barColors:
    - red
    - blue
    smoothedBars: false
    orientation: automatic
    labelPosition: left
    percentType: total
    percentPosition: inline
    valuePosition: right
    labelColorEnabled: false
    labelColor: "#FFF"
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    value_labels: legend
    label_type: labPer
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      test_number: users.email
    row: 0
    col: 0
    width: 24
    height: 9
  - title: Quarter Over Quarter Analysis
    name: Quarter Over Quarter Analysis
    model: sandbox
    explore: order_items
    type: single_value
    fields:
    - orders.created_quarter_of_year
    - orders.created_year
    - products.count
    pivots:
    - orders.created_year
    fill_fields:
    - orders.created_quarter_of_year
    - orders.created_year
    sorts:
    - orders.created_year
    - orders.created_quarter_of_year
    limit: 5000
    column_limit: 50
    filter_expression: |-
      extract_months(${orders.created_date}) < extract_months(now()) OR
      extract_months(${orders.created_date}) = extract_months(now()) AND
      extract_days(${orders.created_date}) <= extract_days(now())
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    series_types: {}
    hidden_fields: []
    row: 15
    col: 16
    width: 8
    height: 6
  - title: Top 25 Users by State and Gender
    name: Top 25 Users by State and Gender
    model: sandbox
    explore: user_data
    type: looker_column
    fields:
    - users.count
    - users.gender
    pivots:
    - users.gender
    sorts:
    - users.count desc 0
    - users.gender
    limit: 25
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    value_labels: legend
    label_type: labPer
    show_null_points: true
    point_style: circle
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    row: 21
    col: 0
    width: 8
    height: 6
  # - name: Top 25 Users by State and Gender
  #   title: Top 25 Users by State and Gender
  #   model: sandbox
  #   explore: user_data
  #   type: looker_column
  #   fields:
  #   - users.count
  #   - users.gender
  #   - users.city
  #   pivots:
  #   - users.gender
  #   sorts:
  #   - users.count desc 0
  #   - users.gender
  #   limit: 25
  #   query_timezone: America/Los_Angeles
  #   stacking: ''
  #   show_value_labels: false
  #   label_density: 25
  #   legend_position: center
  #   x_axis_gridlines: false
  #   y_axis_gridlines: true
  #   show_view_names: true
  #   limit_displayed_rows: false
  #   y_axis_combined: true
  #   show_y_axis_labels: true
  #   show_y_axis_ticks: true
  #   y_axis_tick_density: default
  #   y_axis_tick_density_custom: 5
  #   show_x_axis_label: true
  #   show_x_axis_ticks: true
  #   x_axis_scale: auto
  #   y_axis_scale_mode: linear
  #   x_axis_reversed: false
  #   y_axis_reversed: false
  #   ordering: none
  #   show_null_labels: false
  #   show_totals_labels: false
  #   show_silhouette: false
  #   totals_color: "#808080"
  #   value_labels: legend
  #   label_type: labPer
  #   show_null_points: true
  #   point_style: circle
  #   show_row_numbers: true
  #   truncate_column_names: false
  #   hide_totals: false
  #   hide_row_totals: false
  #   table_theme: editable
  #   enable_conditional_formatting: false
  #   conditional_formatting_include_totals: false
  #   conditional_formatting_include_nulls: false
  #   series_types: {}
  #   row: 9
  #   col: 13
  #   width: 11
  #   height: 6
  - name: Top 25 Cities
    title: Top 25 Cities
    model: sandbox
    explore: user_data
    type: looker_column
    fields:
    - users.city
    - users.count
    sorts:
    - users.count desc
    limit: 25
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    value_labels: legend
    label_type: labPer
    show_null_points: true
    point_style: circle
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      test_number: users.city
    row: 9
    col: 0
    width: 13
    height: 6
  filters:
  - name: test_number
    title: test_number
    type: field_filter
    default_value: "%San%"
    allow_multiple_values: true
    required: false
    model: sandbox
    explore: users
    listens_to_filters: []
    field: users.email
