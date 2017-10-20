let g:defaultDroidDrawJar='droiddrawr1b23.jar'

let g:currentPackage  = ""
let g:currentActivity = ""
let g:droidDrawJar = ""

function! s:NewFile(path,description,extension,content)
  let fileName = inputdialog("Insert the " . a:description . " name:", "")
  if (fileName == "")
    return
  endif
  let newFileName = a:path . "/" . fileName . a:extension

  call writefile(a:content,newFileName)

  if filereadable(newFileName)
    execute "bad" newFileName
  endif
  execute "an <silent> " a:menuPath . "." . fileName . "\\" . a:extension . " :b " . newFileName . "<CR>"
  execute ":b " . newFileName
endfunction

function! s:NewPackageFile(path,menuPath,pkgname)
  let newFileName = a:path . "/" . a:pkgname
  let cwd=getcwd()
  if a:pkgname == ""
    let newFileName = expand(browse(1,"Create New Java Package",a:path,"NewClass.java"))
  endif
  let items      = split(newFileName,"[\\/]")
  let newpkgname = substitute(items[len(items) - 1], '\.java$', '', "g")
  let newpkgdir  = substitute(newFileName, items[len(items) - 1] . '$', '', "g")
  execute ":cd " . newpkgdir
  let newcwd=getcwd()
  execute ":cd " . cwd
  let newFileName = newcwd . "/" . items[len(items) - 1]
  let newpkgurl1 = strpart(newcwd, strlen(a:path)+1)
  let newpkgurl2 = substitute(newpkgurl1, '[\\/]$', '', "g")
  let newpkgurl3 = substitute(newpkgurl2, '[\\/]', '.', "g")

  let content = []
  call add(content, "package " . newpkgurl3 . ".*;")
  call add(content, "")
  call add(content, "public class " . newpkgname)
  call add(content, "{")
  call add(content, "  public " . newpkgname . "()")
  call add(content, "  {")
  call add(content, "  }")
  call add(content, "}")

  call writefile(content,newFileName)

  if a:pkgname == ""
    if filereadable(newFileName)
      execute "bad" newFileName
    endif
    execute "an <silent> " a:menuPath . "." . newpkgurl3 . "." . newpkgname . "\\.java :b " . newFileName . "<CR>"
    execute ":b " . newFileName
  endif
endfunction

function! s:NewLayoutFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")

  call s:NewFile(a:path,"Layout",".xml",content)
endfunction

function! s:NewCustomInterpolatorFile(path,menuPath,interpolatorName)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/animation-resource.html")
  call add(content, "  <" . a:interpolatorName . " xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  if a:interpolatorName == "accelerateDecelerateInterpolator"
    call add(content, "    android:factor=\"1.0\"")
  else if a:interpolatorName == "anticipateInterpolator"
    call add(content, "    android:tension=\"2.0\"")
  else if a:interpolatorName == "anticipateOvershootInterpolator"
    call add(content, "    android:tension=\"2.0\"")
    call add(content, "    android:extraTension=\"1.5\"")
  else if a:interpolatorName == "cycleInterpolator"
    call add(content, "    android:cycles=\"1\"")
  else if a:interpolatorName == "decelerateInterpolator"
    call add(content, "    android:factor=\"1.0\"")
  else if a:interpolatorName == "overshootInterpolator"
    call add(content, "    android:tension=\"2.0\"")
  endif
  call add(content, "  />")
  call add(content, "-->")

  call s:NewFile(a:path,a:interpolator,".xml",content)
endfunction

function! s:NewShapeFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<shape xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:shape=[\"rectangle\" | \"oval\" | \"line\" | \"ring\"] >")
  call add(content, "  <corners")
  call add(content, "    android:radius=\"integer\"")
  call add(content, "    android:topLeftRadius=\"integer\"")
  call add(content, "    android:topRightRadius=\"integer\"")
  call add(content, "    android:bottomLeftRadius=\"integer\"")
  call add(content, "    android:bottomRightRadius=\"integer\" />")
  call add(content, "  <gradient")
  call add(content, "    android:angle=\"integer\"")
  call add(content, "    android:centerX=\"integer\"")
  call add(content, "    android:centerY=\"integer\"")
  call add(content, "    android:centerColor=\"integer\"")
  call add(content, "    android:endColor=\"color\"")
  call add(content, "    android:gradientRadius=\"integer\"")
  call add(content, "    android:startColor=\"color\"")
  call add(content, "    android:type=[\"linear\" | \"radial\" | \"sweep\"]")
  call add(content, "    android:usesLevel=[\"true\" | \"false\"] />")
  call add(content, "  <padding")
  call add(content, "    android:left=\"integer\"")
  call add(content, "    android:top=\"integer\"")
  call add(content, "    android:right=\"integer\"")
  call add(content, "    android:bottom=\"integer\" />")
  call add(content, "  <size")
  call add(content, "    android:width=\"integer\"")
  call add(content, "    android:height=\"integer\" />")
  call add(content, "  <solid")
  call add(content, "    android:color=\"color\" />")
  call add(content, "  <stroke")
  call add(content, "    android:width=\"integer\"")
  call add(content, "    android:color=\"color\"")
  call add(content, "    android:dashWidth=\"integer\"")
  call add(content, "    android:dashGap=\"integer\" />")
  call add(content, "</shape>")
  call add(content, "-->")

  call s:NewFile(a:path,"Shape",".xml",content)
endfunction

function! s:NewScaleFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<scale xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:drawable=\"@drawable/drawable_resource\"")
  call add(content, "  android:scaleGravity=[\"top\" | \"bottom\" | \"left\" | \"right\" | \"center_vertical\" |")
  call add(content, "                        \"fill_vertical\" | \"center_horizontal\" | \"fill_horizontal\" |")
  call add(content, "                        \"center\" | \"fill\" | \"clip_vertical\" | \"clip_horizontal\"]")
  call add(content, "  android:scaleHeight=\"percentage\"")
  call add(content, "  android:scaleWidth=\"percentage\" />")
  call add(content, "-->")

  call s:NewFile(a:path,"Scale",".xml",content)
endfunction

function! s:NewClipFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<clip xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:drawable=\"@drawable/drawable_resource\"")
  call add(content, "  android:clipOrientation=[\"horizontal\" | \"vertical\"]")
  call add(content, "  android:gravity=[\"top\" | \"bottom\" | \"left\" | \"right\" | \"center_vertical\" |")
  call add(content, "                   \"fill_vertical\" | \"center_horizontal\" | \"fill_horizontal\" |")
  call add(content, "                   \"center\" | \"fill\" | \"clip_vertical\" | \"clip_horizontal\"] />")
  call add(content, "-->")

  call s:NewFile(a:path,"Clip",".xml",content)
endfunction

function! s:NewInsetFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<inset xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:drawable=\"@drawable/drawable_resource\"")
  call add(content, "  android:insetTop=\"dimension\"")
  call add(content, "  android:insetRight=\"dimension\"")
  call add(content, "  android:insetBottom=\"dimension\"")
  call add(content, "  android:insetLeft=\"dimension\" />")
  call add(content, "-->")

  call s:NewFile(a:path,"Inset",".xml",content)
endfunction

function! s:NewTransitionFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<transition xmlns:android=\"http://schemas.android.com/apk/res/android\" >")
  call add(content, "  <item")
  call add(content, "    android:drawable=\"@[package:]drawable/drawable_resource\"")
  call add(content, "    android:id=\"@[+][package:]id/resource_name\"")
  call add(content, "    android:top=\"dimension\"")
  call add(content, "    android:right=\"dimension\"")
  call add(content, "    android:bottom=\"dimension\"")
  call add(content, "    android:left=\"dimension\" />")
  call add(content, "</transition>")
  call add(content, "-->")

  call s:NewFile(a:path,"Transition",".xml",content)
endfunction

function! s:NewLevelListFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<level-list")
  call add(content, "  xmlns:android=\"http://schemas.android.com/apk/res/android\" >")
  call add(content, "  <item")
  call add(content, "    android:drawable=\"@drawable/drawable_resource\"")
  call add(content, "    android:maxLevel=\"integer\"")
  call add(content, "    android:minLevel=\"integer\" />")
  call add(content, "</level-list>")
  call add(content, "-->")

  call s:NewFile(a:path,"Level list",".xml",content)
endfunction

function! s:NewDrawableSelctorFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<selector xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:constantSize=[\"true\" | \"false\"]")
  call add(content, "  android:dither=[\"true\" | \"false\"]")
  call add(content, "  android:variablePadding=[\"true\" | \"false\"] >")
  call add(content, "  <item")
  call add(content, "    android:drawable=\"@[package:]drawable/drawable_resource\"")
  call add(content, "    android:state_pressed=[\"true\" | \"false\"]")
  call add(content, "    android:state_focused=[\"true\" | \"false\"]")
  call add(content, "    android:state_hovered=[\"true\" | \"false\"]")
  call add(content, "    android:state_selected=[\"true\" | \"false\"]")
  call add(content, "    android:state_checkable=[\"true\" | \"false\"]")
  call add(content, "    android:state_checked=[\"true\" | \"false\"]")
  call add(content, "    android:state_enabled=[\"true\" | \"false\"]")
  call add(content, "    android:state_window_focused=[\"true\" | \"false\"] />")
  call add(content, "</selector>")
  call add(content, "-->")

  call s:NewFile(a:path,"Drawable Selector",".xml",content)
endfunction

function! s:NewLayerListFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<layer-list")
  call add(content, "  xmlns:android=\"http://schemas.android.com/apk/res/android\" >")
  call add(content, "  <item")
  call add(content, "    android:drawable=\"@[package:]drawable/drawable_resource\"")
  call add(content, "    android:id=\"@[+][package:]id/resource_name\"")
  call add(content, "    android:top=\"dimension\"")
  call add(content, "    android:right=\"dimension\"")
  call add(content, "    android:bottom=\"dimension\"")
  call add(content, "    android:left=\"dimension\" />")
  call add(content, "</layer-list>")
  call add(content, "-->")

  call s:NewFile(a:path,"Layer List",".xml",content)
endfunction

function! s:NewXmlNinePatchFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<nine-patch")
  call add(content, "  xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:src=\"@[package:]drawable/drawable_resource\"")
  call add(content, "  android:dither=[\"true\" | \"false\"] />")
  call add(content, "-->")

  call s:NewFile(a:path,"XML Nine Patch",".xml",content)
endfunction

function! s:NewXmlBitmapFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/drawable-resource.html")
  call add(content, "<bitmap")
  call add(content, "  xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:src=\"@[package:]drawable/drawable_resource\"")
  call add(content, "  android:antialias=[\"true\" | \"false\"]")
  call add(content, "  android:dither=[\"true\" | \"false\"]")
  call add(content, "  android:filter=[\"true\" | \"false\"]")
  call add(content, "  android:gravity=[\"top\" | \"bottom\" | \"left\" | \"right\" | \"center_vertical\" |")
  call add(content, "                   \"fill_vertical\" | \"center_horizontal\" | \"fill_horizontal\" |")
  call add(content, "                   \"center\" | \"fill\" | \"clip_vertical\" | \"clip_horizontal\"]")
  call add(content, "  android:tileMode=[\"disabled\" | \"clamp\" | \"repeat\" | \"mirror\"] />")
  call add(content, "-->")

  call s:NewFile(a:path,"XML Bitmap",".xml",content)
endfunction

function! s:NewFrameAnimationFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/animation-resource.html")
  call add(content, "<animation-list xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:oneshot=[\"true\" | \"false\"] >")
  call add(content, "  <item")
  call add(content, "    android:drawable=\"@[package:]drawable/drawable_resource_name\"")
  call add(content, "    android:duration=\"integer\" />")
  call add(content, "</animation-list>")
  call add(content, "-->")

  call s:NewFile(a:path,"FrameAnimation",".xml",content)
endfunction

function! s:NewTweenAnimationFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/animation-resource.html")
  call add(content, "<set xmlns:android=\"http://schemas.android.com/apk/res/android\"")
  call add(content, "  android:interpolator=\"@[package:]anim/interpolator_resource\"")
  call add(content, "  android:shareInterpolator=[\"true\" | \"false\"] >")
  call add(content, "  <alpha")
  call add(content, "    android:fromAlpha=\"float\"")
  call add(content, "    android:toAlpha=\"float\" />")
  call add(content, "  <scale")
  call add(content, "    android:fromXScale=\"float\"")
  call add(content, "    android:toXScale=\"float\"")
  call add(content, "    android:fromYScale=\"float\"")
  call add(content, "    android:toYScale=\"float\"")
  call add(content, "    android:pivotX=\"float\"")
  call add(content, "    android:pivotY=\"float\" />")
  call add(content, "  <translate")
  call add(content, "    android:fromXDelta=\"float\"")
  call add(content, "    android:toXDelta=\"float\"")
  call add(content, "    android:fromYDelta=\"float\"")
  call add(content, "    android:toYDelta=\"float\" />")
  call add(content, "  <rotate")
  call add(content, "    android:fromDegrees=\"float\"")
  call add(content, "    android:toDegrees=\"float\"")
  call add(content, "    android:pivotX=\"float\"")
  call add(content, "    android:pivotY=\"float\" />")
  call add(content, "  <set>")
  call add(content, "    ...")
  call add(content, "  </set>")
  call add(content, "</set>")
  call add(content, "-->")

  call s:NewFile(a:path,"TweenAnimation",".xml",content)
endfunction

function! s:NewPropertyAnimationFile(path,menuPath)
  let content = []

  call add(content, "<!-- docs/guide/topics/resources/animation-resource.html")
  call add(content, "<set")
  call add(content, "  android:ordering=[\"together\" | \"sequentially\"]>")
  call add(content, "")
  call add(content, "  <objectAnimator")
  call add(content, "    android:propertyName=\"string\"")
  call add(content, "    android:duration=\"int\"")
  call add(content, "    android:valueFrom=\"float | int | color\"")
  call add(content, "    android:valueTo=\"float | int | color\"")
  call add(content, "    android:startOffset=\"int\"")
  call add(content, "    android:repeatCount=\"int\"")
  call add(content, "    android:repeatMode=[\"repeat\" | \"reverse\"]")
  call add(content, "    android:valueType=[\"intType\" | \"floatType\"]/>")
  call add(content, "")
  call add(content, "  <animator")
  call add(content, "    android:duration=\"int\"")
  call add(content, "    android:valueFrom=\"float | int | color\"")
  call add(content, "    android:valueTo=\"float | int | color\"")
  call add(content, "    android:startOffset=\"int\"")
  call add(content, "    android:repeatCount=\"int\"")
  call add(content, "    android:repeatMode=[\"repeat\" | \"reverse\"]")
  call add(content, "    android:valueType=[\"intType\" | \"floatType\"]/>")
  call add(content, "")
  call add(content, "  <set>")
  call add(content, "    ...")
  call add(content, "  </set>")
  call add(content, "</set>")
  call add(content, "-->")

  call s:NewFile(a:path,"PropertyAnimation",".xml",content)
endfunction

function! s:NewColorSelectorFile(path,menuPath)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<selector xmlns:android=\"http://schemas.android.com/apk/res/android\">")
  call add(content, "<!-- docs/guide/topics/resources/color-list-resource.html")
  call add(content, "  <item")
  call add(content, "    android:color=\"hex_color\"")
  call add(content, "    android:state_pressed=[\"true\" | \"false\"]")
  call add(content, "    android:state_focused=[\"true\" | \"false\"]")
  call add(content, "    android:state_selected=[\"true\" | \"false\"]")
  call add(content, "    android:state_checkable=[\"true\" | \"false\"]")
  call add(content, "    android:state_checked=[\"true\" | \"false\"]")
  call add(content, "    android:state_enabled=[\"true\" | \"false\"]")
  call add(content, "    android:state_window_focused=[\"true\" | \"false\"] />")
  call add(content, "-->")
  call add(content, "</selector>")

  call s:NewFile(a:path,"ColorSelector",".xml",content)
endfunction

function! s:NewMenuFile(path)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
  call add(content, "<!-- docs/guide/topics/resources/menu-resource.html")
  call add(content, "<menu xmlns:android=\"http://schemas.android.com/apk/res/android\">")
  call add(content, "  <item android:id=\"@[+][package:]id/resource_name\"")
  call add(content, "    android:title=\"string\"")
  call add(content, "    android:titleCondensed=\"string\"")
  call add(content, "    android:icon=\"@[package:]drawable/drawable_resource_name\"")
  call add(content, "    android:onClick=\"method name\"")
  call add(content, "    android:showAsAction=[\"ifRoom\" | \"never\" | \"withText\" | \"always\" | \"collapseActionView\"]")
  call add(content, "    android:actionLayout=\"@[package:]layout/layout_resource_name\"")
  call add(content, "    android:actionViewClass=\"class name\"")
  call add(content, "    android:actionProviderClass=\"class name\"")
  call add(content, "    android:alphabeticShortcut=\"string\"")
  call add(content, "    android:numericShortcut=\"string\"")
  call add(content, "    android:checkable=[\"true\" | \"false\"]")
  call add(content, "    android:visible=[\"true\" | \"false\"]")
  call add(content, "    android:enabled=[\"true\" | \"false\"]")
  call add(content, "    android:menuCategory=[\"container\" | \"system\" | \"secondary\" | \"alternative\"]")
  call add(content, "    android:orderInCategory=\"integer\" />")
  call add(content, "  <group android:id=\"@[+][package:]id/resource name\"")
  call add(content, "       android:checkableBehavior=[\"none\" | \"all\" | \"single\"]")
  call add(content, "       android:visible=[\"true\" | \"false\"]")
  call add(content, "       android:enabled=[\"true\" | \"false\"]")
  call add(content, "       android:menuCategory=[\"container\" | \"system\" | \"secondary\" | \"alternative\"]")
  call add(content, "       android:orderInCategory=\"integer\" >")
  call add(content, "    <item />")
  call add(content, "  </group>")
  call add(content, "  <item >")
  call add(content, "    <menu>")
  call add(content, "      <item />")
  call add(content, "    </menu>")
  call add(content, "  </item>")
  call add(content, "</menu>")
  call add(content, "-->")

  call s:NewFile(a:path,"Menu",".xml",content)
endfunction

function! s:NewResourceFile(path)
  echo a:path
endfunction

function! s:NewTranslationFile(path)
  echo a:path
endfunction

function! s:NewXmlFile(path)
  let content = []

  call add(content, "<?xml version=\"1.0\" encoding=\"utf-8\"?>")

  call s:NewFile(a:path,"file",".xml",content)
endfunction

function! s:ShowInBuffer(curdir,curfile,package,activity)
  let g:currentPackage  = a:package
  let g:currentActivity = a:activity
  execute ":lcd " . a:curdir
  execute ":b " . a:curfile
endfunction

function! s:ParseManifest(manifest)
  let g:currentPackage  = ""
  let g:currentActivity = ""
  let inActivity        = 0
  for line in readfile(a:manifest)
    if line =~ '.*package[ \t]*=[ \t]*"[^"]\+".*'
      let g:currentPackage=substitute(line,'.*package[ \t]*=[ \t]*"\([^"]\+\)".*','\1','g')
    elseif line =~ '.*<activity.*android:name[ \t]*=[ \t]*"[^"]\+".*'
      let g:currentActivity=substitute(line,'<activity.*android:name[ \t]*=[ \t]*"\([^"]\+\)".*','\1','g')
    elseif line =~ '.*<activity.*'
      let inActivity = 1
    elseif inActivity && line =~ '.*android:name[ \t]*=[ \t]*"[^"]\+".*'
      let g:currentActivity=substitute(line,'.*android:name[ \t]*=[ \t]*"\([^"]\+\)".*','\1','g')
      let inActivity = 0
    elseif line =~ '.*</activity>.*'
      let inActivity = 0
    endif
  endfor
endfunction

function! s:AddFiles(manifests)
  let first = 1
  let counter = 0
  while counter < len(a:manifests)
    call s:ParseManifest(a:manifests[counter])
    let topsrcdir = substitute(a:manifests[counter], '[\\/]AndroidManifest.xml', "", "g")
    let items     = split(topsrcdir,"[\\/]")
    let menuEntry = "Workspace/" . items[len(items) - 1] . "/"
    execute "aun" substitute(menuEntry,'[\\/]', '.', "g")
    execute "an <silent> " substitute(menuEntry,'[\\/]', '.', "g") . "Remove\\ from\\ Workspace <nop>"

    let output=system("android list target")
    let targets=split(output,"\n")
    call sort(targets)
    let ctgts=0
    if len(targets) > 0
        execute "an <silent> " substitute(menuEntry,'[\\/]', '.', "g") . "-sep2- <nop>"
    endif
    while ctgts < len(targets)
      if matchstr(targets[ctgts], "^id:") != ""
        let tokens=matchlist(targets[ctgts],'^id:[ 	]\([^ 	]*\)[ 	][^"]*"\(.*\)"$')
        let id=tokens[1]
        let target=substitute(tokens[2],"\\([  .]\\)","\\\\\\1","g")
        execute "an <silent> " substitute(menuEntry,'[\\/]', '.', "g") . "Set\\ Target\\ Platform." . target . " :silent! call <SID>EditProject('" . topsrcdir . "'," . id . ")<CR>"
      endif
      let ctgts=ctgts+1
    endwhile

    execute "an <silent> " substitute(menuEntry,'[\\/]', '.', "g") . "-sep1- <nop>"

    if globpath(topsrcdir, "build.xml") == ""
      let command = "android update project --path " . topsrcdir . " --subprojects --target 1"
      call system(command)
    endif
    if globpath(topsrcdir, "custom_rules.xml") == ""
      if isdirectory(topsrcdir . "/jni")
        let content = []
        call add(content, '<?xml version="1.0" encoding="UTF-8"?>')
        call add(content, '<project name="custom_rules">')
        call add(content, '    <target name="-pre-build">')
        call add(content, '        <exec executable="${ndk.dir}/ndk-build" failonerror="true"/>')
        call add(content, '    </target>')
        call add(content, '')
        call add(content, '    <target name="clean" depends="android_rules.clean">')
        call add(content, '        <exec executable="${ndk.dir}/ndk-build" failonerror="true">')
        call add(content, '            <arg value="clean"/>')
        call add(content, '        </exec>')
        call add(content, '    </target>')
        call add(content, '</project>')
        call writefile(content,topsrcdir . "/custom_rules.xml")
      endif
    endif
    if exists("*mkdir")
        call mkdir(topsrcdir . "/assets"      , "p")
        call mkdir(topsrcdir . "/res/anim"    , "p")
        call mkdir(topsrcdir . "/res/animator", "p")
        call mkdir(topsrcdir . "/res/color"   , "p")
        call mkdir(topsrcdir . "/res/drawable", "p")
        call mkdir(topsrcdir . "/res/layout"  , "p")
        call mkdir(topsrcdir . "/res/menu"    , "p")
        call mkdir(topsrcdir . "/res/raw"     , "p")
    endif
    let srcfiles = []
    let srcfiles += split(globpath(topsrcdir, "**/*"))
    call sort(srcfiles)
    call filter(srcfiles, 'v:val !~ "\\<bin\\>"')
    call filter(srcfiles, 'v:val !~ "\\<obj\\>"')
    call filter(srcfiles, 'v:val !~ "\\<libs\\>"')
    " call filter(srcfiles, 'v:val !~ "\\<lib\\>"')
    call filter(srcfiles, 'v:val !~ "[\\/]\\.*\\>"')
    call filter(srcfiles, 'v:val !~ "\\.class\\>"')
    call filter(srcfiles, 'v:val !~ "\\.jar\\>"')
    call filter(srcfiles, 'v:val !~ "\\.a\\>"')
    call filter(srcfiles, 'v:val !~ "\\.o\\>"')
    call filter(srcfiles, 'v:val !~ "\\.d\\>"')
    call filter(srcfiles, 'v:val !~ "\\.obj\\>"')
    call filter(srcfiles, 'v:val !~ "\\.lib\\>"')
    call filter(srcfiles, 'v:val !~ "\\.so"')
    call filter(srcfiles, 'v:val !~ "\\.svn\\>"')
    call filter(srcfiles, 'v:val !~ "\\.git\\>"')
    call filter(srcfiles, 'v:val !~ "\\.bak\\>"')
    call filter(srcfiles, 'v:val !~ "\\.swp\\>"')
    call filter(srcfiles, 'v:val !~ "CVS"')

    let csrc = 0
    while csrc < len(srcfiles)
      let tmpstr   = strpart(srcfiles[csrc], strlen(topsrcdir))
      let menuitem = tmpstr
      let tmpstr   = substitute(menuitem, '^[\.\/]*', menuEntry, "g")
      let menuitem = tmpstr
      let tmpstr   = substitute(menuitem, '[\\/]', '/', "g")
      let menuitem = tmpstr
      let tmpstr   = substitute(menuitem, '\.', '\\.', "g")
      let menuitem = tmpstr
      let tmpstr   = substitute(menuitem, '\/', '.', "g")
      let menuitem = tmpstr
      let substr   = substitute(menuitem, '.*\(\<layout-[^.]*\>\).*', '\1', "g")
      if substr != menuitem
        let tmpstr = substitute(menuitem, '\<layout-[^.]*\>', substitute(substr, '-', '.', "g"), "g")
        let menuitem = tmpstr
      endif
      let substr   = substitute(menuitem, '.*\(\<drawable-[^.]*\>\).*', '\1', "g")
      if substr != menuitem
        let tmpstr = substitute(menuitem, '\<drawable-[^.]*\>', substitute(substr, '-', '.', "g"), "g")
        let menuitem = tmpstr
      endif
      let tmpstr   = substitute(menuitem, '\.values-', '.values.Translations.', "g")
      let menuitem = tmpstr
      if getftype(srcfiles[csrc]) == "dir"
        if matchstr(srcfiles[csrc], "[\\/]src$") != ""
          execute "an <silent> " menuitem . ".New\\ Package :silent! call <SID>NewPackageFile('" . srcfiles[csrc] . "','" . menuitem . "','')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        elseif matchstr(srcfiles[csrc], "[\\/]res[\\/]layout[^\\/]*$") != ""
          execute "an <silent> " menuitem . ".New\\ Layout\\ File :silent! call <SID>NewLayoutFile('" . srcfiles[csrc] . "','" . menuitem .  "')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        elseif matchstr(srcfiles[csrc], "[\\/]res[\\/]drawable[^\\/]*$") != ""
          execute "an <silent> " menuitem . ".New\\ XML\\ Bitmap\\ File :silent! call <SID>NewXmlBitmapFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ XML\\ Nine\\ Patch\\ File :silent! call <SID>NewXmlNinePatchFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Layer\\ List\\ File :silent! call <SID>NewLayerListFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ State\\ List\\ File :silent! call <SID>NewDrawableSelctorFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Level\\ List\\ File :silent! call <SID>NewLevelListFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Transition\\ File :silent! call <SID>NewTransitionFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Inset\\ File :silent! call <SID>NewInsetFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Clip\\ File :silent! call <SID>NewClipFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Scale\\ File :silent! call <SID>NewScaleFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Shape\\ File :silent! call <SID>NewShapeFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        elseif matchstr(srcfiles[csrc], "[\\/]res[\\/]anim$") != ""
          execute "an <silent> " menuitem . ".New\\ Tween\\ Animation\\ File :silent! call <SID>NewTweenAnimationFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Frame\\ Animation\\ File :silent! call <SID>NewFrameAnimationFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Accelerate\\ Decelerate\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','accelerateDecelerateInterpolator')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Accelerate\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','accelerateInterpolator')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Anticipate\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','anticipateInterpolator')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Anticipate\\ Overshoot\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','anticipateOvershootInterpolator')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Bounce\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','bounceInterpolator')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Cycle\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','cycleInterpolator')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Decelerate\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','decelerateInterpolator')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Linear\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','linearInterpolator')<CR>"
          execute "an <silent> " menuitem . ".New\\ Custom\\ Interpolator\\ File.Overshoot\\ Interpolator :silent! call <SID>NewCustomInterpolatorFile('" . srcfiles[csrc] . "','" . menuitem . "','overshootInterpolator')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        elseif matchstr(srcfiles[csrc], "[\\/]res[\\/]animator$") != ""
          execute "an <silent> " menuitem . ".New\\ Property\\ Animation\\ File :silent! call <SID>NewPropertyAnimationFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        elseif matchstr(srcfiles[csrc], "[\\/]res[\\/]color$") != ""
          execute "an <silent> " menuitem . ".New\\ Color\\ State\\ List\\ File :silent! call <SID>NewColorSelectorFile('" . srcfiles[csrc] . "','" . menuitem . "')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        elseif matchstr(srcfiles[csrc], "[\\/]res[\\/]menu$") != ""
          execute "an <silent> " menuitem . ".New\\ Menu\\ File :silent! call <SID>NewMenuFile('" . srcfiles[csrc] . "')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        elseif matchstr(srcfiles[csrc], "[\\/]res[\\/]values$") != ""
          execute "an <silent> " menuitem . ".New\\ Resource\\ File :silent! call <SID>NewResourceFile('" . srcfiles[csrc] . "')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
          execute "an <silent> " menuitem . ".Translations.New\\ Translation :silent! call <SID>NewTranslationFile('" . srcfiles[csrc] . "')<CR>"
          execute "an <silent> " menuitem . ".Translations.-sep1- <nop>"
        elseif matchstr(srcfiles[csrc], "[\\/]res[\\/]xml$") != ""
          execute "an <silent> " menuitem . ".New\\ XML\\ File :silent! call <SID>NewXmlFile('" . srcfiles[csrc] . "')<CR>"
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        elseif globpath(srcfiles[csrc],"*") == ""
          execute "an <silent> " menuitem . ".-sep1- <nop>"
        endif
      elseif getftype(srcfiles[csrc]) == "file"
        if filereadable(srcfiles[csrc])
          execute "bad" srcfiles[csrc]
          if (first == 1)
            execute ":compiler! ant"
            execute ":b " . srcfiles[csrc]
            let first = 0
          endif
        endif
        execute "an <silent> " menuitem . " :silent! call <SID>ShowInBuffer('" . topsrcdir . "','" . srcfiles[csrc] . "','" . g:currentPackage . "','" . g:currentActivity . "')<CR>"
        call javacomplete#AddSourcePath(topsrcdir)
      endif
      let csrc = csrc + 1
    endwhile
    let counter = counter + 1
  endwhile
  let g:currentPackage  = ""
  let g:currentActivity = ""
endfunction

function! s:PrepareStr(strin)
  return substitute(a:strin, '[ 	]', '', "g")
endfunction

function! s:AndroidManager(component)
  if has('win32')
    let command='!start /min cmd /c "android ' . a:component . ' & ' .
                        \ 'gvim --servername ' . v:servername .
                        \ ' --remote-send "<ESC>:silent\! call SetupAndroidSDK()<CR>" "'
  else
    let command="!( android " . a:component . " ; " .
                        \ "gvim --servername " . v:servername .
                        \ " --remote-send '<ESC>:silent\\! call SetupAndroidSDK()<CR>' ) &"
  endif
  execute command
  execute "redraw!"
endfunction

function! s:ConnectToDevice()
  let devlist=system("adb devices")
  let devices=split(devlist,"\n")
  call sort(devices)
  let content = []
  call add(content, "Select the device SN:")
  let device=0
  let id=1
  while device < len(devices)
    if matchstr(devices[device], "^[0-9a-fA-F]\\+") != ""
      let sn=substitute(devices[device],"[ 	].*","","g")
      let models=split(system("adb -s " . sn . " -e shell getprop ro.product.model"),"\n")
      call add(content, id . ". " . sn . " - " . models[0] )
      let id=id+1
    endif  
    let device=device+1
  endwhile
  let idsn=inputlist(content)
  " let sn=substitute(content[idsn],"^[0-9]\\+\\. \\([0-9a-fA-F]\\+\\)[ 	].*","\\1","g")
  let sn=substitute(content[idsn],"^[0-9]\\+\\.[    ]\\+\\([^    ]\\+\\)[ 	]\\+.*$","\\1","g")
  echo sn
  let $ANDROID_SERIAL=sn
  " execute "redraw!"
endfunction

function! s:RunDroidDraw()
  if filereadable(g:droidDrawJar)
    let current_file = matchstr(expand('%:p'), "^.*[\\/]res[\\/]layout[^\\/]*[\\/][^\\/]\\+\.xml$")
    if has('win32')
      let command='!start /min cmd /c "java -jar ' . g:droidDrawJar . ' ' . current_file . '"'
    else
      let command='!java -jar ' . g:droidDrawJar . ' ' . current_file . ' &'
    endif
    execute command
    execute "redraw!"
  endif
endfunction

function! s:RunDDMS()
  if has('win32')
    let command='!start /min cmd /c "ddms"'
  else
    let command='!ddms &'
  endif
  execute command
  execute "redraw!"
endfunction

function! s:RunEmulator(id)
  if has('win32')
    let command='!start /min cmd /c "emulator -avd "' . a:id . '" -partition-size 1024 "'
  else
    let command='!emulator -avd "' . a:id . '" -partition-size 1024 &'
  endif
  execute command
endfunction

function! s:Make(command)
  if a:command == "clean"
    :unsilent make clean
  elseif a:command == "uninstall"
    :unsilent make uninstall
  elseif a:command == "debug"
    :unsilent make debug
  elseif a:command == "debug_install"
    :unsilent make debug install
  elseif a:command == "install_debug"
    :unsilent make installd
  elseif a:command == "release"
    :unsilent make release
  elseif a:command == "release_install"
    :unsilent make release install
  elseif a:command == "install_release"
    :unsilent make installr
  elseif a:command == "run_release"
    unsilent execute "!adb shell am start    -n " . g:currentPackage . "/" . g:currentPackage . g:currentActivity
  elseif a:command == "run_debug"
    unsilent execute "!adb shell am start -D -n " . g:currentPackage . "/" . g:currentPackage . g:currentActivity
  endif
  copen
endfunction

function! s:SetClassPath(path,id)
  let &titlestring="[ADK " . substitute(a:id,"\\","","g") . "] %t%(\ %M%)%(\ (%{expand(\"%:~:h\")})%)%(\ %a%)"
  call javacomplete#SetClassPath('" . a:path . "')
endfunction

function! SetupAndroidSDK()
  execute "aun Android.*"

  if executable("java")
    if filereadable(expand($DROID_DRAW_JAR))
      let g:droidDrawJar = expand($DROID_DRAW_JAR)
    elseif filereadable(expand($HOME . "/.vim/plugin/" . g:defaultDroidDrawJar))
      let g:droidDrawJar = expand($HOME . "/.vim/plugin/" . g:defaultDroidDrawJar)
    elseif filereadable(expand($VIM . "/plugin/" . g:defaultDroidDrawJar))
      let g:droidDrawJar = expand($VIM . "/plugin/" . g:defaultDroidDrawJar)
    elseif filereadable(expand($VIMRUNTIME . "/plugin/" . g:defaultDroidDrawJar))
      let g:droidDrawJar = expand($VIMRUNTIME . "/plugin/" . g:defaultDroidDrawJar)
    endif
  endif

  if executable("android")
    let output=system("android list target")
    let targets=split(output,"\n")
    call sort(targets)
    let ctgts=0
    while ctgts < len(targets)
      if matchstr(targets[ctgts], "^id:") != ""
        let tokens=matchlist(targets[ctgts],'^id:[ 	]\([^ 	]*\)[ 	][^"]*"\(.*\)"$')
        let id=tokens[1]
        let target=substitute(tokens[2],"\\([  .]\\)","\\\\\\1","g")
        execute "an Android.New\\ Project.Application." . target . " :silent! call <SID>NewProject('app', " . id . ")<CR>"
        execute "an Android.New\\ Project.Library." . target . " :silent! call <SID>NewProject('lib', " . id . ")<CR>"
      endif
      let ctgts=ctgts+1
    endwhile
    execute "an Android.Open\\ Project :silent! call <SID>OpenProject('')<CR>"

    execute "an Android.-sep1-                                            <nop>"
    execute "an Android.Actions.Clean\\ Project                           :silent! call <SID>Make('clean')<CR>"
    execute "an Android.Actions.Uninstall\\ APK                           :silent! call <SID>Make('uninstall')<CR>"
    execute "an Android.Actions.-sep1-                                    <Nop>"
    execute "an Android.Actions.Build\\ Debug\\ version                   :silent! call <SID>Make('debug')<CR>"
    execute "an Android.Actions.Build\\ Debug\\ version\\ and\\ Install   :silent! call <SID>Make('debug_install')<CR>"
    execute "an Android.Actions.Install\\ Debug\\ version                 :silent! call <SID>Make('install_debug')<CR>"
    execute "an Android.Actions.-sep2-                                    <Nop>"
    execute "an Android.Actions.Build\\ Release\\ version                 :silent! call <SID>Make('release')<CR>"
    execute "an Android.Actions.Build\\ Release\\ version\\ and\\ Install :silent! call <SID>Make('release_install')<CR>"
    execute "an Android.Actions.Install\\ Release\\ version               :silent! call <SID>Make('install_release')<CR>"
    execute "an Android.Actions.-sep3-            <Nop>"
    execute "an Android.Actions.Execute\\ in\\ Debug\\ mode               :silent! call <SID>Make('run_debug')<CR>"
    execute "an Android.Actions.Execute\\ in\\ Release\\ mode             :silent! call <SID>Make('run_release')<CR>"
    if filereadable(g:droidDrawJar)
      execute "an Android.Actions.-sep4-                                  <Nop>"
      execute "an Android.Actions.Run\\ the\\ layout\\ editor             :silent! call <SID>RunDroidDraw()<CR>"
    endif

    execute "an Android.-sep2- <nop>"
    let files=glob($ANDROID_SDK . "/platforms/*/android.jar")
    let jars = []
    let jars += split(files)
    call sort(jars)
    let counter = 0
    while counter < len(jars)
      let topsrcdir = substitute(jars[counter], '[\\/]android.jar', "", "g")
      let items     = split(topsrcdir,"[\\/]")
      let target0   = substitute(items[len(items) - 1], '\.', '\\.', "g")
      let target1   = substitute(target0, '^android-', '', "g")
      let target    = substitute(target1, '_.*', '', "g")
      echo target . " - " . jars[counter]
      execute "an Android.Set\\ Target\\ Classpath." . target . " :silent! call <SID>SetClassPath('" . jars[counter] . "','" . target . "')<CR>"
      if counter == 0
        call SetClassPath(jars[counter],target)
      endif
      let counter=counter+1
    endwhile

    execute "an Android.-sep3- <nop>"
    execute "an Android.SDK\\ Manager :silent! call <SID>AndroidManager('sdk')<CR>"
    execute "an Android.AVD\\ Manager :silent! call <SID>AndroidManager('avd')<CR>"
    execute "an Android.-sep2- <nop>"
    let avdlist=system("android list avd")
    let avds=split(avdlist,"\n")
    call sort(avds)
    let cavds=0
    while cavds < len(avds)
      if matchstr(avds[cavds], "^[     ]*Name:") != ""
        let tokens=matchlist(avds[cavds],'^[   ]*Name:[ 	]*\(.*\)$')
        let avd=tokens[1]
        let avditem=substitute(tokens[1],"\\([  .]\\)","\\\\\\1","g")
        execute "an Android.Run\\ Emulator." . avditem . " :silent! call <SID>RunEmulator('" . avd . "')<CR>"
      endif
      let cavds=cavds+1
    endwhile
    execute "an Android.Run\\ Dalvik\\ Debug\\ Monitor :silent! call <SID>RunDDMS()<CR>"
    execute "an Android.Connect\\ to\\ device :call <SID>ConnectToDevice()<CR>"
  else
    execute "an Android.Please\\ setup\\ PATH\\ for\\ android-sdk\\ and\\ ant\\ tools  <NOP>"
  endif

  execute "an <silent> 2.400 ToolBar.-sep8-            <Nop>"
  execute "an <silent> 2.401 ToolBar.AntClean          :silent! call <SID>Make('clean')<CR>"
  execute "an <silent> 2.402 ToolBar.AntUninstall      :silent! call <SID>Make('uninstall')<CR>"
  execute "an <silent> 2.410 ToolBar.-sep9-            <Nop>"
  execute "an <silent> 2.411 ToolBar.AntDebug          :silent! call <SID>Make('debug')<CR>"
  execute "an <silent> 2.412 ToolBar.AntDebugInstall   :silent! call <SID>Make('debug_install')<CR>"
  execute "an <silent> 2.413 ToolBar.AntInstallDebug   :silent! call <SID>Make('install_debug')<CR>"
  execute "an <silent> 2.420 ToolBar.-sep10-           <Nop>"
  execute "an <silent> 2.421 ToolBar.AntRelease        :silent! call <SID>Make('release')<CR>"
  execute "an <silent> 2.422 ToolBar.AntReleaseInstall :silent! call <SID>Make('release_install')<CR>"
  execute "an <silent> 2.423 ToolBar.AntInstallRelease :silent! call <SID>Make('install_release')<CR>"
  execute "an <silent> 2.430 ToolBar.-sep11-           <Nop>"
  execute "an <silent> 2.431 ToolBar.AntRunDebug       :silent! call <SID>Make('run_debug')<CR>"
  execute "an <silent> 2.432 ToolBar.AntRunRelease     :silent! call <SID>Make('run_release')<CR>"
  execute "an <silent> 2.440 ToolBar.-sep12-           <Nop>"
  if filereadable(g:droidDrawJar)
    execute "an <silent> 2.441 ToolBar.DroidDraw         :silent! call <SID>RunDroidDraw()<CR>"
    execute "an <silent> 2.450 ToolBar.-sep13-           <Nop>"
  endif

  execute "tmenu ToolBar.AntClean          Clean Project"
  execute "tmenu ToolBar.AntUninstall      Uninstall APK"
  execute "tmenu ToolBar.AntDebug          Build Debug version"
  execute "tmenu ToolBar.AntDebugInstall   Build Debug version and Install"
  execute "tmenu ToolBar.AntInstallDebug   Install Debug version"
  execute "tmenu ToolBar.AntRelease        Build Release version"
  execute "tmenu ToolBar.AntReleaseInstall Build Release version and Install"
  execute "tmenu ToolBar.AntInstallRelease Install Release version"
  execute "tmenu ToolBar.AntRunDebug       Execute in Debug mode"
  execute "tmenu ToolBar.AntRunRelease     Execute in Release mode"
  if filereadable(g:droidDrawJar)
    execute "tmenu ToolBar.DroidDraw         Run the layout editor"
  endif
endfunction

function! s:EditProject(topsrcdir,target)
  let command = "android update project --path " . a:topsrcdir . " --subprojects --target " . a:target
  call system(command)
endfunction

function! s:NewProject(kind,target)
  let prjName = s:PrepareStr(inputdialog("Insert the project name:", ""))
  if prjName != ""
    let prjUrl = s:PrepareStr(inputdialog("Insert the vendor url (i.e. org.vendor):", ""))
    if prjUrl != ""
      let prjUrl = s:PrepareStr(tolower(prjUrl . '.' . prjName))
      let topdir = substitute(browsedir("Select the topmost directory", "."), "\\", "/", "g")
      if getftype(topdir) == "dir"
        execute ":cd " . topdir
        let topdir=getcwd()
        let prjPath = topdir . '/' . prjName
        if (a:kind=="app")
          let command="android create project --target " . a:target . " --name " . prjName . " --path " . prjName . " --activity " . prjName . " --package " . prjUrl
        else
          let command="android create lib-project --target " . a:target . " --name " . prjName . " --path " . prjName . " --package " . prjUrl
        endif
        call system(command)
        if isdirectory(prjPath)
          call s:OpenProject(prjPath)
        endif
      endif
    endif
  endif
endfunction

function! s:OpenProject(topdir)
  if getftype(a:topdir) != "dir"
    let topsrcdir = substitute(browsedir("Select the topmost directory", "."), "\\", "/", "g")
    if getftype(topsrcdir) != "dir"
      return
    endif
  else
    let topsrcdir = a:topdir
  endif

  execute ":cd "  . topsrcdir
  let topsrcdir=getcwd()
  "
  "---------------------
  " Adding files
  "---------------------
  "
  let files=globpath(topsrcdir, "**/AndroidManifest.xml")
  let manifests = []
  let manifests += split(files)
  call sort(manifests)
  call filter(manifests, 'v:val !~ "\\<bin\\>"')
  call filter(manifests, 'v:val !~ "\\<obj\\>"')
  call filter(manifests, 'v:val !~ "\\<libs\\>"')
  call filter(manifests, 'v:val !~ "\\<lib\\>"')
  unsilent call s:AddFiles(manifests)
endfunction

" Avoid installing the menus twice
if !exists("did_android_menus")
  let did_android_menus = 1
  silent! call SetupAndroidSDK()
endif
