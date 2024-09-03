data "aws_iam_policy_document" "assume_role" {
  count = var.retain_count == 0? 0 : 1
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "dlm_lifecycle_role" {
  count = var.retain_count == 0 ? 0 : 1
  name               = "dlm-lifecycle-role${var.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

data "aws_iam_policy_document" "dlm_lifecycle" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateSnapshots",
      "ec2:DeleteSnapshot",
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:EnableFastSnapshotRestores",
      "ec2:DescribeFastSnapshotRestores",
      "ec2:DisableFastSnapshotRestores",
      "ec2:CopySnapshot",
      "ec2:ModifySnapshotAttribute",
      "ec2:DescribeSnapshotAttribute",
      "ec2:DescribeSnapshotTierStatus",
      "ec2:ModifySnapshotTier",
      // Add EventBridge rules management permissions
      "events:PutRule",
      "events:DeleteRule",
      "events:DescribeRule",
      "events:EnableRule",
      "events:DisableRule",
      "events:ListTargetsByRule",
      "events:PutTargets",
      "events:RemoveTargets"
    ]

    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:aws:ec2:*::snapshot/*"]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "ec2:CreateTags",
      // Permissions for managing EventBridge rules
      "events:PutRule",
      "events:DeleteRule",
      "events:DescribeRule",
      "events:EnableRule",
      "events:DisableRule",
      "events:ListTargetsByRule",
      "events:PutTargets",
      "events:RemoveTargets"
    ]
    resources = ["arn:aws:events:*:*:rule/AwsDataLifecycleRule.managed-cwe.*"]
  }

}

resource "aws_iam_role_policy" "dlm_lifecycle" {
  count = var.retain_count == 0 ? 0 : 1
  name   = "dlm-lifecycle-policy"
  role   = aws_iam_role.dlm_lifecycle_role[0].id
  policy = data.aws_iam_policy_document.dlm_lifecycle.json
}

resource "aws_dlm_lifecycle_policy" "snap" {
  count = var.retain_count == 0 ? 0 : 1
  description        = "example DLM lifecycle policy"
  execution_role_arn = aws_iam_role.dlm_lifecycle_role[0].arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "Scheduled Backups"

      create_rule {
        cron_expression = var.cron_expression
      }

      retain_rule {
        count = var.retain_count
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = false
    }

    target_tags = {
      "InstanceID:DeviceName" = "${var.instance_id}:${var.dev}"
    }
  }

  tags = {
    Name = "${var.name_suffix}"
  }
}

resource "aws_volume_attachment" "attach" {
  device_name = var.dev
  volume_id   = aws_ebs_volume.volume.id
  instance_id = var.instance_id
}

resource "aws_ebs_volume" "volume" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.type
  tags = {
    "InstanceID:DeviceName" = "${var.instance_id}:${var.dev}"
    Name = "${var.name_suffix}"
  }
}
