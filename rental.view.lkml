view: rental {
  sql_table_name: sakila.rental ;;

  dimension: rental_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.rental_id ;;
  }

  dimension: customer_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: inventory_id {
    type: number
    sql: ${TABLE}.inventory_id ;;
  }

  dimension_group: last_update {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_update ;;
  }

  dimension_group: rental {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.rental_date ;;
  }

  dimension_group: return {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.return_date ;;
  }

  dimension: late_fee_incurred {
    type: yesno
    sql: DATEDIFF(${return_date}, ${rental_date}) > 3 ;;
  }

  dimension: 1st_week_late {
    type: date
    sql: CASE WHEN ${late_fee_incurred} THEN DATE_ADD(${rental_date}, INTERVAL 3 DAY) ELSE NULL END ;;
  }

  dimension: staff_id {
    type: number
    sql: ${TABLE}.staff_id ;;
  }

  measure: count {
    type: count
    drill_fields: [rental_id, customer.customer_id, customer.last_name, customer.first_name]
  }
}
