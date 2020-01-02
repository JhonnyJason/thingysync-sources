gitmodule = {name: "gitmodule"}

#region modulesFromTheEnvironment
git = require "simple-git/promise"
#endregion

#region printLogFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["gitmodule"]?  then console.log "[gitmodule]: " + arg
    return
print = (arg) -> console.log(arg)
#endregion
##############################################################################
gitmodule.initialize = () ->
    log "gitmodule.initialize"
    return
    
#region internalFunctions
#endregion

#region exposedFunctions
gitmodule.pull = (base) ->
    log "gitmodule.pull"
    await git(base).pull("origin", "master")
    return

gitmodule.checkoutMaster = (base) ->
    log "gitmodule.checkoutMaster"
    await git(base).checkout("master")
    return

gitmodule.addCommitPush = (base, message) ->
    log "gitmodule.addCommitPush"
    await git(base).add(".")
    await git(base).commit(message)
    await git(base).push("origin", "master")
    return

#endregion

module.exports = gitmodule