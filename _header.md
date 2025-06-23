# Azure NAT Gateway Terraform Module
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/cloudastro/nat-gateway/azurerm/)


Azure NAT Gateway is a fully managed and highly resilient Network Address Translation (NAT) service.

This module is designed to create and manage Azure NAT Gateways. Deployments are intentionally made simple with NAT gateways. Attach the NAT gateway to a subnet and public IP address and start connecting outbound to the internet right away
There's zero maintenance and routing configurations required (or __possible__). However, more public IPs or subnets can be added (later) without effect to your existing configuration.

You can use Azure NAT Gateway to let all instances in a private subnet connect outbound to the internet while remaining fully private. Unsolicited inbound connections from the internet aren't permitted through a NAT gateway. Only packets arriving as response packets to an outbound connection can pass through a NAT gateway.

NAT Gateway provides dynamic SNAT port functionality to automatically scale outbound connectivity and reduce the risk of SNAT port exhaustion.

## Features

* Attaches to subnet(s) of Azure Virtual Networks (VNet)
* Attaches to either an Azure public IP address or a public IP address prefix
* Provides a configurable idle timeout range of 4 minutes to 120 minutes for TCP protocols (see [below](#modules))

## Example Usage

This example shows how to create an Azure NAT gateway attached to one public IP address and one subnets.
