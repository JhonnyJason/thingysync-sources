pathhandlermodule = {name: "pathhandlermodule"}

#region modulesFromTheEnvironment#
#region node_modules
pathModule = require "path"
os = require "os"
#endregion
#endregion

#region printLogFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["pathhandlermodule"]?  then console.log "[pathhandlermodule]: " + arg
    return
print = (arg) -> console.log(arg)
#endregion
##############################################################################
pathhandlermodule.initialize = () ->
    log "pathhandlermodule.initialize"
    return

#region internal
#region internalProperties
homedir = os.homedir()
#endregion

#region internalFunctions
resolveHomeDir = (path) ->
    log "resolveHomeDir"
    if !path then return
    if path[0] == "~"
        path = path.replace("~", homedir)
    return path
#endregion
#endregion

#region exposed
#region exposedProperties
pathhandlermodule.basePath = ""
#endregion

#region exposedFunctions
pathhandlermodule.digestArgument = (providedPath) ->
    log "pathhandlermodule.digestArgument"
    if !providedPath then providedPath = process.cwd()
    
    if !pathModule.isAbsolute(providedPath)
        providedPath = resolveHomeDir(providedPath)
        providedPath = pathModule.resolve(providedPath)
    
    pathhandlermodule.basePath = providedPath
    return

pathhandlermodule.resolve = (base, further) ->
    log "pathhandlermodule.resolve"
    return pathModule.resolve(base, further)

#endregion
#endregion

module.exports = pathhandlermodule