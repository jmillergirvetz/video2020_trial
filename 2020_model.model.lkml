connection: "video_store"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: 2020_model_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: 2020_model_default_datagroup

explore: payment {

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
    relationship: many_to_one
    sql_on: ${store.store_id} = ${staff.store_id} ;;
  }

}
