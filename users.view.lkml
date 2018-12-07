view: users {
  sql_table_name: demo_db.users ;;


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

filter: liq_test {
  type: string
  suggestions: ["id"]
}

dimension: in_range {
  type:  yesno
  sql: DATEDIFF(${end_date},${created_date}) < 15   ;;
}


dimension: end_date {
  type:  date
  sql: DATE_ADD(${created_date}, interval 14 day)  ;;
}

measure: filtered_count {
  type: count

  filters: {
    field: created_date
    value: "0 days ago for 14 days"
  }

}

# # 10 Equal Buckets
  parameter: bucket_number{
    type: number
  }
#
#   dimension: bucket_age_step {
#     type: number
#     sql: TRUNCATE(${bucket_size.range}/ {% parameter bucket_number %}, 0)
#     ;;
#   }
#
#   dimension: bucket_age_tier {
#     type: number
#     sql: TRUNCATE(${age}/ ${bucket_age_step},0) * ${bucket_age_step} ;;
#   }
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
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    link: {
      label: "Zip"
      url: "/dashboards/6?City={{ value }}
      &State={{  _filters['users.state'] | url_encode  }}
      &&Country={{  _filters['users.country'] | url_encode  }}
      "
    }
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
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
    timeframes: [
      raw,
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
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: date_test {
    type: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
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
    drill_fields: [detail*]
    # value_format: "*00#"
  }

  measure: count_di {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: id
      value: ">20"
    }
  }

  dimension: age_groups {
    type: tier
    tiers: [0, 18, 30, 60]
    style: integer
    sql: ${age} ;;
  }

# ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name
    ]
  }
}
