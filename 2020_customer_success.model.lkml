connection: "video_store"

include: "*.view"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

include: "2020_base_model.model.lkml"


explore: customer_success {
  hidden: no
  extends: [payment]
  view_name: payment
  access_filter: {
    field: store.store_id
    user_attribute: store_id
  }

  join: staff {
    fields: []
  }
}
