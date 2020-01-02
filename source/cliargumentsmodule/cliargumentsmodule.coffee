cliargumentsmodule = {name: "cliargumentsmodule"}

#region node_modules
meow = require("meow")
#endregion

#region logPrintFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["cliargumentsmodule"]?  then console.log "[cliargumentsmodule]: " + arg
    return
#endregion
##############################################################
cliargumentsmodule.initialize = () ->
    log "cliargumentsmodule.initialize"
    return

#region internal functions
getHelpText = ->
    log "getHelpText"
    return """
    Usage 
        $ thingysync <arg1> <arg2> <arg3>

    Options
        required:
            arg1, --command <command> , -c <command>
                command can either be "push" or "pull"

        optional:
            arg2, --path <path>, -p <path>
                the path to the base repository (may be relative or absolute)
            arg3, --message <message>, -m <message>
                commit message when pushing
                
    Examples
        $  thingysync pull ..

    """

getOptions = ->
    log "getOptions"
    return {
        flags:
            command:
                type: "string"
                alias: "c"
            path:
                type: "string"
                alias: "p"
            message: 
                type: "string"
                alias: "m"
    }

extractMeowed = (meowed) ->
    log "extractMeowed"

    command = null
    path = null
    message = null

    if meowed.input[0]
        command = meowed.input[0]
    if meowed.input[1]
        path = meowed.input[1]
    if meowed.input[2]
        message = meowed.input[2]

    if meowed.flags.command
        command = meowed.flags.command
    if meowed.flags.path
        path = meowed.flags.path
    if meowed.flags.message
        message = meowed.flags.message

    return {command, path, message}
#endregion

#region exposed functions
cliargumentsmodule.extractArguments = ->
    log "cliargumentsmodule.extractArguments"
    options = getOptions()
    meowed = meow(getHelpText(), getOptions())
    extract = extractMeowed(meowed)
    if!extract.command then throw "Usage Error! Command must be specified!"
    return extract

#endregion exposed functions

module.exports = cliargumentsmodule