{
  "AWSTemplateFormatVersion" : "2010-09-09",

  "Description" : "Node.js server",

  "Parameters" : {
    "KeyName" : {
      "Description" : "Name of an existing EC2 KeyPair to enable SSH access",
      "Type" : "String"
    },

    "InstanceType" : {
      "Type" : "String", 
      "Default" : "m1.small", 
      "AllowedValues" : [ "m1.small","m1.medium","m1.large","m1.xlarge","m2.xlarge","m2.2xlarge","m2.4xlarge","c1.medium","c1.xlarge","cc1.4xlarge"],
      "Description" : "EC2 instance type (e.g. m1.small)"
    },

    "SecurityGroupName" : {
      "Description" : "Security group name",
      "Type" : "String"
    }
  },

  "Mappings" : {
    "InstanceTypeArch" : {
      "m1.small"    : { "Arch" : "64" },
      "m1.medium"   : { "Arch" : "64" },
      "m1.large"    : { "Arch" : "64" },
      "m1.xlarge"   : { "Arch" : "64" },
      "m2.xlarge"   : { "Arch" : "64" },
      "m2.2xlarge"  : { "Arch" : "64" },
      "m2.4xlarge"  : { "Arch" : "64" },
      "c1.medium"   : { "Arch" : "64" },
      "c1.xlarge"   : { "Arch" : "64" },
      "cc1.4xlarge" : { "Arch" : "64HVM" }
    },

    "RegionImageZone" : {
      "us-east-1"      : { "64" : "ami-f565ba9c", "64HVM" : "ami-e965ba80" },
      "us-west-2"      : { "64" : "ami-30c64a00", "64HVM" : "NOT_YET_SUPPORTED" },
      "us-west-1"      : { "64" : "ami-d98cd49c", "64HVM" : "NOT_YET_SUPPORTED" },
      "eu-west-1"      : { "64" : "ami-ff231b8b", "64HVM" : "NOT_YET_SUPPORTED" },
      "ap-southeast-1" : { "64" : "ami-b23374e0", "64HVM" : "NOT_YET_SUPPORTED" },
      "ap-northeast-1" : { "64" : "ami-047bca05", "64HVM" : "NOT_YET_SUPPORTED" },
      "sa-east-1"      : { "64" : "ami-ae855bb3", "64HVM" : "NOT_YET_SUPPORTED" }
    }
  },

  "Resources" : {
    "CfnUser" : {
      "Type" : "AWS::IAM::User",
      "Properties" : {
        "Path": "/",
        "Policies": [ {
          "PolicyName": "root",
          "PolicyDocument": { "Statement": [ {
            "Effect":"Allow",
            "Action":"cloudformation:DescribeStackResource",
            "Resource":"*"
          } ] }
        } ]
      }
    },

    "HostKeys" : {
      "Type" : "AWS::IAM::AccessKey",
      "Properties" : {
        "UserName" : { "Ref" : "CfnUser" }
      }
    },

    "NodejsInstance" : {
      "Type" : "AWS::EC2::Instance",
      "Metadata" : {
        "AWS::CloudFormation::Init" : {
          "config" : {
            "packages" : {
              "rpm" : {
              "nodejs" : "http://nodejs.tchol.org/repocfg/amzn1/nodejs-stable-release.noarch.rpm"
              },
              "yum": {
              "gcc-c++": [],
              "make": [],
              "git" : [],
              "nodejs-compat-symlinks": [],
              "npm": []
              }
            }
          }
        }
      },

      "Properties" : {
        "InstanceType" : { "Ref" : "InstanceType" },
        "ImageId" : { "Fn::FindInMap" : [ "RegionImageZone", { "Ref" : "AWS::Region" }, 
          { "Fn::FindInMap" : [ "InstanceTypeArch", { "Ref" : "InstanceType" }, "Arch" ] } ] },
        "SecurityGroups" : [ { "Ref" : "SecurityGroupName" } ],
        "KeyName" : { "Ref" : "KeyName" },
        "UserData" : { "Fn::Base64" : { "Fn::Join" : ["", [
          "#!/bin/bash\n",
          "yum update -y aws-cfn-bootstrap\n",

          "## Error reporting helper function\n",
          "function error_exit\n",
          "{\n",
          "   /opt/aws/bin/cfn-signal -e 1 -r \"$1\" '", { "Ref" : "WaitHandleNodejsInstance" }, "'\n",
          "   exit 1\n",
          "}\n",

          "## Initialize CloudFormation bits\n",
          "/opt/aws/bin/cfn-init -v -s ", { "Ref" : "AWS::StackName" }, " -r NodejsInstance",
          "   --access-key ",  { "Ref" : "HostKeys" },
          "   --secret-key ", {"Fn::GetAtt": ["HostKeys", "SecretAccessKey"]},
          "   --region ", { "Ref" : "AWS::Region" }, " > /tmp/cfn-init.log 2>&1 || error_exit $(</tmp/cfn-init.log)\n",

          "## Raise file descriptor limits\n",
          "echo '* hard nofile 100000' | tee -a /etc/security/limits.conf\n",
          "echo '* soft nofile 100000' | tee -a /etc/security/limits.conf\n",
          "ulimit -n 100000\n",                    

          "## CloudFormation signal that setup is complete\n",
          "/opt/aws/bin/cfn-signal -e 0 -r \"NodejsInstance setup complete\" '", { "Ref" : "WaitHandleNodejsInstance" }, "'\n"
        ] ] } }
      }
    },

    "WaitHandleNodejsInstance" : {
      "Type" : "AWS::CloudFormation::WaitConditionHandle",
      "Properties" : {}
    },

    "WaitConditionNodejsInstance" : {
      "Type" : "AWS::CloudFormation::WaitCondition",
      "DependsOn" : "NodejsInstance",
      "Properties" : {
        "Handle" : { "Ref" : "WaitHandleNodejsInstance" },
        "Timeout" : "300"
      }
    }
  },

  "Outputs" : {
    "InstanceName" : {
      "Value" : { "Fn::GetAtt" : [ "NodejsInstance", "PublicDnsName" ] },
      "Description" : "public DNS name of the new NodejsInstance"
    }
  }
}