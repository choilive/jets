describe Jets::Cfn::TemplateBuilders::IamPolicy do
  let(:iam_policy) do
    Jets::Cfn::TemplateBuilders::IamPolicy.new(iam_policies)
  end

  context "single string" do
    let(:iam_policies) { ["ec2:*"] }
    it "provides the resource definition" do
      iam_policy_json = <<~EOL
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "Stmt1",
            "Action": [
              "ec2:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
          }
        ]
      }
      EOL
      expected_policy = JSON.load(iam_policy_json)
      expect(iam_policy.resource).to eq expected_policy
    end
  end

  context "multiple strings" do
    let(:iam_policies) { ["ec2:*", "logs:*"] }
    it "provides the resource definition" do
      iam_policy_json = <<~EOL
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "Stmt1",
            "Action": [
              "ec2:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
          },
          {
            "Sid": "Stmt2",
            "Action": [
              "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
          }
        ]
      }
      EOL
      expected_policy = JSON.load(iam_policy_json)
      expect(iam_policy.resource).to eq expected_policy
    end
  end

  context "single hash" do
    context "string keys" do
      let(:iam_policies) do
        [{
          "Sid" => "MyStmt1",
          "Action" => ["lambda:*"],
          "Effect" => "Allow",
          "Resource" => "arn:my-arn",
        }]
      end
      it "provides the resource definition" do
        iam_policy_json = <<~EOL
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "MyStmt1",
              "Action": ["lambda:*"],
              "Effect": "Allow",
              "Resource": "arn:my-arn"
            }
          ]
        }
        EOL
        expected_policy = JSON.load(iam_policy_json)
        expect(iam_policy.resource).to eq expected_policy
      end
    end

    context "symbol keys" do
      let(:iam_policies) do
        [{
          Sid: "MyStmt1",
          Action: ["lambda:*"],
          Effect: "Allow",
          Resource: "arn:my-arn",
        }]
      end
      it "provides the resource definition" do
        iam_policy_json = <<~EOL
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "MyStmt1",
              "Action": ["lambda:*"],
              "Effect": "Allow",
              "Resource": "arn:my-arn"
            }
          ]
        }
        EOL
        expected_policy = JSON.load(iam_policy_json)
        expect(iam_policy.resource).to eq expected_policy
      end
    end

    context "symbol keys with lowercase" do
      let(:iam_policies) do
        [{
          sid: "MyStmt1",
          action: ["lambda:*"],
          effect: "Allow",
          resource: "arn:my-arn",
        }]
      end
      it "provides the resource definition" do
        iam_policy_json = <<~EOL
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "MyStmt1",
              "Action": ["lambda:*"],
              "Effect": "Allow",
              "Resource": "arn:my-arn"
            }
          ]
        }
        EOL
        expected_policy = JSON.load(iam_policy_json)
        expect(iam_policy.resource).to eq expected_policy
      end
    end
  end

  context "multiple hashes" do
    context "symbol keys" do
      let(:iam_policies) do
        [{
          Sid: "MyStmt1",
          Action: ["lambda:*"],
          Effect: "Allow",
          Resource: "arn:my-arn",
        },{
          Sid: "MyStmt2",
          Action: ["logs:*"],
          Effect: "Allow",
          Resource: "*",
        }]
      end
      it "provides the resource definition" do
        iam_policy_json = <<~EOL
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "MyStmt1",
              "Action": ["lambda:*"],
              "Effect": "Allow",
              "Resource": "arn:my-arn"
            },
            {
              "Sid": "MyStmt2",
              "Action": ["logs:*"],
              "Effect": "Allow",
              "Resource": "*"
            }
          ]
        }
        EOL
        expected_policy = JSON.load(iam_policy_json)
        expect(iam_policy.resource).to eq expected_policy
      end
    end
  end


  context "special case hash with Version key" do
    context "symbol keys" do
      let(:iam_policies) do
        [{
          Version: "2012-10-17", # special case, a Version key will replace the entire policy
                                 # assumes that only one policy is passed in
          Statement: [{
            Sid: "MyStmt1",
            Action: ["lambda:*"],
            Effect: "Allow",
            Resource: "arn:my-arn",
          }]
        }]
      end
      it "provides the resource definition" do
        iam_policy_json = <<~EOL
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "MyStmt1",
              "Action": ["lambda:*"],
              "Effect": "Allow",
              "Resource": "arn:my-arn"
            }
          ]
        }
        EOL
        expected_policy = JSON.load(iam_policy_json)
        expect(iam_policy.resource).to eq expected_policy
      end
    end
  end
end
