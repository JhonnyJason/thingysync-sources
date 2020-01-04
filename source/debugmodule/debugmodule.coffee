debugmodule = {name: "debugmodule"}

##############################################################################
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return     
##############################################################################
debugmodule.modulesToDebug = 
    unbreaker: true
    # cliargumentsmodule: true
    # configmodule: true
    # gitmodule: true
    # mainprocessmodule: true
    # pathhandlermodule: true
    # pullcommandmodule: true
    pushcommandmodule: true
    # startupmodule: true
    
module.exports = debugmodule