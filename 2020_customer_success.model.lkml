connection: "video_store"

include: "*.view"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

include: "2020_base_model.model.lkml"


explore: customer_success {
  hidden: no
  extends: [payment]
  view_name: payment

  join: staff {
    fields: [] # staff.store_id]
  }
}
