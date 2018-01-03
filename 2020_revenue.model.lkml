connection: "video_store"

include: "*.view"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

include: "2020_base_model.model.lkml"


explore: revenue {
  hidden: no
  extends: [payment]
  view_name: payment

  join: customer_extends {
    fields: [customer_extends.customer_id]
    type: left_outer
    relationship: many_to_one
    sql_on: ${payment.customer_id} = ${customer_extends.customer_id} ;;
  }

  join: customer {
    fields: []
  }

  join: customer_facts {
    type: inner
    relationship: one_to_one
    sql_on: ${customer_extends.customer_id} = ${customer_facts.customer_id} ;;
  }
}
