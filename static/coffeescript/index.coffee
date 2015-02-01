$ = require "./assets/javascript/jquery-2.1.3.min.js"
_ = require "underscore"
ipc = require 'ipc'
marked = require "marked"
fs = require 'fs'

$ () ->

  $("#markdown-input").keyup () ->
    content = $(this).val()
    compiled = marked content
    $('#preview').html compiled

  $('.edit-mode').on "click", "a", () ->
    currentNode = $('.checked')
    oriMode = currentNode.data "mode"
    $('.checked').removeClass "checked"
    $(this).addClass "checked"
    mode = $(this).data "mode"

    $('.editor-frame').removeClass oriMode
                      .addClass mode




  ipc.on 'saveFileRequest', () ->
    content = $("#markdown-input").val()
    ipc.send 'saveFileResponse', content

  renderFromFile = (content) ->
    $('#markdown-input').val content
    compiled = marked content
    $('#preview').html compiled

  dragOver = () ->
    false

  bodyDom = document.getElementsByTagName("body")[0];
  bodyDom.ondragover = bodyDom.ondragend = dragOver

  bodyDom.ondrop = (e) ->
    e.preventDefault()
    file = e.dataTransfer.files[0]
    fs.readFile file.path, {"encoding": "utf-8"}, (err, data) ->
      if err
        console.error err
        return
      renderFromFile data

  ipc.on "openFile", (data) ->
    renderFromFile data

