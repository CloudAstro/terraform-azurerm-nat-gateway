## 🌐 Additional Information  

A NAT gateway provides a configurable idle timeout range of 4 minutes to 120 minutes for TCP protocols. UDP protocols have a nonconfigurable idle timeout of 4 minutes.

When a connection goes idle, the NAT gateway holds onto the SNAT port until the connection idle times out. Because long idle timeout timers can unnecessarily increase the likelihood of SNAT port exhaustion, it isn't recommended to increase the TCP idle timeout duration to longer than the default time of 4 minutes. The idle timer doesn't affect a flow that never goes idle.

Further reading about [TCP idle timeout](https://learn.microsoft.com/en-us/azure/nat-gateway/nat-gateway-resource#tcp-idle-timeout).

## 📚 Resources
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure NAT Gateway documentation](https://learn.microsoft.com/en-us/azure/nat-gateway/)

## 🧾 License  

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
