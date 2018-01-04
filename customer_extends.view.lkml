include: "customer.view.lkml"
view: customer_extends {
  extends: [customer]

  dimension: customer_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }
}
