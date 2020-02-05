- dashboard: new_dash
  title: new_dash
  layout: newspaper
  elements:
  - title: new
    name: new
    model: sandbox
    explore: products
    type: table
    fields: [products.category, products.count]
    sorts: [products.count desc]
    limit: 500
    query_timezone: America/Los_Angeles
    row: 0
    col: 0
    width: 8
    height: 6
