view: user_data {
  sql_table_name: demo_db.user_data ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: max_num_orders {
    type: number
    sql: ${TABLE}.max_num_orders ;;
  }

  dimension: total_num_orders {
    type: number
    sql: ${TABLE}.total_num_orders ;;
  }

  # dimension: week_of_year {
  #   label: "This week"
  #   view_label: "4. Usage Metrics"
  #   description: "Yes = Event was saved"
  #   type: date_week_of_year
  #   sql: ${event_time};;
  # }

  dimension: user_id_to_change {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id, users.count]
  }
}
