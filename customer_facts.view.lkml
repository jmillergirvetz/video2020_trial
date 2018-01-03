view: customer_facts {
  derived_table: {
    sql: SELECT
        customer.customer_id  AS `customer.customer_id`,
        MAX(DATE(rental.rental_date )) AS `most_recent_rental.rental_date`,
        MIN(DATE(customer.create_date )) AS `customer.create_date`,
        (COALESCE(SUM(payment.amount ), 0)) + (COALESCE(SUM(CASE WHEN DATEDIFF((DATE(rental.return_date )), (DATE(rental.rental_date ))) > 3  THEN 3  ELSE NULL END), 0)) - (COALESCE(SUM(CASE WHEN (late_fee_wash_eligible.`rental.customer_id`) IS NOT NULL  THEN 3  ELSE NULL END), 0))  AS `payment.total_revenue`,
        COALESCE(SUM(CASE WHEN DATEDIFF((DATE(rental.return_date )), (DATE(rental.rental_date ))) > 3  THEN 3  ELSE NULL END), 0) AS `payment.total_fees`,
        COALESCE(SUM(CASE WHEN (late_fee_wash_eligible.`rental.customer_id`) IS NOT NULL  THEN 3  ELSE NULL END), 0) AS `payment.total_washed_late_fees`,
        COUNT(*) AS `rental.count`,
        COUNT(DISTINCT late_fee_wash_eligible.`late_fee_wash_eligible.rental_rental_id` ) AS `late_fee_wash_eligible.count_washed_late_fees`
      FROM sakila.payment  AS payment
      INNER JOIN sakila.rental  AS rental ON payment.rental_id = rental.rental_id
      LEFT JOIN sakila.customer  AS customer ON payment.customer_id = customer.customer_id
      LEFT JOIN ${late_fee_wash_eligible.SQL_TABLE_NAME} AS late_fee_wash_eligible
      ON rental.rental_id = (late_fee_wash_eligible.`late_fee_wash_eligible.rental_rental_id`)
      GROUP BY 1
       ;;
  }

  dimension: customer_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.`customer.customer_id` ;;
  }

  dimension: most_recent_rental_rental_date {
    type: date
    sql: ${TABLE}.`most_recent_rental.rental_date` ;;
  }

  dimension: customer_create_date {
    type: date
    sql: ${TABLE}.`customer.create_date` ;;
  }

  dimension: payment_total_revenue {
    type: number
    value_format_name: usd
    sql: ${TABLE}.`payment.total_revenue` ;;
  }

  measure: avg_lifetime_revenue {
    type: average
    value_format_name: usd
    sql: ${payment_total_revenue} ;;
  }

  dimension: payment_total_fees {
    type: number
    value_format_name: usd
    sql: ${TABLE}.`payment.total_fees` ;;
  }

  dimension: payment_total_washed_late_fees {
    type: number
    value_format_name: usd
    sql: ${TABLE}.`payment.total_washed_late_fees` ;;
  }

  dimension: rental_count {
    type: number
    sql: ${TABLE}.`rental.count` ;;
  }

  dimension: late_fee_wash_eligible_count_washed_late_fees {
    type: number
    sql: ${TABLE}.`late_fee_wash_eligible.count_washed_late_fees` ;;
  }
}
