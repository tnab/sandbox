#test_2


datagroup: test_1 {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: test_2 {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "2 hour"
}

datagroup: test_3 {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "3 hour"
}

datagroup: test_4 {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "4 hour"
}
