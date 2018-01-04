view: payment {
  sql_table_name: sakila.payment ;;

  dimension: payment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.payment_id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount  ;;
  }

  measure: total_rev_no_fee {
    hidden: yes
    type: sum
    value_format_name: usd
    sql: ${amount} ;;
  }

  measure: total_fees {
    type: sum
    value_format_name: usd
    sql: 3 ;;
    filters: {
      field: rental.late_fee_incurred
      value: "Yes"
    }
  }

  measure: total_washed_late_fees {
    type: sum
    value_format_name: usd
    sql: 3 ;;
    filters: {
      field: rental.late_fee_wash
      value: "Yes"
    }
  }

  measure: total_revenue {
    type: number
    value_format_name: usd
    sql: ${total_rev_no_fee} + ${total_fees} - ${total_washed_late_fees} ;;
  }

  dimension: customer_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: last_update {
    hidden: yes
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

  dimension_group: payment {
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
    sql: ${TABLE}.payment_date ;;
  }

  dimension: rental_id {
    type: number
    hidden: yes
    sql: ${TABLE}.rental_id ;;
  }

  dimension: staff_id {
    type: number
    hidden: yes
    sql: ${TABLE}.staff_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      payment_id,
      customer.customer_id,
      customer.first_name,
      customer.last_name,
      staff.staff_id,
      staff.first_name,
      staff.last_name,
      staff.username,
      rental.rental_id
    ]
  }
}
