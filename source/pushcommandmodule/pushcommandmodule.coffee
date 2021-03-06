pushcommandmodule = {name: "pushcommandmodule"}

#region modulesFromTheEnvironment
#region node_modules
fs = require "fs"
gitmodulesHandler = require "gitmodules-file-handler"
c = require "chalk"
CLUI = require "clui"
Spinner = CLUI.Spinner
#endregion

#region localModules
pathHandler = null
git = null
#endregion
#endregion

#region printLogFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["pushcommandmodule"]?  then console.log "[pushcommandmodule]: " + arg
    return
print = (arg) -> console.log(arg)
printError = (arg) -> console.log(c.red(arg))
olog = (arg) -> log ostr(arg)
ostr = (obj) -> JSON.stringify(obj, null, 4)
#endregion
##############################################################################
pushcommandmodule.initialize = () ->
    log "pushcommandmodule.initialize"
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

pushLevel = (path, message) ->
    log "pushLevel"
    try 
        await git.checkoutMaster(path)
        await git.addCommitPush(path, message)
    catch err
        failObject = 
            path: path
            err: err        
        failCollection.push(failObject)
    return

handleLevel = (path, message) ->
    log "handleLevel"    
    modulesFile = pathHandler.resolve(path, ".gitmodules")
    exists = await checkFileExists(modulesFile)
    if exists
        log "moduleFile existed: " + modulesFile
        levelModules = await gitmodulesHandler.readNewGitmodulesFile(modulesFile)
        modules = levelModules.getAllModules()
        nextLevelPaths = (pathHandler.resolve(path,name) for name of modules)
        
        promises = nextLevelPaths.map(handleLevel)
        await Promise.all(promises)

    await pushLevel(path, message)
    return

checkFileExists = (path) ->
    log "checkFileExists"
    try stat = await fs.promises.stat(path)
    catch err then return false
    return stat.isFile()

#endregion

#region exposedFunctions
pushcommandmodule.execute = (message) ->
    log "pushcommandmodule.execute"
    if !message then message  = "thingysync push"
    basePath = pathHandler.basePath
    statusMessage = "pushing recursively..."
    status = new Spinner(statusMessage)
    status.start()
    try await handleLevel(basePath, message)
    finally
        status.stop()
        printFailCollection()
    return
#endregion

module.exports = pushcommandmodule