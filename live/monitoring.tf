resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${local.env}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0, y = 0, width = 12, height = 6,
        properties = {
          region = var.aws_region,
          title  = "ALB: RequestCount / TargetResponseTime",
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", module.alb.lb_arn_suffix],
            [".", "TargetResponseTime", ".", module.alb.lb_arn_suffix]
          ]
        }
      },
      {
        type = "metric",
        x    = 12, y = 0, width = 12, height = 6,
        properties = {
          region = var.aws_region,
          title  = "ALB: HealthyHostCount",
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", module.alb.tg_arn_suffix, "LoadBalancer", module.alb.lb_arn_suffix]
          ]
        }
      }
    ]
  })
}
