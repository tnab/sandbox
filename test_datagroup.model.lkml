connection: "postgresql_gcp"

include: "*.view.lkml"         # include all views in this project
include: "test.lkml"  # include all dashboards in this project

explore: order_items {}
