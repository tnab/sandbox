view: quarterly_rev_graph {

  derived_table: {

    sql: with revenue as (

      SELECT

      begin_dt AS begin_date

      , CASE WHEN product_type_identifier in ('1F','1','1T','UNK') THEN sku ELSE parent_identifier_sku END AS sku

      --, title

      , geo_region

      , translated_country_code

      , country_name as country

      , CASE WHEN product_type_identifier like '%IA%' then 'IAP' ELSE 'APP' END AS purchase_type

      , SUM(CASE WHEN product_type_identifier like '%IA%' THEN units ELSE 0 END) as transactions

      , SUM(CASE WHEN product_type_identifier IN ('1F','1','1T','UNK') THEN units ELSE 0 END) as downloads

      , SUM(developer_proceeds* units/conversion_factor) as revenue

      FROM wbie_external_sales.ITUNESCONNECT_SALESDAILYSUMMARY as a

      join reference_data.GEOGRAPHY b on a.country_code = b.country_code_upper

      join reference_data.currency_exchange_rates as c on a.begin_dt = c.request_date and a.customer_currency = c.currency_code

      where begin_dt >= current_date -120

      GROUP BY 1,2,3,4,5,6

      )

      , revenue_and AS (

      SELECT order_charged_date as begin_date

      , geo_region

      , translated_country_code

      , country_name as country

      , product_id AS sku

      --, product_id AS title

      , CASE

      when product_type = 'paidapp' then 'APP'

      when product_type = 'inapp' then 'IAP'

      ELSE 'Unknown' END AS purchase_type

      --, 'purchase' AS metric

      , count(1) as transactions

      , SUM((charged_amount-taxes_collected)* 0.7/conversion_factor) AS revenue

      FROM wbie_external_sales.GOOGLE_PLAY_SALES as a

      join reference_data.GEOGRAPHY b on a.country_of_buyer = b.country_code_upper

      join reference_data.currency_exchange_rates as c on a.order_charged_date = c.request_date and a.currency_of_sale = c.currency_code

      where order_charged_date >= current_date -120

      GROUP BY 1,2,3,4,5,6

      )

      , installs AS (

      SELECT

      install_date AS begin_date

      , geo_region

      , translated_country_code

      , country_name as country

      , app_package AS sku

      --, package_name AS title

      , 'install' AS purchase_type

      --, count(1) as transactions

      , SUM(daily_user_installs) AS downloads

      FROM wbie_external.google_play_installs as a

      LEFT JOIN reference_data.GEOGRAPHY b on a.country = b.country_code_upper

      GROUP BY 1,2,3,4,5,6--,7,8

      )

      , most_recent_records as (SELECT

      'apple' AS platform

      , begin_date

      , geo_region

      , translated_country_code

      , country

      , case when sku = '1' then 'com.playdemic.villagelife'

      when sku = '1000199' then 'com.playdemic.gangnations'

      else sku end as sku

      , purchase_type

      , downloads

      , transactions

      , revenue

      FROM revenue

      union all

      SELECT 'google' AS platform

      ,r.begin_date AS begin_date

      , r.geo_region

      , r.translated_country_code

      , r.country

      , COALESCE(r.sku, i.sku) AS sku

      , COALESCE(r.purchase_type, i.purchase_type) AS purchase_type

      ,i.downloads as downloads

      , r.transactions

      , r.revenue

      FROM revenue_and r left join installs i on r.begin_date = i.begin_date and r.sku = i.sku and r.country = i.country

      )

      , aggregate as (

      SELECT platform, geo_region AS region, begin_date

      , CASE WHEN country IN ('United States', 'United Kingdom','Australia','Russia','Canada','Mexico','Brazil','France','Germany','China','Singapore','Italy','Turkey','Japan') THEN country ELSE 'Other' END AS country_top20

      , CASE WHEN country IN ('United States', 'United Kingdom','Australia','Russia','Canada','Mexico','Brazil','France','Germany','China','Singapore','Italy','Turkey','Japan') THEN country ELSE 'Other' END AS country_cd_top20

      , purchase_type, CASE WHEN platform = 'apple' and sku = 'com.wb.shadowofwar' then 'WB_SOW_2017' else sku end as sku

      , CASE WHEN DATE_DIFF('day', begin_date , current_date) <= 60 THEN date_part(week,current_date) - date_part(week,begin_date ) END as weeks_ago

      , CASE WHEN DATE_DIFF('month', begin_date ,current_date) <= 4 THEN

      date_part(month,current_date) - date_part(month, begin_date ) END AS months_ago

      , CASE WHEN DATE_DIFF('month', begin_date, current_date) <= 4 THEN

      to_char(begin_date,'YYYY-MM') END AS month_of

      , CASE WHEN date_part(year, current_date) = date_part(year, begin_date) THEN 0 ELSE 1 END AS years_ago

      , SUM(transactions) AS transactions

      , SUM(downloads) AS downloads

      , SUM(revenue) AS revenue

      FROM most_recent_records

      GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11

      )

      , forecasts AS (

      select * from (

      with sub1 AS (

      SELECT *

      , CASE

      WHEN platform = 'iOS' THEN 'apple'

      WHEN platform = 'Android' THEN 'google'

      ELSE 'Total' END as platform_new

      , CASE

      WHEN title = 'Batman Arkham Underworld' THEN 'Batman: Arkham Underworld'

      WHEN title = 'DC Comics Legend' THEN 'DC Comics Legends'

      WHEN title = 'Extra Open Wager' THEN ''

      WHEN title = 'Fantastic Beasts' THEN 'Fantastic Beasts'

      WHEN title = 'Injustice: Gods Among Us' THEN 'Injustice: Gods Among Us'

      WHEN title = 'Injustice 2' THEN 'Injustice 2'

      WHEN title = 'LEGO Batman 3' THEN 'LEGO Batman: Beyond Gotham'

      WHEN title = 'LEGO Batman 2' THEN 'LEGO Batman: DC Super Heroes'

      WHEN title = 'LEGO Friends' THEN 'LEGO Friends'

      WHEN title = 'LEGO LOTR' THEN 'LEGO The Lord of the Rings'

      WHEN title = 'LEGO Marvel' THEN 'LEGO Marvel Super Heroes: Universe in Peril'

      WHEN title = 'LEGO Star Wars: Ep 7' THEN 'LEGO Star Wars: The Force Awakens'

      WHEN title = 'LEGO Jurassic World' THEN 'LEGO Jurassic World'

      WHEN title = 'LEGO HP1-4' THEN 'LEGO Harry Potter: Years 1-4'

      WHEN title = 'LEGO HP5-7' THEN 'LEGO Harry Potter: Years 5-7'

      WHEN title = 'LEGO Movie' THEN 'LEGO Movie Video Game'

      WHEN title = 'LEGO Ninjago' THEN 'LEGO Ninjago: Shadow of Ronin'

      WHEN title = 'LEGO SWCS' THEN 'LEGO Star Wars: The Complete Saga'

      WHEN title = 'LEGO SWMF' THEN 'LEGO Star Wars: Microfighters'

      WHEN title = 'Mortal Kombat X' THEN 'Mortal Kombat X'

      WHEN title = 'Scribblenauts Unlimited' THEN 'Scribblenauts Unlimited'

      WHEN title = 'Scribblenauts Remix' THEN 'Scribblenauts Remix'

      WHEN title = 'WWE: Immortals' THEN 'WWE Immortals'

      WHEN title = 'Golf Clash' THEN 'Golf Clash'

      WHEN title = 'Village Life' THEN 'Village Life'

      WHEN title = 'Leviathan' THEN 'Middle-earth: Shadow of War'

      WHEN title = 'Game of Thrones' THEN 'Game of Thrones: Conquest'

      ELSE 'Other' END AS title_new

      , CASE

      WHEN forecasted_month = '2100-01-01' THEN '2100-01-01'

      WHEN forecasted_month = '2016-12-31' THEN '2016-01-01'

      ELSE forecasted_month END AS date_new

      FROM wbie_external.forecast_monthly_temp_sc

      WHERE

      forecasted_month != '2100-01-01'

      ---- AND FORMAT_DATETIME(date_add('day', TRY_CAST(check AS BIGINT), timestamp '1899-12-30'), 'yyyy-MM-dd') != '2017-12-31'

      and forecasted_month != '2017-12-31'

      and forecast_type = 'POS Net IAP Revenue'

      AND platform != 'Total'

      )

      , sub2_ads AS (

      SELECT *

      , CASE

      WHEN platform = 'iOS' THEN 'apple'

      WHEN platform = 'Android' THEN 'google'

      ELSE 'Total' END as platform_new

      , CASE

      WHEN title = 'Batman Arkham Underworld' THEN 'Batman: Arkham Underworld'

      WHEN title = 'DC Comics Legend' THEN 'DC Comics Legends'

      WHEN title = 'Extra Open Wager' THEN ''

      WHEN title = 'Fantastic Beasts' THEN 'Fantastic Beasts'

      WHEN title = 'Injustice: Gods Among Us' THEN 'Injustice: Gods Among Us'

      WHEN title = 'Injustice 2' THEN 'Injustice 2'

      WHEN title = 'LEGO Batman 3' THEN 'LEGO Batman: Beyond Gotham'

      WHEN title = 'LEGO Batman 2' THEN 'LEGO Batman: DC Super Heroes'

      WHEN title = 'LEGO Friends' THEN 'LEGO Friends'

      WHEN title = 'LEGO LOTR' THEN 'LEGO The Lord of the Rings'

      WHEN title = 'LEGO Marvel' THEN 'LEGO Marvel Super Heroes: Universe in Peril'

      WHEN title = 'LEGO Star Wars: Ep 7' THEN 'LEGO Star Wars: The Force Awakens'

      WHEN title = 'LEGO Jurassic World' THEN 'LEGO Jurassic World'

      WHEN title = 'LEGO HP1-4' THEN 'LEGO Harry Potter: Years 1-4'

      WHEN title = 'LEGO HP5-7' THEN 'LEGO Harry Potter: Years 5-7'

      WHEN title = 'LEGO Movie' THEN 'LEGO Movie Video Game'

      WHEN title = 'LEGO Ninjago' THEN 'LEGO Ninjago: Shadow of Ronin'

      WHEN title = 'LEGO SWCS' THEN 'LEGO Star Wars: The Complete Saga'

      WHEN title = 'LEGO SWMF' THEN 'LEGO Star Wars: Microfighters'

      WHEN title = 'Mortal Kombat X' THEN 'Mortal Kombat X'

      WHEN title = 'Scribblenauts Unlimited' THEN 'Scribblenauts Unlimited'

      WHEN title = 'Scribblenauts Remix' THEN 'Scribblenauts Remix'

      WHEN title = 'WWE: Immortals' THEN 'WWE Immortals'

      WHEN title = 'Golf Clash' THEN 'Golf Clash'

      WHEN title = 'Village Life' THEN 'Village Life'

      WHEN title = 'Leviathan' THEN 'Middle-earth: Shadow of War'

      WHEN title = 'Game of Thrones' THEN 'Game of Thrones: Conquest'

      ELSE 'Other' END AS title_new

      , CASE

      WHEN forecasted_month = '2100-01-01' THEN '2100-01-01'

      WHEN forecasted_month = '2016-12-31' THEN '2016-01-01'

      ELSE forecasted_month END AS date_new

      FROM wbie_external.forecast_monthly_temp_sc

      WHERE

      forecasted_month != '2100-01-01'

      ---- AND FORMAT_DATETIME(date_add('day', TRY_CAST(check AS BIGINT), timestamp '1899-12-30'), 'yyyy-MM-dd') != '2016-12-31'

      and forecasted_month != '2016-12-31'

      AND forecast_type = 'POS Net Ad Revenue'

      AND platform != 'Total'

      )

      , ult AS (

      SELECT *

      FROM wbie_external.forecast_monthly_temp_sc

      WHERE

      forecasted_month = '2100-01-01'

      AND

      forecast_type = 'POS Net IAP Revenue'

      AND platform != 'Total'

      )

      , yearly AS (

      SELECT forecasted_month, title, platform, forecast_type, p_l

      FROM wbie_external.forecast_monthly_temp_sc

      WHERE

      forecasted_month = '2018-12-31'

      and forecast_type = 'POS Net IAP Revenue'

      AND platform != 'Total'

      )

      , ult_ad AS (

      SELECT *

      FROM wbie_external.forecast_monthly_temp_sc

      WHERE

      forecasted_month = '2100-01-01'

      and forecast_type = 'POS Net Ad Revenue'

      AND platform != 'Total'

      )

      , yearly_ad AS (

      SELECT forecasted_month, title, platform, forecast_type, p_l

      FROM wbie_external.forecast_monthly_temp_sc

      WHERE

      forecasted_month = '2018-12-31'

      and forecast_type = 'POS Net Ad Revenue'

      AND platform != 'Total'

      )

      SELECT sub1.*

      , sub2_ads.p_l AS p_l_ads

      , ult.p_l AS ultimates

      , yearly.p_l AS year2016

      , ult_ad.p_l AS ultimates_ad

      , yearly_ad.p_l AS year2016_ad

      FROM sub1

      LEFT JOIN sub2_ads ON sub1.title = sub2_ads.title AND sub1.platform = sub2_ads.platform AND sub1.date_new = sub2_ads.date_new

      LEFT JOIN ult ON sub1.title = ult.title AND sub1.platform = ult.platform

      LEFT JOIN yearly ON sub1.title = yearly.title AND sub1.platform = yearly.platform

      LEFT JOIN ult_ad ON sub1.title = ult_ad.title AND sub1.platform = ult_ad.platform

      LEFT JOIN yearly_ad ON sub1.title = yearly_ad.title AND sub1.platform = yearly_ad.platform

      )

      )

      , almost_there as (

      select a.*, b.wb_game_name, lego_filter, report_filter, studio_name_filter,display_name_filter

      , ROW_NUMBER() OVER(PARTITION BY platform, wb_game_name, months_ago ORDER BY weeks_ago ASC) AS rank_asc

      from aggregate as a

      join wbie_product_master.product_master_mobile as b on a.sku=b.parent_product_key

      where report_filter = 'Y'

      group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19

      )

      , final as (

      SELECT

      almost_there.*, to_char(date_new,'YYYY-MM') as month, title_new, platform_new,date_new

      , CASE WHEN rank_asc = 1 and begin_date is not null THEN p_l when begin_date is null then p_l ELSE null END AS p_l

      --- , CASE WHEN rank_asc = 1 and begin_date is not null THEN ultimates when begin_date is null then ultimates ELSE null END AS ultimates

      --- , CASE WHEN rank_asc = 1 THEN year2016 ELSE null END AS year2016

      , CASE WHEN rank_asc = 1 and begin_date is not null THEN p_l_ads when begin_date is null then p_l_ads ELSE null END AS p_l_ads

      ---- , CASE WHEN rank_asc = 1 THEN ultimates_ad ELSE null END AS ultimates_ad

      ---- , CASE WHEN rank_asc = 1 THEN year2016_ad ELSE null END AS year2016_ad

      , case when wb_game_name in ( 'Golf Clash', 'Injustice 2', 'Middle-earth: Shadow of War', 'Mortal Kombat X','DC Comics Legends', 'Injustice: Gods Among Us','WWE Immortals','Batman: Arkham Underworld','Fantastic Beasts: Cases from the Wizarding World','Game of Thrones: Conquest','Westworld') then wb_game_name

      when wb_game_name like '%LEGO%' then 'LEGO Titles'

      when wb_game_name like '%Scribble%' then 'Scribblenauts Titles'

      else 'Others' end as Email_Display_Title

      --- , case when studio_name_filter = 'Catalog' then 'Catalog' else 'Primary Titles' end as Revenue_Display

      from forecasts

      LEFT JOIN almost_there

      ON almost_there.wb_game_name = forecasts.title_new AND almost_there.platform = forecasts.platform_new AND almost_there.month_of = to_char(forecasts.date_new,'YYYY-MM')

      where date_new not in ('2018-12-31')

      ---where months_ago = '0'

      )

      , sub as (

      select title_new as wb_game_name, platform_new as platform, month, max(p_l) as forecast_revenue, max(p_l_ads) as forecast_ads

      from final

      where date_part(qtr, date_new) = date_part(qtr,current_date)

      group by 1,2,3

      )

      , sub1 as (

      select wb_game_name, sum(forecast_revenue) as forecast_revenue, sum(forecast_ads) as forecast_ads

      from sub

      group by 1

      )

      , sub2 as (

      select wb_game_name, begin_date, sum(revenue) as revenue

      from final

      where date_part(qtr, begin_date) = date_part(qtr,current_date)

      group by 1,2

      )

      , sub3 as (select d as date_dates, wb_game_name

      from reference_data.dates as a

      cross join almost_there

      where date_part(qtr,d) = date_part(qtr,current_date)

      and date_part(year,d) = 2018

      group by 1,2

      )

      , sub4 as (

      select a.wb_game_name, forecast_revenue, forecast_ads, count(distinct date_dates) as date_count

      from sub1 as a

      join sub3 as b on a.wb_game_name = b.wb_game_name

      group by 1 ,2,3

      )

      , sub5 as (

      select wb_game_name, sum(case when forecast_revenue is null then 0 else forecast_revenue end + case when forecast_ads is null then 0 else forecast_ads end)/sum(date_count ) as avg_forecast

      from sub4

      group by 1

      )

      , sub6 as(select a.wb_game_name, date_dates, b.avg_forecast

      from sub3 as a

      left join sub5 as b on a.wb_game_name = b.wb_game_name

      ---group by 1,2,3

      )

      select a.wb_game_name, a.date_dates, avg_forecast*1000 as avg_forecast, revenue

      from sub6 as a

      left join sub2 as b on a.wb_game_name = b.wb_game_name and a.date_dates= b.begin_date

      ;;

    }

    measure: count {

      type: count

      drill_fields: [detail*]

    }

    dimension: wb_game_name {

      type: string

      sql: ${TABLE}.wb_game_name ;;

    }

    dimension: date_dates {

      type: date

      sql: ${TABLE}.date_dates ;;

    }

    measure: avg_forecast {

      type: sum

      sql: ${TABLE}.avg_forecast ;;

      value_format_name: decimal_0

    }

    measure: revenue {

      type: sum

      sql: ${TABLE}.revenue ;;

      value_format_name: decimal_0

    }

    dimension: is_past{

      type: number

      sql: CASE WHEN ${date_dates} > CURRENT_DATE THEN NULL ELSE 1 END ;;

      hidden: yes

    }

    dimension: days_from_today{

      type: number

      sql: DATEDIFF(${date_dates}, current_date);;

    }

    dimension: days_from_today_past{

      type: number

      sql: DATEDIFF(${date_dates}, current_date)*${is_past};;

    }

    set: detail {

      fields: [wb_game_name, date_dates, avg_forecast, revenue,is_past,days_from_today,days_from_today_past]

    }

  }
