view: users{
  sql_table_name: demo_db.users ;;


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: a_b_gender {
    type: string
    sql: {% condition %}${gender}{% endcondition %} ;;
  }

  filter: date_test {
    type: date
  }


  dimension_group: filtered_date {
    type: time
    sql: {% condition date_test %}
      ${created_date}
      {% endcondition %}
        ;;
  }

  dimension_group: test_date {
    type: time
    sql: ${created_date} ;;

  }


  dimension: city_state {
    type: string
    sql: concat(${city},", ", "CA") ;;
  }

  dimension: a_b {
    type: yesno
    sql:
            {%condition a_b_gender %} ${gender} {% endcondition %};;
  }

#   dimension: case_test {
#     type: number
#     case: {
#       when: {
#         sql: mod(${id},2) = 0 ;;
#         label: "even"
#       }
#       when: {
#         sql: mode(${id},2) = 1 ;;
#         label: "odd"
#       }
#       else: "what the hell kind of number is this?"
#     }
#   }

#   dimension: id_test {
#     type: number
#     sql:
#         {% if _explore._name == 'users' %} ${TABLE}.id +1
#     {% else %} ${TABLE}.id + 2
#     {% endif %}
#     ;;
#   }

  # dimension: second_test {
  #   type: number
  #   sql:
  #       {% if user_facts.SQL_TABLE_NAME.id %} ${TABLE}.id +1
  #   {% else %} ${TABLE}.id + 2
  #   {% endif %}
  #   ;;
  # }

  dimension: test_tag {
    type: string
    sql: "{{ _user_attributes['limit_view'] }}" ;;
  }

  dimension: pull_in {
    type: number
    sql: orders.user_id ;;
  }


  dimension: age {
#     label: "{% if _explore._name == 'user_data' %} age_1 {% else %} age_2 {%  endif %}"
  type: number
  sql: ${TABLE}.age ;;
}

dimension: test_html {
  type: string
  sql: 1 ;;
  html: <a href="http://www.yahoo.com"><img src="img_chania.jpg" alt="Flowers in Chania"> </a> ;;
}

filter: liq_test {
  type: number
  suggestions: ["id"]
}

parameter: in_btwn {
  type: number
}

filter: date_filter {
  type: date_time
}

dimension: liquid_test {
  type: string
  sql:
          {% if _explore._name == 'users' %} "Users Worked"
          {% else %} "Other Views" {% endif %}
          ;;
}

dimension: nb_weeks {
  type: number
  sql: DATEDIFF({% date_end date_filter %}, {% date_start date_filter %})/7.0 ;;
}

#   dimension: in_range {
#     type:  yesno
#     sql: DATEDIFF(${end_date},${created_date}) < 15   ;;
#   }


dimension: end_date {
  type:  date
  sql: DATE_ADD(${created_date}, interval 14 day)  ;;
}

#   measure: filtered_count {
#     type: count
#
#     filters: {
#       field: is_before_ytd
#       value: "Yes"
#     }

# }

parameter: jon {
  type: date
}



# # 10 Equal Buckets
parameter: bucket_number{
  type: number
}

# dimension: bucket_age_step {
#   type: number
#   sql: TRUNCATE(${bucket_size.range}/ {% parameter bucket_number %}, 0)
#   ;;
# }

# dimension: bucket_age_tier {
#   type: number
#   sql: TRUNCATE(${age}/ ${bucket_age_step},0) * ${bucket_age_step} ;;
# }
#
measure: max_test {
  type: max
  sql: ${TABLE}.age ;;
}

measure: min_test {
  type: min
  sql: ${TABLE}.age ;;
}


dimension: 24test {
  type: number
  sql: ${TABLE}.age ;;
}

dimension: test {
  type: string
  sql: "test_succeeded" ;;
}

dimension: foo_explore_name {
  sql: users ;;
}

dimension: country {
  type: string
  map_layer_name: countries
  sql: ${TABLE}.country ;;
  link: {
    label: "State"
    url: "/dashboards/4?Country={{ value }}"
  }
  drill_fields: [time_drill*]
}

dimension: state {
  type: string
  sql: ${TABLE}.state ;;
  link: {
    label: "City"
    url: "/dashboards/5?Country={{ _filters['users.country'] | url_encode }}
    &State={{ value }}
    "
  }
  drill_fields: [time_drill*]
}

dimension: city {
  type: string
  sql: ${TABLE}.city ;;
#     link: {
#       label: "Zip"
#       url: "/dashboards/6?City={{ value }}
#       &State={{  _filters['users.state'] | url_encode  }}
#       &&Country={{  _filters['users.country'] | url_encode  }}
#       "
#     }
  link: {
    label: "Test URL"
    url: "{{ _user_attributes['url'] }}"

  }
}

dimension: zip {
  type: zipcode
  sql: ${TABLE}.zip ;;
  html:  <font color="blue">{{rendered_value}}</font> ;;
}


dimension: data_type_suzanne {
  type: string
  sql: ${TABLE}.DATA_TYPE__C ;;
  link: {
    label: "Explore '{{value}}' by Root Cause"
    url: "/dashboards/506?Data%20Type={{value}}
    &Issue%20Type={{_filters['sf_issue_management__c.issue_type__c'] | url_encode }}
    &Date={{_filters['sf_issue_management__c.submit_date__c_date'] | url_encode }}
    &Affected%20Data%20Asset={{_filters['sf_issue_management__c.di_process_type__c'] | url_encode }}"
  }
}
dimension: or_test_case {
  alpha_sort: yes
  type: string
  case: {
    when: {
      sql:${TABLE}.city = "Agency"
        OR  ${TABLE}.city = "Addis";;
      label: "test_successful"
    }
    else: "nope"
  }
}

dimension: sql_test_case {
  type: string
  sql:
          CASE
          WHEN ${TABLE}.city = "Agency" THEN "test_successful"
          WHEN ${TABLE}.city = "Addis" THEN "test_successful"
          ELSE "nope"
          END
          ;;
}

dimension: failed_case_test {
  type: string
  case: {
    when: {
      sql:${TABLE}.city = "Agency"  ;;
      label: "test_successful"
    }
    when: {
      sql:${TABLE}.city = "Addis"  ;;
      label: "test_successful"
    }
    else: "nope"
  }
}

dimension_group: created {
  type: time
  datatype: datetime
  timeframes: [
    raw,
    yesno,
    time,
    date,
    week,
    week_of_year,
    hour_of_day,
    minute,
    day_of_week,
    day_of_week_index,
    day_of_month,
    month,
    month_num,
    quarter,
    quarter_of_year,
    year
  ]
  sql: ${TABLE}.created_at ;;
  drill_fields: [time_drill*]
}
#
# dimension: date_test {
#   type: yesno
#   sql: {% parameter jon %} =  ${TABLE}.created_at  ;;
# }

dimension: email {
  type: string
  sql: ${TABLE}.email ;;
}


parameter: name_param {
  type: string
}

dimension: matches_name {
  type: yesno
  sql: {% parameter name_param %} = ${first_name} ;;
}

dimension: first_name {
  type: string
  sql: ${TABLE}.first_name ;;
  html: <font face="Arial" color="green">{{value}}</font> ;;
  drill_fields: [detail*]
}

dimension: filtered_name {
  type: string
  sql: CASE WHEN {% parameter name_param %} != ${first_name}
         THEN  ${first_name}
          ELSE
          "nope"
          END;;
}

dimension: gender_overriden {
  type: string
  sql: ${gender};;
  link: {
    label: "Test Link"
    url: "{{ users.count._link }}"
    icon_url: "http://www.looker.com/favicon.ico"
  }
}

dimension: gender {
  type: string
  sql: ${TABLE}.gender ;;
  link: {
    label: "link testing"
    url: "/explore/sandbox/user_data?fields=users.city,users.count&f[users.city]=&sorts=users.count+desc&limit=25&query_timezone=America%2FLos_Angeles&vis=%7B%22trellis%22%3A%22%22%2C%22stacking%22%3A%22%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22legend_position%22%3A%22center%22%2C%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_view_names%22%3Atrue%2C%22point_style%22%3A%22circle%22%2C%22series_types%22%3A%7B%7D%2C%22limit_displayed_rows%22%3Afalse%2C%22y_axis_combined%22%3Atrue%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed%22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22reference_lines%22%3A%5B%7B%22reference_type%22%3A%22line%22%2C%22line_value%22%3A%22mean%22%2C%22range_start%22%3A%22max%22%2C%22range_end%22%3A%22min%22%2C%22margin_top%22%3A%22deviation%22%2C%22margin_value%22%3A%22mean%22%2C%22margin_bottom%22%3A%22deviation%22%2C%22label_position%22%3A%22right%22%2C%22color%22%3A%22%23000000%22%7D%5D%2C%22ordering%22%3A%22none%22%2C%22show_null_labels%22%3Afalse%2C%22show_totals_labels%22%3Afalse%2C%22show_silhouette%22%3Afalse%2C%22totals_color%22%3A%22%23808080%22%2C%22value_labels%22%3A%22legend%22%2C%22label_type%22%3A%22labPer%22%2C%22show_null_points%22%3Atrue%2C%22type%22%3A%22looker_column%22%2C%22show_row_numbers%22%3Atrue%2C%22truncate_column_names%22%3Afalse%2C%22hide_totals%22%3Afalse%2C%22hide_row_totals%22%3Afalse%2C%22table_theme%22%3A%22editable%22%2C%22enable_conditional_formatting%22%3Afalse%2C%22conditional_formatting_include_totals%22%3Afalse%2C%22conditional_formatting_include_nulls%22%3Afalse%7D&filter_config=%7B%22users.city%22%3A%5B%7B%22type%22%3A%22user_attribute%22%2C%22values%22%3A%5B%7B%22constant%22%3Anull%7D%2C%7B%7D%5D%2C%22id%22%3A0%2C%22error%22%3Afalse%7D%5D%7D&dynamic_fields=%5B%5D&origin=share-expanded"

    # url:"/looks/10"
  }

  drill_fields: [detail*]
}

dimension: last_name {
  type: string
  sql: ${TABLE}.last_name ;;
}

dimension: is_before_ytd {
  label: "test_test"
  type: yesno
  sql:
      (DAYOFYEAR(${created_time}) < DAYOFYEAR(CURRENT_TIMESTAMP)
          OR
          (
            DAYOFYEAR(${created_time}) = DAYOFYEAR(CURRENT_TIMESTAMP) AND
            EXTRACT(HOUR FROM ${created_time}) < EXTRACT(HOUR FROM CURRENT_TIMESTAMP)
          )
         OR
          (
            DAYOFYEAR(${created_time}) = DAYOFYEAR(CURRENT_TIMESTAMP) AND
            EXTRACT(HOUR FROM ${created_time}) <= EXTRACT(HOUR FROM CURRENT_TIMESTAMP) AND
            EXTRACT(MINUTE FROM ${created_time}) < EXTRACT(MINUTE FROM CURRENT_TIMESTAMP)
          )
       )
      ;;
}

dimension: yoy  {
  type: yesno
  sql:
          (
          (
               WEEKOFYEAR(users.created_at) < WEEKOFYEAR(current_timestamp)
          )
          OR
          (
              WEEKOFYEAR(users.created_at) = WEEKOFYEAR(current_timestamp) AND
              WEEKDAY(users.created_at) <= WEEKDAY(current_timestamp)
              ))


        ;;
}

#       weekofyear(users.created_at) <= weekofyear(users.created_at) AND
#     dayofweek(users.created_at) <= dayofweek(current_timestamp)
#   OR
#     (
#     day(users.created_at) = day(current_timestamp) AND
#     dayofweek(users.created_at) <= dayofweek(current_timestamp)
#     )

#     month(users.created_at) = month(current_timestamp) AND
#     weekofyear(users.created_at) = weekofyear(current_timestamp) AND
#     dayofweek(users.created_at) <= dayofweek(current_timestamp)


dimension: yoy_test {
  type: yesno
  sql:
          (
          (${created_month_num} < MONTH(CURRENT_TIMESTAMP))
          OR
          (${created_month_num} =  MONTH(CURRENT_TIMESTAMP)
          AND
          ${created_day_of_month} <=  DAYOFMONTH (CURRENT_TIMESTAMP)
          AND
          ${created_day_of_week_index} <=
          (CASE WHEN DAYOFWEEK(CURRENT_TIMESTAMP) = 1 THEN 6
          ELSE (DAYOFWEEK(CURRENT_TIMESTAMP) - 2) END )
          )
          );;
}

#       AND
#     ${created_day_of_week_index} <= DAYOFWEEK(CURRENT_TIMESTAMP)

measure: count {
  type: count
  # drill_fields: [detail*]
#     link: {
#       label: "State"
#       url: "/dashboards/4?Country=USA"
#     }
  # value_format: "*00#"
  drill_fields: [detail*]
  html: <a href="#drillmenu" target="_self"> <font face="Arial" color="green">{{rendered_value}}</font> </a>;;
}

measure: count_formatted {
  type: count_distinct
  sql: ${id} ;;
  filters: {
    field: id
    value: ">20"
  }
  html: <font color="red">{{ rendered_value | replace: '.', 'µ' | replace: ',','-' | replace: 'µ', ','}}</font>;;
}

measure: count_foo {
  type: count
  # filters: {
  #   field: id
  #   value: "0" # use "NOT NULL" if this is a number field
  # }
  required_fields: [city]
}
dimension: age_groups {
  type: tier
  tiers: [0, 18, 30, 60]
  style: integer
  sql: ${age} ;;
}

# dimension: tag {
#   type: string
#   sql: CASE
#   WHEN coun

#   ;;
# }


measure: max_date {
  type: date
  sql: MAX(${created_raw});;
  drill_fields: [time_drill*]
}

measure: count_even {
  type: sum
  sql: CASE WHEN MOD(${age},2) = 0 THEN 1 ELSE 0 END ;;

  drill_fields: [detail*]
}

measure: count_odd{
  type: sum
  sql: CASE WHEN MOD(${age},2) = 0 THEN 1 ELSE 0 END ;;
}

measure: filt {
  type: count

  filters: {
    field: created_date
    value: "this year"
  }
}


#### testing

filter: range {
  type: date
}

dimension: in_range {
  type: yesno
  sql: {% condition in_range %} ${created_date} {%  endcondition %} ;;
}


measure: count_plain {
  type: count
}

measure: running {
  type: running_total
  sql:  ;;
}

measure: filtered_count {
  type: count

  filters: {
    field: in_range
    value: "yes"
  }

  link: {
    label: "‘Test Link’"
    url: "{{ users.count_even._link }}"
    icon_url: "http://www.looker.com/favicon.ico"
  }

#   html: <a href={{ users.count_even._link }}> {{rendered_value}} </a>;;
}



# ----- Sets of fields for drilling ------
set: detail {
  fields: [
#     id,
    first_name,
#     last_name,
#     email,
    count
  ]
}

set: time_drill {
  fields: [
    created_minute,
    created_month,
    created_week,
    created_time
  ]
}

}
