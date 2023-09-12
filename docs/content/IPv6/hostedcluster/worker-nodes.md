Regarding the worker nodes, if you are working on real bare metal, this step is to make sure that the details set in the `BareMetalHost` are well set, if not you will need to debug why does not work properly.

If you are working with virtual machines, we can follow this steps and create empty ones to be consumed by Metal3 operator.

For this purpose we will use again Kcli.

## Creating Virtual Machines

If this is not your first try, you will need first to delete the prior try, to do so, please go to the [Deleting Virtual Machines](#deleting-virtual-vachines) section.

Now we can execute these creation commands:

```bash
kcli create vm -P start=False -P uefi_legacy=true -P plan=hosted-ipv4 -P memory=8192 -P numcpus=16 -P disks=[200,200] -P nets=["{\"name\": \"ipv4\", \"mac\": \"aa:aa:aa:aa:02:11\"}"] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0211 -P name=hosted-ipv4-worker0
kcli create vm -P start=False -P uefi_legacy=true -P plan=hosted-ipv4 -P memory=8192 -P numcpus=16 -P disks=[200,200] -P nets=["{\"name\": \"ipv4\", \"mac\": \"aa:aa:aa:aa:02:12\"}"] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0212 -P name=hosted-ipv4-worker1
kcli create vm -P start=False -P uefi_legacy=true -P plan=hosted-ipv4 -P memory=8192 -P numcpus=16 -P disks=[200,200] -P nets=["{\"name\": \"ipv4\", \"mac\": \"aa:aa:aa:aa:02:13\"}"] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0213 -P name=hosted-ipv4-worker2

sleep 2
systemctl restart ksushy
```

Let's disect the creation command:

- `start=False`: The VM will not boot automatically on creation
- `uefi_legacy=true`: We will use uefi legacy boot to make that compatible with older implementations of UEFI
- `plan=hosted-ipv4`: Plan name, which identifies a group of machines as a group.
- `memory=8192` and `numcpus=16`: Resources for the VM as a Ram and CPU.
- `disks=[200,200]`: We are creating 2 disks (thin) in the virtual machine.
- `nets=["{"name": "ipv4", "mac": "aa:aa:aa:aa:02:13"}"]`: Network details, like the Network name to be located on and the MAC address for the primary interface.
- The ksushy restart is to make our ksushy (VM's BMC) aware of the new VMs included.

This is how looks like:

```bash
+---------------------+--------+-------------------+----------------------------------------------------+-------------+---------+
|         Name        | Status |         Ip        |                       Source                       |     Plan    | Profile |
+---------------------+--------+-------------------+----------------------------------------------------+-------------+---------+
|    hosted-worker0   |  down  |                   |                                                    | hosted-ipv4 |  kvirt  |
|    hosted-worker1   |  down  |                   |                                                    | hosted-ipv4 |  kvirt  |
|    hosted-worker2   |  down  |                   |                                                    | hosted-ipv4 |  kvirt  |
+---------------------+--------+-------------------+----------------------------------------------------+-------------+---------+
```

## Deleting Virtual Machines

In order to delete the VMs you just need to delete the plan, in our case:

```bash
kcli delete plan hosted-ipv4
```

```bash
$ kcli delete plan hosted-ipv4
Are you sure? [y/N]: y
hosted-worker0 deleted on local!
hosted-worker1 deleted on local!
hosted-worker2 deleted on local!
Plan hosted-ipv4 deleted!
```