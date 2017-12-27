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
}
