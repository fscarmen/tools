from pagermaid.listener import listener
from pagermaid.utils import alias_command, attach_log, execute, lang


@listener(
    is_plugin=True,
    outgoing=True,
    command=alias_command("route"),
    description="besttrace 路由回程跟踪",
    parameters="<ip>",
)
async def route(context):
    reply = await context.get_reply_message()
    ip = context.arguments
    if ip:
        pass
    elif reply:
        ip = reply.text
    else:
        await context.edit(lang('arg_error'))
        return
    result = await execute(f"mkdir -p shell && cd shell && wget -q https://raw.githubusercontent.com/fscarmen/tools/main/return_pure.sh -O return.sh && bash return.sh {ip}")
    if result:
        if len(result) > 4096:
            await attach_log(result, context.chat_id, f"{ip}.log", context.id)
            return
        await context.edit(result)
    else:
        return
        

@listener(
    is_plugin=True,
    outgoing=True,
    command=alias_command("port"),
    description="ping.pe 查看 IP 端口是否被墙",
    parameters="<IPv4:PORT> or <[IPv6]:PORT>",
)
async def port(context):
    reply = await context.get_reply_message()
    ipport = context.arguments
    if ipport:
        pass
    elif reply:
        ipport = reply.text
    else:
        await context.edit(lang('arg_error'))
        return
    result = await execute(f"mkdir -p shell && cd shell && wget -q https://raw.githubusercontent.com/fscarmen/tools/main/port_pure.sh -O port.sh && bash port.sh {ipport}")
    if result:
        if len(result) > 4096:
            await attach_log(result, context.chat_id, f"{ipport}.log", context.id)
            return
        await context.edit(result)
    else:
        return