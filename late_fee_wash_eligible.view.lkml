view: late_fee_wash_eligible {
  derived_table: {
    sql:
      /* returns the elgible late fee rentals that don't have a return date within the first week after after the 3 day period in which a late fee is incurred | */
        SELECT
          rental.customer_id  AS `rental.customer_id`,
          late_fee_wash_eligible.`rental.rental_id`  AS late_fee_wash_eligible_rental_rental_id,
          COUNT(rental.rental_id ) AS `rental.count`
        FROM
            (SELECT
                customer.customer_id  AS `customer.customer_id`,
                rental.rental_id  AS `rental.rental_id`,
                DATE(rental.rental_date ) AS `rental.rental_date`,
                DATE(CASE WHEN (DATEDIFF((DATE(rental.return_date )), (DATE(rental.rental_date ))) > 3) THEN DATE_ADD((DATE(rental.rental_date )), INTERVAL 3 DAY) ELSE NULL END ) AS `rental.1st_week_late`,
                DATE(CASE WHEN (DATEDIFF((DATE(rental.return_date )), (DATE(rental.rental_date ))) > 3) THEN DATE_ADD((DATE(rental.rental_date )), INTERVAL 10 DAY) ELSE NULL END ) AS `rental.1st_week_late_10_day_grace`,
                DATE(rental.return_date ) AS `rental.return_date`
              FROM sakila.payment  AS payment
              INNER JOIN sakila.rental  AS rental ON payment.rental_id = rental.rental_id
              LEFT JOIN sakila.customer  AS customer ON payment.customer_id = customer.customer_id

              WHERE (((DATE(CASE WHEN (DATEDIFF((DATE(rental.return_date )), (DATE(rental.rental_date ))) > 3) THEN DATE_ADD((DATE(rental.rental_date )), INTERVAL 3 DAY) ELSE NULL END )) < (DATE(rental.return_date ))) AND ((DATE(rental.return_date )) <= (DATE(CASE WHEN (DATEDIFF((DATE(rental.return_date )), (DATE(rental.rental_date ))) > 3) THEN DATE_ADD((DATE(rental.rental_date )), INTERVAL 10 DAY) ELSE NULL END ))))
              ) AS late_fee_wash_eligible
              /* the version of MySQL is 5.6 which doesn't support window functions | the workaround is to do a self join on engineered features for the week start date of a late fee as well as the end of the 7 day grace period date */
            LEFT JOIN sakila.rental  AS rental ON rental.customer_id = (late_fee_wash_eligible.`customer.customer_id`)
            AND
             ((DATE(late_fee_wash_eligible.`rental.1st_week_late` )) <= (DATE(rental.rental_date ))
            AND
            (DATE(rental.rental_date )) <= (DATE(late_fee_wash_eligible.`rental.1st_week_late_10_day_grace` )))
        GROUP BY 1,2
        /* since there will be fanout in the date join above (incidcating that there were multiple rentals within the wash grace period), the late fee flag will be any customers who have of 0 count of rentals within that period | anything above 0 will have their late fee forgiven */
        HAVING COUNT(rental.rental_id ) > 0
      ;;
    datagroup_trigger: 2020_customer_facts
    indexes: ["late_fee_wash_eligible_rental_rental_id"]
  }

  measure: count_washed_late_fees {
    type: count
  }

  dimension: wash_late_fee_customer_id {
    type: number
    sql: ${TABLE}.`rental.customer_id` ;;
  }

  dimension: wash_rental_id {
#     hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.late_fee_wash_eligible_rental_rental_id ;;
  }

#   dimension: wash_rental_counts {
#     type: number
#     sql: ${TABLE}.`rental.count` ;;
#   }

}
