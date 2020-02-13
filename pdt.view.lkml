explore: pdt {}

view: pdt {

  derived_table: {
    distribution_style: all
    sql: SELECT
        id as user_id
        , COUNT(*) as lifetime_users
        , users.created_at as created_at
      FROM users
      GROUP BY user_id, created_at
      ;;

    #  persist_for: "24 hours"
    sql_trigger_value: SELECT CURRENTDATE() ;;
      publish_as_db_view: yes
  }

  # Define your dimensions and measures here, like this:
  dimension: primary_key {
    type: number
    sql: concat(${user_id}, ${purchase_date}) ;;
    primary_key: yes
    hidden:  yes
  }

  dimension: user_id {
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_users {
    description: "The total number of orders for each user"
    type: number
    sql: ${TABLE}.lifetime_users ;;
  }

  dimension_group: purchase {
    description: "The date when each user last ordered"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.created_at ;;
  }

  measure: total_lifetime_users {
    description: "Use this for counting lifetime orders across many users"
    type: sum
    sql: ${lifetime_users} ;;
  }
}
