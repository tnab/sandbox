view: audience_exploration {

  filter: brand_filter {
    label: "Brand Filter"
    type: string
    suggestions:
    [
      "Aldi",
      "BestBuy",
      "CVSPharmacy",
      "CheesecakeFactory",
      "ChoiceHotels",
      "CostConscious",
      "DicksSportingGoods",
      "DoubleTreebyHilton",
      "EconoLodge",
      "Hilton",
      "HomeDepot",
      "IHOP",
      "InnOutBurger",
      "Kohls",
      "Kroger",
      "Macys",
      "McDonalds",
      "NeimanMarcus",
      "OldNavy",
      "Premium",
      "REI",
      "RiteAid",
      "StRegis",
      "Starbucks",
      "TJMaxx",
      "TacoBell",
      "Target",
      "Walmart",
      "WholeFoods",
    ]
  }

  filter: lookback_days {
    label: "Lookback Days Filter"
    type: number
    suggestions:
    ["30", "60", "90", "120"]

  }

  filter: dma_filter {
    label: "DMA Filter"
    type: string
    suggestions:
    [
      "Portland-Auburn ME (500)",
      "New York NY (501)",
      "Binghamton NY (502)"
    ]
  }

  derived_table: {
    sql:
    select G.brand,
    G.audience_size,
    G.overlap_size,
    G.selected_size,
    H.total_size,
    (G.overlap_size * H.total_size) / (audience_size * selected_size) as index
    from
    (
    select 1 as join_key,
    E.audience_attribute_id,
    E.brand,
    E.audience_size,
    E.overlap_size,
    F.selected_size
    from
    (
    select 1 as join_key,
    C.audience_attribute_id,
    D.brand,
    C.audience_size,
    C.overlap_size
    from
    (
    select A.audience_attribute_id,
    A.audience_size,
    B.overlap_size
    from
    (
    --audience size
    select audience_attribute_id, count(*) audience_size
    from consumer_analytics.fact_device
    where audience_attribute_id in
    (
    select audience_attribute_id
    from consumer_analytics.dim_audience
    where {% condition lookback_days %} lookback {% endcondition %}
    and audience_attribute_id !=
    (
    select audience_attribute_id
    from consumer_analytics.dim_audience
    where {% condition brand_filter %} brand {% endcondition %}
    and {% condition lookback_days %} lookback {% endcondition %}
    )
    )
    and dma_code like '%'

    group by audience_attribute_id
    ) A
    inner join
    (
    -- relevant audiences
    select ra.audience_attribute_id, count(*) as overlap_size
    from
    (
    select audience_attribute_id, device_key
    from consumer_analytics.fact_device
    where audience_attribute_id in
    (
    select audience_attribute_id
    from consumer_analytics.dim_audience
    where {% condition lookback_days %} lookback {% endcondition %}
    and audience_attribute_id !=
    (
    select audience_attribute_id
    from consumer_analytics.dim_audience
    where {% condition brand_filter %} brand {% endcondition %}
    and {% condition lookback_days %} lookback {% endcondition %}
    )
    )
    and dma_code like '%'
    ) ra
    inner join
    (
    select device_key
    from consumer_analytics.fact_device
    where audience_attribute_id =
    (
    select audience_attribute_id
    from consumer_analytics.dim_audience
    where {% condition brand_filter %} brand {% endcondition %}
    and {% condition lookback_days %} lookback {% endcondition %}
    )
    and dma_code like '%'
    ) rd
    on ra.device_key = rd.device_key
    group by ra.audience_attribute_id
    ) B
    on A.audience_attribute_id = B.audience_attribute_id
    ) C
    inner join
    (
    select brand, audience_attribute_id
    from consumer_analytics.dim_audience
    ) D
    on C.audience_attribute_id = D.audience_attribute_id
    ) E
    inner join
    (
    select 1 as join_key, count(*) selected_size
    from consumer_analytics.fact_device
    where audience_attribute_id = (
    select audience_attribute_id
    from consumer_analytics.dim_audience
    where {% condition brand_filter %} brand {% endcondition %}
    and {% condition lookback_days %} lookback {% endcondition %}
    )
    and dma_code like '%'
    ) F
    on E.join_key = F.join_key
    ) G
    inner join
    (
    select 1 as join_key, count(*) as total_size
    from consumer_analytics.fact_device
    where audience_attribute_id in (
    select audience_attribute_id
    from consumer_analytics.dim_audience
    where {% condition lookback_days %} lookback {% endcondition %}
    )
    and dma_code like '%'
    ) H
    on G.join_key = H.join_key
    order by index desc
    ;;
  }

  dimension: brand {
    type: string
    suggestable: no
    sql: ${TABLE}.BRAND ;;
  }

  dimension: audience_size {
    type: number
    suggestable: no
    sql: ${TABLE}.audience_size ;;
  }

  dimension: overlap_size {
    type: number
    suggestable: no
    sql: ${TABLE}.overlap_size ;;
  }

  dimension: selected_size {
    type: number
    suggestable: no
    sql: ${TABLE}.selected_size ;;
  }

  dimension: total_size {
    type: number
    suggestable: no
    sql: ${TABLE}.total_size ;;
  }

  dimension: index {
    type: number
    suggestable: no
    sql: ${TABLE}.index ;;
  }

}
