pullcommandmodule = {name: "pullcommandmodule"}

#region modulesFromTheEnvironment
#region node_modules
gitmodulesHandler = require "gitmodules-file-handler"
c = require "chalk"
CLUI = require "clui"
Spinner = CLUI.Spinner
#endregion

#region localModules
git = null
pathHandler = null
#endregion
#endregion

#region printLogFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["pullcommandmodule"]?  then console.log "[pullcommandmodule]: " + arg
    return
olog = (arg) -> log ostr(arg)
ostr = (obj) -> JSON.stringify(obj, null, 4)
print = (arg) -> console.log(arg)
printError = (arg) -> console.log(c.red(arg))

#endregion
##############################################################################
pullcommandmodule.initialize = () ->
    log "pullcommandmodule.initialize"
    pathHandler = allModules.pathhandlermodule
    git = allModules.gitmodule
    return

failCollection = []

#region internalFunctions
printFailCollection = ->
    log "printFailCollection"
    if failCollection.length == 0
        print "Success! nothing has failed :-)"
        return
    for fail in failCollection
        print " - - - "
        printError "Fail on: " + fail.path
        printError "\n> " + fail.err
    return

pullLevel = (path) ->
    log "pullLevel"
    try 
        await git.pull(path)
        await git.checkoutMaster(path)
    catch err
        failObject = 
            path: path
            err: err        
        failCollection.push(failObject)
    return

handleLevel = (path) ->
    log "handleLevel"

    await pullLevel(path)
    
    modulesFile = pathHandler.resolve(path, ".gitmodules")
    levelModules = await gitmodulesHandler.readNewGitmodulesFile(modulesFile)
    modules = levelModules.getAllModules()
    nextLevelPaths = (pathHandler.resolve(path,name) for name of modules)
    
    promises = nextLevelPaths.map(handleLevel)
    await Promise.all(promises)
    return
#endregion

#region exposedFunctions
pullcommandmodule.execute = ->
    log "pullcommandmodule.execute"
    basePath = pathHandler.basePath
    statusMessage = "pulling recursively..."
    status = new Spinner(statusMessage)
    status.start()
    try await handleLevel(basePath)
    finally
        status.stop()
        printFailCollection()
    return
#endregion

module.exports = pullcommandmodule