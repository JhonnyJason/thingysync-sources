mainprocessmodule = {name: "mainprocessmodule"}

#region modulesFromEnvironment
pathHandler = null
pushCommand = null
pullCommand = null
#endregion

#region logPrintFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["mainprocessmodule"]?  then console.log "[mainprocessmodule]: " + arg
    return
olog = (o) -> log "\n" + ostr(o)
ostr = (o) -> JSON.stringify(o, null, 4)
print = (arg) -> console.log(arg)
#endregion
##############################################################################
mainprocessmodule.initialize = () ->
    log "mainprocessmodule.initialize"
    pathHandler = allModules.pathhandlermodule
    pushCommand = allModules.pushcommandmodule
    pullCommand = allModules.pullcommandmodule
    return 

#region internalFunctions
#endregion

#region exposedFunctions
mainprocessmodule.execute = (e) ->
    log "mainprocessmodule.execute"
    pathHandler.digestArgument(e.path)
    switch e.command
        when "pull" then await pullCommand.execute()
        when "push" then await pushCommand.execute(e.message)
        else throw "Unknown Command: " + e.command
    return
#endregion

module.exports = mainprocessmodule
