connection: "video_store"

include: "*.view"
include: "*.dashboard"

datagroup: 2020_model_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: 2020_model_default_datagroup

explore: payment {
#   hidden: yes

  join: rental {
    type: inner
    relationship: one_to_one
    sql_on: ${payment.rental_id} = ${rental.rental_id} ;;
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${payment.customer_id} = ${customer.customer_id} ;;
  }

  join: inventory {
    type: inner
    relationship: one_to_one
    sql_on: ${rental.inventory_id} = ${inventory.inventory_id} ;;
  }

  join: film {
    type: inner
    relationship: many_to_one
    sql_on: ${inventory.film_id} = ${film.film_id} ;;
  }

  join: store {
    type: inner
    relationship: many_to_one
    sql_on: ${inventory.store_id} = ${store.store_id} ;;
  }

  join: staff {
    type: inner
    relationship: one_to_many
    sql_on: ${store.store_id} = ${staff.store_id} ;;
  }

  join: late_fee_wash_eligible {
    view_label: "Rental"
    type: left_outer
    relationship: many_to_one
    sql_on: ${rental.rental_id} = ${late_fee_wash_eligible.wash_rental_id} ;;
  }

}
