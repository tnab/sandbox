view: derived_test_base {
derived_table: {
  sql:
  WITH ranking AS (
  SELECT
  city,
  count(id),
  country,
  rank() over (ordery by count(id) DESC) AS rank
  FROM demo_db.users AS users
  GROUP BY 1,2
  ) b

  SELECT
  city,
  count(id) AS num_users,
  country
  FROM ranking
  WHERE rank = 1
  ;;
}

dimension: city {}

dimension: country {}

dimension: num_users {}


}
