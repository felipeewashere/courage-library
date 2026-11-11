local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()local
Util={Library=nil}local clone=type(cloneref)=='function'and cloneref or function
(object)return object end local Services=setmetatable({},{__index=function(self,
name)local service=clone(game:GetService(name))rawset(self,name,service)return
service end})Util.Services=Services local TEXT_CLASSES={TextLabel=true,
TextButton=true,TextBox=true}local function isThemeProp(key)return key==
'FontFace'or key=='Color'or string.sub(key,-6)=='Color3'end function Util.
Register(object,props)local Library=Util.Library local entry=Library.Registry[
object]if not entry then entry={}Library.Registry[object]=entry end for key,
source in pairs(props)do entry[key]=source if type(source)=='function'then
object[key]=source(Library.Theme)else object[key]=Library.Theme[source]end end
end function Util.New(class,props)local Library=Util.Library local object=
Instance.new(class)local themed if object:IsA('GuiObject')then object.
BorderSizePixel=0 if object:IsA('GuiButton')then object.AutoButtonColor=false
end if TEXT_CLASSES[class]then themed={FontFace='Font',TextColor3='Text'}object.
TextSize=14 if class~='TextBox'then object.Text=''end end end local parent for
key,value in pairs(props)do if key=='Parent'then parent=value elseif type(key)==
'number'then value.Parent=object elseif type(value)=='string'and isThemeProp(key
)and Library.Theme[value]~=nil then themed=themed or{}themed[key]=value else if
themed then themed[key]=nil end object[key]=value end end if themed and next(
themed)then Util.Register(object,themed)end if parent then object.Parent=parent
end return object end function Util.Destroy(object)local registry=Util.Library.
Registry registry[object]=nil for _,child in ipairs(object:GetDescendants())do
registry[child]=nil end object:Destroy()end function Util.Corner(parent,radius)
return Util.New('UICorner',{CornerRadius=UDim.new(0,radius),Parent=parent})end
function Util.Stroke(parent,color,thickness,transparency)return Util.New(
'UIStroke',{Color=color or'Outline',Thickness=thickness or 1,Transparency=
transparency or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=parent})end
function Util.Pad(parent,left,top,right,bottom)top=top or left return Util.New(
'UIPadding',{PaddingLeft=UDim.new(0,left),PaddingTop=UDim.new(0,top),
PaddingRight=UDim.new(0,right or left),PaddingBottom=UDim.new(0,bottom or top),
Parent=parent})end function Util.List(parent,padding,direction,horizontal,
vertical)return Util.New('UIListLayout',{Padding=UDim.new(0,padding or 0),
FillDirection=direction or Enum.FillDirection.Vertical,HorizontalAlignment=
horizontal or Enum.HorizontalAlignment.Left,VerticalAlignment=vertical or Enum.
VerticalAlignment.Top,SortOrder=Enum.SortOrder.LayoutOrder,Parent=parent})end
function Util.Tween(object,duration,props,style,direction)if not Util.Library.
Animations or duration<=0 then for key,value in pairs(props)do object[key]=value
end return nil end local tween=Services.TweenService:Create(object,TweenInfo.
new(duration,style or Enum.EasingStyle.Quint,direction or Enum.EasingDirection.
Out),props)tween:Play()return tween end function Util.TweenTheme(object,duration
,props)local Library=Util.Library local entry=Library.Registry[object]if not
entry then entry={}Library.Registry[object]=entry end local goal={}for key,
themeKey in pairs(props)do entry[key]=themeKey goal[key]=Library.Theme[themeKey]
end return Util.Tween(object,duration,goal)end function Util.Safe(callback,...)
if type(callback)~='function'then return end local ok,reason=pcall(callback,...)
if not ok and Util.Library.Debug then warn('[CourageUI] callback error: '..
tostring(reason))end end function Util.IsClick(input)return input.UserInputType
==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.
Touch end function Util.InputPos(input)return Vector2.new(input.Position.X,input
.Position.Y)end function Util.Mouse()return Services.UserInputService:
GetMouseLocation()-Services.GuiService:GetGuiInset()end function Util.Inside(
object,point)local position,size=object.AbsolutePosition,object.AbsoluteSize
return point.X>=position.X and point.X<=position.X+size.X and point.Y>=position.
Y and point.Y<=position.Y+size.Y end function Util.Drag(hit,onStart,onMove,onEnd
)local UserInputService=Services.UserInputService Util.Library:GiveSignal(hit.
InputBegan:Connect(function(input)if not Util.IsClick(input)then return end if
onStart and onStart(Util.InputPos(input),input)==false then return end local
moved,ended moved=UserInputService.InputChanged:Connect(function(change)if
change==input or(change.UserInputType==Enum.UserInputType.MouseMovement and
input.UserInputType==Enum.UserInputType.MouseButton1)then onMove(Util.InputPos(
change))end end)ended=UserInputService.InputEnded:Connect(function(finish)if
finish==input or(finish.UserInputType==Enum.UserInputType.MouseButton1 and input
.UserInputType==Enum.UserInputType.MouseButton1)then moved:Disconnect()ended:
Disconnect()if onEnd then onEnd()end end end)end))end function Util.Draggable(
frame,handle)local startPointer,startPosition Util.Drag(handle or frame,function
(pointer)startPointer,startPosition=pointer,frame.Position end,function(pointer)
local delta=pointer-startPointer frame.Position=UDim2.new(startPosition.X.Scale,
startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+
delta.Y)end)end function Util.Hover(object,onEnter,onLeave)local Library=Util.
Library Library:GiveSignal(object.MouseEnter:Connect(onEnter))Library:
GiveSignal(object.MouseLeave:Connect(onLeave))end function Util.Chevron(parent,
color)local holder=Util.New('Frame',{Size=UDim2.fromOffset(10,10),
BackgroundTransparency=1,Parent=parent})for _,side in ipairs({-1,1})do local bar
=Util.New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,side*
2.4,0.5,0),Size=UDim2.fromOffset(7,1.6),Rotation=side*-42,BackgroundColor3=color
or'Dim',Parent=holder})Util.Corner(bar,1)end return holder end function Util.
PlacePopup(popup,anchor,width,height)local scale=Util.Library.DPIScale local
camera=Services.Workspace.CurrentCamera local view=camera and camera.
ViewportSize or Vector2.new(1920,1080)local position,size=anchor.
AbsolutePosition,anchor.AbsoluteSize local x=math.clamp(position.X+size.X-width*
scale,4,math.max(4,view.X-width*scale-4))local inset=Services.GuiService:
GetGuiInset()local y=position.Y+inset.Y+size.Y+4 if y+height*scale>view.Y-4 then
y=math.max(4,position.Y+inset.Y-height*scale-4)end popup.Position=UDim2.
fromOffset(x+inset.X,y)end return Util end function __DARKLUA_BUNDLE_MODULES.a()
local v=__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end do local function 
__modImpl()return function(Library)local rgb=Color3.fromRGB Library.Themes={
Courage={BackgroundColor=rgb(13,10,24),MainColor=rgb(21,17,38),AccentColor=rgb(
150,84,255),OutlineColor=rgb(52,43,92),FontColor=rgb(240,238,252)},Midnight={
BackgroundColor=rgb(10,12,20),MainColor=rgb(17,20,32),AccentColor=rgb(88,130,255
),OutlineColor=rgb(38,46,74),FontColor=rgb(232,238,255)},Rose={BackgroundColor=
rgb(22,10,16),MainColor=rgb(34,17,26),AccentColor=rgb(255,92,150),OutlineColor=
rgb(84,40,60),FontColor=rgb(255,238,244)},Emerald={BackgroundColor=rgb(8,16,14),
MainColor=rgb(14,26,22),AccentColor=rgb(52,211,153),OutlineColor=rgb(30,62,52),
FontColor=rgb(232,250,243)},Sunset={BackgroundColor=rgb(22,12,10),MainColor=rgb(
34,20,16),AccentColor=rgb(255,138,76),OutlineColor=rgb(84,50,38),FontColor=rgb(
255,241,232)},Ocean={BackgroundColor=rgb(8,14,22),MainColor=rgb(13,23,36),
AccentColor=rgb(56,189,248),OutlineColor=rgb(30,56,84),FontColor=rgb(230,244,255
)},Blood={BackgroundColor=rgb(16,8,8),MainColor=rgb(28,14,14),AccentColor=rgb(
239,68,68),OutlineColor=rgb(74,32,32),FontColor=rgb(255,236,236)},Gold={
BackgroundColor=rgb(14,12,6),MainColor=rgb(24,21,12),AccentColor=rgb(250,204,21)
,OutlineColor=rgb(70,60,28),FontColor=rgb(255,250,230)},Mono={BackgroundColor=
rgb(10,10,10),MainColor=rgb(18,18,18),AccentColor=rgb(235,235,235),OutlineColor=
rgb(50,50,50),FontColor=rgb(250,250,250)},Dracula={BackgroundColor=rgb(33,34,44)
,MainColor=rgb(40,42,54),AccentColor=rgb(189,147,249),OutlineColor=rgb(68,71,90)
,FontColor=rgb(248,248,242)},['Tokyo Night']={BackgroundColor=rgb(26,27,38),
MainColor=rgb(36,40,59),AccentColor=rgb(122,162,247),OutlineColor=rgb(65,72,104)
,FontColor=rgb(192,202,245)},Catppuccin={BackgroundColor=rgb(24,24,37),MainColor
=rgb(30,30,46),AccentColor=rgb(203,166,247),OutlineColor=rgb(69,71,90),FontColor
=rgb(205,214,244)}}Library.ThemeOrder={'Courage','Midnight','Rose','Emerald',
'Sunset','Ocean','Blood','Gold','Mono','Dracula','Tokyo Night','Catppuccin'}
Library.FontFamilies={Gotham='rbxasset://fonts/families/GothamSSm.json',Inter=
'rbxasset://fonts/families/Inter.json',Montserrat=
'rbxasset://fonts/families/Montserrat.json',Nunito=
'rbxasset://fonts/families/Nunito.json',Ubuntu=
'rbxasset://fonts/families/Ubuntu.json',['Builder Sans']=
'rbxasset://fonts/families/BuilderSans.json',['Source Sans']=
'rbxasset://fonts/families/SourceSansPro.json',['Roboto Mono']=
'rbxasset://fonts/families/RobotoMono.json'}Library.Scheme={FontName='Gotham',
RedColor=rgb(255,86,110)}for key,value in pairs(Library.Themes.Courage)do
Library.Scheme[key]=value end Library.Theme={}local function fontFamily(font)if
typeof(font)=='EnumItem'then return Font.fromEnum(font).Family end if typeof(
font)=='Font'then return font.Family end return Library.FontFamilies[font]or
Library.FontFamilies.Gotham end function Library:UpdateColorsUsingRegistry()
local scheme,theme=self.Scheme,self.Theme local white,black=Color3.new(1,1,1),
Color3.new(0,0,0)theme.Background=scheme.BackgroundColor theme.Inset=scheme.
BackgroundColor:Lerp(black,0.28)theme.Main=scheme.MainColor theme.Raised=scheme.
MainColor:Lerp(scheme.FontColor,0.07)theme.Outline=scheme.OutlineColor theme.
Accent=scheme.AccentColor theme.AccentDark=scheme.AccentColor:Lerp(black,0.38)
theme.AccentSoft=scheme.MainColor:Lerp(scheme.AccentColor,0.22)theme.Text=scheme
.FontColor theme.Dim=scheme.FontColor:Lerp(scheme.MainColor,0.42)theme.Red=
scheme.RedColor theme.White=white theme.Black=black local custom=scheme.Font
local family=fontFamily(scheme.FontName)if typeof(custom)=='EnumItem'or(typeof(
custom)=='Font'and custom~=self.LastFont)then family=fontFamily(custom)end theme
.Font=Font.new(family,Enum.FontWeight.Medium)scheme.Font=theme.Font self.
LastFont=theme.Font theme.FontSemi=Font.new(family,Enum.FontWeight.SemiBold)
theme.FontBold=Font.new(family,Enum.FontWeight.Bold)for object,props in pairs(
self.Registry)do for key,source in pairs(props)do local ok=pcall(function()if
type(source)=='function'then object[key]=source(theme)else object[key]=theme[
source]end end)if not ok then self.Registry[object]=nil break end end end for _,
listener in ipairs(self.ThemeListeners)do pcall(listener)end end function
Library:GetThemes()local names=table.clone(self.ThemeOrder)return names end
function Library:SetTheme(name)local theme=self.Themes[name]if not theme then
return false end for key,value in pairs(theme)do self.Scheme[key]=value end self
:UpdateColorsUsingRegistry()return true end function Library:OnThemeChanged(
listener)table.insert(self.ThemeListeners,listener)end function Library:
AddToRegistry(object,props)local Util=self.Util local mapped={}local keys={
BackgroundColor='Background',MainColor='Main',AccentColor='Accent',OutlineColor=
'Outline',FontColor='Text',RedColor='Red'}for key,value in pairs(props)do mapped
[key]=keys[value]or value end pcall(Util.Register,object,mapped)end end end
function __DARKLUA_BUNDLE_MODULES.b()local v=__DARKLUA_BUNDLE_MODULES.cache.b if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.b=v end return v.c
end end do local function __modImpl()return{Map={['badge-info']='info-circle',[
'binoculars']='telescope',['brain']='lightbulb-bolt',['check']='check-circle',[
'circle-dot']='record-circle',['circle-help']='question-circle',['clock']=
'clock-circle',['code']='code',['coins']='dollar',['copy']='copy',['crosshair']=
'target',['download']='download-minimalistic',['file']='file',['flask-conical']=
'test-tube',['footprints']='walking',['gamepad-2']='gamepad',['globe']='global',
['hammer']='sledgehammer',['hand']='hand-stars',['hard-drive']='ssd-square',[
'house']='home',['image']='gallery',['info']='info-circle',['layout-grid']=
'widget',['link-2']='link',['list-checks']='checklist',['lock']='lock',[
'map-pin']='map-point',['menu']='hamburger-menu',['message-circle']='chat-round'
,['moon']='moon',['mouse-pointer-click']='cursor',['music']='music-note',[
'network']='structure',['notebook-tabs']='notebook',['pencil']='pen',[
'person-standing']='user-rounded',['plus']='add-circle',['power']='power',[
'puzzle']='widget-add',['refresh-cw']='refresh',['save']='diskette',['scan-eye']
='eye-scan',['scan-face']='face-scan-circle',['scroll']='document',[
'scroll-text']='document-text',['shield-alert']='shield-warning',['skull']=
'ghost',['sliders-horizontal']='tuning-2',['sparkles']='stars',['sun']='sun',[
'sword']='fire',['swords']='fire',['tab']='siderbar',['terminal']='code-square',
['timer']='stopwatch',['trash']='trash-bin-trash',['trash-2']='trash-bin-trash',
['triangle-alert']='danger-triangle',['users']='users-group-rounded',[
'venetian-mask']='masks',['wifi']='wi-fi-router',['wrench']=
'settings-minimalistic',['x']='close-circle',['zap']='bolt'},Icons={['4-k']=
101120062438598,['accessibility']=93185703470955,['accumulator']=77779477064861,
['add-circle']=139478909806812,['add-folder']=79676023660166,['add-square']=
123814080145589,['adhesive-plaster']=103862563694954,['adhesive-plaster-2']=
137710405817081,['airbuds']=79899601682293,['airbuds-case']=91577497572229,[
'airbuds-case-charge']=81628313108625,['airbuds-case-minimalistic']=
101860495296783,['airbuds-case-open']=101161334364687,['airbuds-charge']=
100856387884674,['airbuds-check']=73717092179504,['airbuds-left']=83620215682090
,['airbuds-remove']=80866575674358,['airbuds-right']=125657715024097,['alarm']=
87863196054318,['alarm-add']=118832521157694,['alarm-pause']=140034283208649,[
'alarm-play']=117542211985752,['alarm-remove']=86145891651954,['alarm-sleep']=
83595096742619,['alarm-turn-off']=94898956597322,['album']=100080266427156,[
'align-bottom']=76617820234901,['align-horizonta-spacing']=102991878824177,[
'align-horizontal-center']=104415582756414,['align-left']=100463302569744,[
'align-right']=117468537936756,['align-top']=95658281880384,[
'align-vertical-center']=92116479462116,['align-vertical-spacing']=
92654428361528,['alt-arrow-down']=92993587446526,['alt-arrow-left']=
123545657728863,['alt-arrow-right']=136791643717191,['alt-arrow-up']=
133229409654787,['archive']=82469497521888,['archive-check']=94946977115413,[
'archive-down']=112130596451932,['archive-down-minimlistic']=94441493899481,[
'archive-minimalistic']=131697260777673,['archive-up']=101963344754794,[
'archive-up-minimlistic']=105546392045741,['armchair']=77008061642022,[
'armchair-2']=110137596225198,['arrow-down']=82011741143422,['arrow-left']=
71060793100374,['arrow-left-down']=72071078068087,['arrow-left-up']=
87473838921428,['arrow-right']=118048207855996,['arrow-right-down']=
114167181406052,['arrow-right-up']=99571448751925,['arrow-to-down-left']=
124621822043691,['arrow-to-down-right']=77591094009658,['arrow-to-top-left']=
109577653463461,['arrow-to-top-right']=90221999473344,['arrow-up']=
137791757637907,['asteroid']=75161033390887,['atom']=92952105276942,[
'augmented-reality']=83574041700058,['backpack']=127779415041047,['backspace']=
137524521645806,['bacteria']=111802270049171,['bag']=81962890075637,['bag-2']=
134283957232104,['bag-3']=133056900985022,['bag-4']=99683328329836,['bag-5']=
80797096909615,['bag-check']=71078298136993,['bag-cross']=77291805451487,[
'bag-heart']=125637933423553,['bag-music']=96382736667853,['bag-music-2']=
99963230743842,['bag-smile']=109018139365567,['balloon']=132517895089288,[
'balls']=128007708227558,['banknote']=96952241297285,['banknote-2']=
133956687343423,['bar-chair']=76250742715772,['basketball']=94041625460179,[
'bath']=102699788783597,['battery-charge']=100475543714865,[
'battery-charge-minimalistic']=74262418671062,['battery-full']=133703018655079,[
'battery-full-minimalistic']=138913001687451,['battery-half']=126213872489127,[
'battery-half-minimalistic']=126835244306746,['battery-low']=122579327992440,[
'battery-low-minimalistic']=91812294716743,['bed']=85039430100012,[
'bedside-table']=127339575908485,['bedside-table-2']=127357060463539,[
'bedside-table-3']=126668983712393,['bedside-table-4']=94361782916680,['bell']=
117594985029884,['bell-bing']=90010061712906,['bell-off']=128085899497128,[
'benzene-ring']=117176915495847,['bicycling']=133428474201868,['bicycling-round'
]=121968658208119,['bill']=79076541631110,['bill-check']=81102381230426,[
'bill-cross']=103021661260960,['bill-list']=109843453218379,['black-hole']=
133351596269875,['black-hole-2']=140195028508640,['black-hole-3']=
132428630870964,['bluetooth']=103766614486088,['bluetooth-circle']=
125016688396454,['bluetooth-square']=101941261809797,['bluetooth-wave']=
110539809989493,['body']=80297758353971,['body-shape']=138870821023962,[
'body-shape-minimalistic']=111590870437298,['bolt']=130006650864115,[
'bolt-circle']=111887894232172,['bomb']=86345767436552,['bomb-emoji']=
96091532250136,['bomb-minimalistic']=93289292369709,['bone']=92810326208125,[
'bone-broken']=129868656651421,['bone-crack']=103639382721615,['bones']=
89953822100418,['bonfire']=93575834873850,['book']=100641675079195,['book-2']=
140202546444576,['book-bookmark']=130784090293380,['book-bookmark-minimalistic']
=134583418904074,['book-minimalistic']=105656509929709,['bookmark']=
119882071213128,['bookmark-circle']=108669469214788,['bookmark-opened']=
119932665743988,['bookmark-square']=129536097403292,[
'bookmark-square-minimalistic']=77336520808134,['boombox']=123719435207308,[
'bottle']=118436758949093,['bowling']=80900773762567,['box']=129773998837019,[
'box-minimalistic']=84411265569462,['branching-paths-down']=130172472185466,[
'branching-paths-up']=73936780747200,['broom']=117933907616580,['bug']=
72884019555988,['bug-minimalistic']=127907192871672,['buildings']=
131037806195936,['buildings-2']=130421388375753,['buildings-3']=121075963539750,
['bus']=127617406469560,['calculator']=71842919641164,['calculator-minimalistic'
]=86763125044493,['calendar']=72861377194791,['calendar-add']=110893315233879,[
'calendar-date']=84762294531338,['calendar-mark']=111403507857580,[
'calendar-minimalistic']=93155514732975,['calendar-search']=135110980721455,[
'call-cancel']=130401442336024,['call-cancel-rounded']=109107939841841,[
'call-chat']=94482820796736,['call-chat-rounded']=106552307563170,[
'call-dropped']=84259190108719,['call-dropped-rounded']=124693178511966,[
'call-medicine']=123709541957602,['call-medicine-rounded']=84800694201321,[
'camera']=87068166927681,['camera-add']=110966563261508,['camera-minimalistic']=
81083337636599,['camera-rotate']=90982154854314,['camera-square']=
132468039215215,['card']=72046935796534,['card-2']=85080545102163,['card-recive'
]=82541807222771,['card-search']=104777342222451,['card-send']=102552737585107,[
'card-transfer']=76243440049768,['cardholder']=108585826887462,['cart']=
138472043527451,['cart-2']=137383884939025,['cart-3']=74809500253146,['cart-4']=
91739970331197,['cart-5']=111648669485488,['cart-check']=102943643099870,[
'cart-cross']=123639464425344,['cart-large']=94587988389300,['cart-large-2']=
76055686947636,['cart-large-3']=81358757896439,['cart-large-4']=102152941448876,
['cart-large-minimalistic']=108576259995833,['cart-plus']=105724815937174,[
'case']=119696465247383,['case-minimalistic']=97669720019378,['case-round']=
121744681305340,['case-round-minimalistic']=83606679966604,['cash-out']=
125777408982128,['cassette']=86644379909549,['cassette-2']=109801530784783,[
'cat']=105384072434825,['chair']=136818704379426,['chair-2']=89770976424319,[
'chandelier']=102497221047148,['chart']=96276751038556,['chart-2']=
118743447551317,['chart-square']=73897886601288,['chat-dots']=133686914253815,[
'chat-line']=112435740093712,['chat-round']=78330615352102,['chat-round-call']=
77596784979156,['chat-round-check']=125838499001073,['chat-round-dots']=
127493229409116,['chat-round-like']=118988251773984,['chat-round-line']=
112669223154865,['chat-round-money']=77000462768613,['chat-round-unread']=
89264502342756,['chat-round-video']=99284277113395,['chat-square']=
90706166955323,['chat-square-2']=104922074619504,['chat-square-arrow']=
94461822655610,['chat-square-call']=135442679420463,['chat-square-check']=
136066916290330,['chat-square-code']=70615504226457,['chat-square-like']=
109130783293898,['chat-unread']=92332599552446,['check-circle']=82820801644879,[
'check-read']=138274208772827,['check-square']=99566491733646,['checklist']=
136793214085079,['checklist-minimalistic']=86760195317849,['chef-hat']=
113870156642148,['chef-hat-heart']=134301061164302,['chef-hat-minimalistic']=
110783253227435,['circle-bottom-down']=135551371096609,['circle-bottom-up']=
128946377811138,['circle-top-down']=100770929961778,['circle-top-up']=
73051018110236,['city']=124023948851779,['clapperboard']=89719508620288,[
'clapperboard-edit']=128938026974232,['clapperboard-open']=104963698433171,[
'clapperboard-open-play']=73132126521195,['clapperboard-play']=111582197285199,[
'clapperboard-text']=73477971487222,['clipboard']=91016040046438,[
'clipboard-add']=136180905417645,['clipboard-check']=125586662813538,[
'clipboard-heart']=136940491369414,['clipboard-list']=109929897348568,[
'clipboard-remove']=102890040722269,['clipboard-text']=104672144915107,[
'clock-circle']=118979078864433,['clock-square']=81088894794035,['close-circle']
=103154043386406,['close-square']=117747448917698,['closet']=82375761095646,[
'closet-2']=79121792964717,['cloud']=108575613594275,['cloud-bolt']=
71224241453064,['cloud-bolt-minimalistic']=85544269522058,['cloud-check']=
136880017504577,['cloud-download']=95110638826999,['cloud-file']=114219090313200
,['cloud-minus']=117216213198839,['cloud-plus']=132303686006509,['cloud-rain']=
110376108133266,['cloud-snowfall']=94426070651598,['cloud-snowfall-minimalistic'
]=96006117954227,['cloud-storage']=129700043644165,['cloud-storm']=
113745543435089,['cloud-sun']=83282999774503,['cloud-sun-2']=115449627128729,[
'cloud-upload']=138593101904781,['cloud-waterdrop']=135781878918524,[
'cloud-waterdrops']=80640158841131,['clouds']=110655074990085,['cloudy-moon']=
96621356274700,['clound-cross']=134825811343636,['code']=137231383216181,[
'code-2']=137645011895167,['code-circle']=97156044146678,['code-file']=
117837330462036,['code-scan']=83531616308724,['code-square']=111042135639244,[
'colour-tuneing']=79820790543002,['command']=93159922068420,['compass']=
127242665382390,['compass-big']=124869961638781,['compass-square']=
73284095554635,['condicioner']=88254629086164,['condicioner-2']=112356125215271,
['confetti']=88722678775088,['confetti-minimalistic']=115073951260212,[
'confounded-circle']=118941931906260,['confounded-square']=74327663573532,[
'copy']=107485544510830,['copyright']=98543286923978,['corkscrew']=
75063608922953,['cosmetic']=131731033115365,['course-down']=117677816719749,[
'course-up']=117921035948036,['cpu']=131156235725075,['cpu-bolt']=92919014193893
,['creative-commons']=111834716132240,['crop']=116305623512280,[
'crop-minimalistic']=105158350951533,['crown']=116760779834746,['crown-line']=
131457704283344,['crown-minimalistic']=119226611739930,['crown-star']=
137184309074044,['cup']=76713390911381,['cup-first']=84944194486522,['cup-hot']=
126345557452931,['cup-music']=126100709562505,['cup-paper']=84717823163319,[
'cup-star']=124495333491453,['cursor']=82682091622365,['cursor-square']=
90390554022785,['danger']=112161288264181,['danger-circle']=118792892342823,[
'danger-square']=82318061319530,['danger-triangle']=111725057016862,['database']
=114209748010261,['delivery']=140037605911561,['devices']=124420224859502,[
'diagram-down']=125656875303554,['diagram-up']=136990905295365,['dialog']=
99959135295831,['dialog-2']=139285095589548,['diploma']=139231126691097,[
'diploma-verified']=130406838686147,['diskette']=100311085528798,['dislike']=
132142104138836,['display']=80243112979186,['dna']=127305757862516,['document']=
123316544392029,['document-add']=85660538990593,['document-medicine']=
130572522666406,['document-text']=128687888230039,['documents']=108349883969750,
['documents-minimalistic']=81144114750181,['dollar']=97783947612153,[
'dollar-minimalistic']=127871092309095,['donut']=109027053388168,['donut-bitten'
]=112452617245651,['double-alt-arrow-down']=110142860319495,[
'double-alt-arrow-left']=134102529597514,['double-alt-arrow-right']=
128999993985654,['double-alt-arrow-up']=93701167749989,['download']=
134000208220434,['download-minimalistic']=89402481288235,['download-square']=
111797411162104,['download-twice-square']=139792271820922,['dropper']=
95034602778070,['dropper-2']=122172977394880,['dropper-3']=124580567828410,[
'dropper-minimalistic']=105304005315158,['dropper-minimalistic-2']=
113481866487508,['dumbbell']=99013666612743,['dumbbell-large']=129379737580753,[
'dumbbell-large-minimalistic']=125799367645122,['dumbbell-small']=
137874993693288,['dumbbells']=138680867501464,['dumbbells-2']=118805487781369,[
'earth']=118828820753007,['electric-refueling']=84674148682167,[
'emoji-funny-circle']=74881798923771,['emoji-funny-square']=97591093867810,[
'end-call']=122558856077685,['end-call-rounded']=139336956699060,['eraser']=
81891662012233,['eraser-circle']=102446186065177,['eraser-square']=
137934453495044,['euro']=113440281886093,['exit']=72009230196343,['explicit']=
134015297159246,['export']=93612238113575,['expressionless-circle']=
83604478908797,['expressionless-square']=129613755858803,['eye']=111781708911036
,['eye-closed']=73923823679473,['eye-scan']=93312767093758,['face-scan-circle']=
129962308796632,['face-scan-square']=90370720213514,['facemask-circle']=
88290637999492,['facemask-square']=91607748646701,['feed']=115328363898492,[
'ferris-wheel']=80185923710401,['figma']=113267603186495,['figma-file']=
104470582924155,['file']=127490106584938,['file-check']=88089106708652,[
'file-corrupted']=123534996424728,['file-download']=109242258818317,[
'file-favourite']=80480987060536,['file-left']=133611650958098,['file-remove']=
136407677886932,['file-right']=117014199354662,['file-send']=100302492978636,[
'file-smile']=139433602139427,['file-text']=111955813704021,['filter']=
90067333688266,['filters']=84580916979375,['fire']=135755743158580,[
'fire-minimalistic']=112705408693172,['fire-square']=106629004615972,['flag']=
123419720240176,['flag-2']=111210658608794,['flame']=136450031647569,[
'flash-drive']=105112605057571,['flashlight']=124411885818533,['flashlight-on']=
126279289380499,['flip-horizontal']=110549717309186,['flip-vertical']=
129757687665927,['floor-lamp']=138946048809299,['floor-lamp-minimalistic']=
97386447919314,['fog']=86201042014464,['folder']=101207683756324,['folder-2']=
76034753816998,['folder-check']=121195076002492,['folder-cloud']=88660179875500,
['folder-error']=113312905787220,['folder-favourite-bookmark']=121951599078771,[
'folder-favourite-star']=87073155100200,['folder-open']=138167990621065,[
'folder-path-connect']=73283047662646,['folder-security']=76174163239107,[
'folder-with-files']=96350217047674,['football']=122607807171647,['forbidden']=
123202692288656,['forbidden-circle']=98190469889558,['forward']=121582467778484,
['forward-2']=92800823328814,['fridge']=78081212880695,['fuel']=95119712808078,[
'full-screen']=70733270904537,['full-screen-circle']=118761949672681,[
'full-screen-square']=120424617549682,['gallery']=107115824920780,['gallery-add'
]=119169548043101,['gallery-check']=95370122750252,['gallery-circle']=
98291804743618,['gallery-download']=74039459113922,['gallery-edit']=
131296755160748,['gallery-favourite']=80866000511556,['gallery-minimalistic']=
111677697640953,['gallery-remove']=121381327348902,['gallery-round']=
93521842678616,['gallery-send']=83644025804536,['gallery-wide']=111039930907780,
['gameboy']=112631387612132,['gamepad']=132228762224767,['gamepad-charge']=
82289031849218,['gamepad-minimalistic']=107922917997811,['gamepad-no-charge']=
100739827942723,['gamepad-old']=110201467031230,['garage']=106033136962094,[
'gas-station']=86311898446535,['ghost']=98147715916360,['ghost-smile']=
103118938315507,['gift']=134626236985841,['glasses']=77968854251869,['global']=
139419629866911,['globus']=87049589839481,['golf']=98322149458809,['gps']=
96477729873448,['graph']=97211064230719,['graph-down']=85357519277962,[
'graph-down-new']=126282065399172,['graph-new']=85786914748675,['graph-new-up']=
93250207296556,['graph-up']=133545790231682,['hamburger-menu']=79473109809580,[
'hand-heart']=130716318062267,['hand-money']=75640944758219,['hand-pills']=
127850574287384,['hand-shake']=108947571035632,['hand-stars']=77864301483163,[
'hanger']=121629637423486,['hanger-2']=127952312462409,['hashtag']=
107142548785326,['hashtag-chat']=80437575983407,['hashtag-circle']=
77446982417735,['hashtag-square']=103351344998670,['headphones-round']=
128280382670309,['headphones-round-sound']=100766574538440,['headphones-square']
=78135331232845,['headphones-square-sound']=124380127559063,['health']=
139029626825956,['heart']=119572392737590,['heart-angle']=134542484641582,[
'heart-broken']=117389905375092,['heart-lock']=74134825079392,['heart-pulse']=
95037082144393,['heart-pulse-2']=86416022263141,['heart-shine']=73693161433363,[
'heart-unlock']=109726686524974,['hearts']=93869078516452,['help']=
74549672827568,['high-definition']=80838009750190,['high-quality']=
137403273802579,['hiking']=82931610763804,['hiking-minimalistic']=
136348686208306,['hiking-round']=98000809158973,['history']=97353417492391,[
'history-2']=119156111252056,['history-3']=102058567061813,['home']=
110908061043900,['home-2']=117906088481880,['home-add']=117995122988574,[
'home-add-angle']=120045039719252,['home-angle']=138932921214460,['home-angle-2'
]=83857918016474,['home-smile']=87523684474921,['home-smile-angle']=
100747143305761,['home-wi-fi']=125675624043794,['home-wi-fi-angle']=
132404171071568,['hospital']=119261943878093,['hourglass']=97468116462119,[
'hourglass-line']=94077487038206,['i-phone']=115103457868482,['import']=
94955686787672,['inbox']=136217097965233,['inbox-archive']=100304044661400,[
'inbox-in']=130124951048332,['inbox-line']=74954329094178,['inbox-out']=
134100020984116,['inbox-unread']=75549440169195,['incognito']=80542702049291,[
'incoming-call']=98467559903476,['incoming-call-rounded']=116052533683978,[
'infinity']=104195103286648,['info-circle']=94529541997278,['info-square']=
104423298306796,['jar-of-pills']=103950091083076,['jar-of-pills-2']=
132651755818837,['key']=93569468678423,['key-minimalistic']=133574953255757,[
'key-minimalistic-2']=79096393495440,['key-minimalistic-square']=116865300484698
,['key-minimalistic-square-2']=96035142453800,['key-minimalistic-square-3']=
137963276929413,['key-square']=140300865739042,['key-square-2']=90069226177359,[
'keyboard']=140087399831489,['kick-scooter']=77337311538937,['ladle']=
76281632345463,['lamp']=79510744607245,['laptop']=71947327712110,['laptop-2']=
83146254210014,['laptop-3']=108781585715333,['laptop-minimalistic']=
74400581500001,['layers']=76370553090551,['layers-minimalistic']=112408985270064
,['leaf']=121283616337277,['letter']=97695461226778,['letter-opened']=
100795825334889,['letter-unread']=122970067011164,['library']=129335697992755,[
'lightbulb']=115038153659889,['lightbulb-bolt']=110944734577584,[
'lightbulb-minimalistic']=116487573327398,['lightning']=89278362360178,['like']=
92774442572396,['link']=71038734318580,['link-broken']=120022598023679,[
'link-broken-minimalistic']=108137121204402,['link-circle']=75912193654076,[
'link-minimalistic']=90998085196725,['link-minimalistic-2']=73371793592887,[
'link-round']=91263312996877,['link-round-angle']=100204314620474,['link-square'
]=138720591143154,['list']=76813409396375,['list-1']=77829614179818,[
'list-arrow-down']=100524319044924,['list-arrow-down-minimalistic']=
75040706926636,['list-arrow-up']=116073837413607,['list-arrow-up-minimalistic']=
81415474234835,['list-check']=89754806507060,['list-check-minimalistic']=
81557739889362,['list-cross']=109760310655770,['list-cross-minimalistic']=
87719958292663,['list-down']=100158705699286,['list-down-minimalistic']=
120189029652039,['list-heart']=106712373076387,['list-heart-minimalistic']=
104682553146049,['list-up']=113299345449674,['list-up-minimalistic']=
126556397787371,['lock']=108603238886118,['lock-keyhole']=80719048568900,[
'lock-keyhole-minimalistic']=117620446004855,[
'lock-keyhole-minimalistic-unlocked']=125741681069531,['lock-keyhole-unlocked']=
98188856634746,['lock-password']=135892778188250,['lock-password-unlocked']=
90454261228974,['lock-unlocked']=128063016456306,['login']=134954817189826,[
'login-2']=114971775323276,['login-3']=128849528093452,['logout']=98485068966564
,['logout-2']=95446907300146,['logout-3']=75780860392006,['magic-stick']=
83508311570631,['magic-stick-2']=103228889397546,['magic-stick-3']=
134561599449883,['magnet']=93385488760013,['magnet-wave']=98654860608359,[
'magnifer']=75236956926329,['magnifer-bug']=92109851157710,['magnifer-zoom-in']=
138187229750019,['magnifer-zoom-out']=135785169154622,['mailbox']=
102244768845572,['map']=100008589043828,['map-arrow-down']=108308968641524,[
'map-arrow-left']=97095461629716,['map-arrow-right']=111905824347529,[
'map-arrow-square']=136453679510712,['map-arrow-up']=109164912555932,[
'map-point']=81558365588892,['map-point-add']=86384257635691,[
'map-point-favourite']=115064342223946,['map-point-hospital']=86957509039152,[
'map-point-remove']=122276536498683,['map-point-rotate']=80973262724422,[
'map-point-school']=83753429411685,['map-point-search']=102729325455587,[
'map-point-wave']=103536088661531,['mask-happly']=115192008441532,['mask-sad']=
91365282297784,['masks']=117744266908530,['maximize']=135835129702009,[
'maximize-square']=92640655416045,['maximize-square-2']=85020484543438,[
'maximize-square-3']=138780470772627,['maximize-square-minimalistic']=
124192972540754,['medal-ribbon']=86474998278598,['medal-ribbon-star']=
109915712384772,['medal-ribbons-star']=137542540514252,['medal-star']=
108976549774193,['medal-star-circle']=116597217497183,['medal-star-square']=
133081107505472,['medical-kit']=109186510977291,['meditation']=134230884627081,[
'meditation-round']=105326614317912,['men']=106732474047966,['mention-circle']=
86724094837749,['mention-square']=88481159399833,['menu-dots']=97684069841204,[
'menu-dots-circle']=113604546484539,['menu-dots-square']=96922289474814,[
'microphone']=120020891918857,['microphone-2']=97280071273102,['microphone-3']=
123518127491892,['microphone-large']=108318098992763,['minimalistic-magnifer']=
70552784281680,['minimalistic-magnifer-bug']=133212897697513,[
'minimalistic-magnifer-zoom-in']=98656569915187,[
'minimalistic-magnifer-zoom-out']=79686409038067,['minimize']=75810158557243,[
'minimize-square']=76780451864744,['minimize-square-2']=139234548639631,[
'minimize-square-3']=86375936396998,['minimize-square-minimalistic']=
103626408777602,['minus-circle']=82100189633812,['minus-square']=85537484816183,
['mirror']=100317746534844,['mirror-left']=80263734562480,['mirror-right']=
125472555950877,['money-bag']=117785512690361,['monitor']=79734853554211,[
'monitor-camera']=75135248525910,['monitor-smartphone']=103539301635769,['moon']
=125873389519219,['moon-fog']=139908343281931,['moon-sleep']=128595102526074,[
'moon-stars']=108940075201970,['mouse']=139149894104767,['mouse-circle']=
106321142478582,['mouse-minimalistic']=112630969536923,['move-to-folder']=
129044278330331,['multiple-forward-left']=108975997937971,[
'multiple-forward-right']=107355812789520,['music-library']=77994101443980,[
'music-library-2']=99786822107991,['music-note']=123865998868867,['music-note-2'
]=97445775514198,['music-note-3']=74359292721462,['music-note-4']=
120478072705612,['music-note-slider']=125710688927378,['music-note-slider-2']=
104076906079561,['music-notes']=125493609770475,['muted']=138304661448495,[
'notebook']=139800895080670,['notebook-bookmark']=96124487254608,[
'notebook-minimalistic']=101747599077050,['notebook-square']=130858891028085,[
'notes']=116168334467542,['notes-minimalistic']=125360237781928,[
'notification-lines-remove']=130830973153831,['notification-remove']=
76779394800746,['notification-unread']=139787932372978,[
'notification-unread-lines']=101280095447381,['object-scan']=108611247538232,[
'outgoing-call']=114725326453202,['outgoing-call-rounded']=139638671952745,[
'oven-mitts']=116254499847389,['oven-mitts-minimalistic']=101629105567959,[
'paint-roller']=115221684337796,['palette']=71228091130971,['palette-round']=
135940003948216,['pallete-2']=82581293307519,['panorama']=129062576724229,[
'paper-bin']=85298397038910,['paperclip']=110226788873111,['paperclip-2']=
112816150233126,['paperclip-rounded']=96771707508519,['paperclip-rounded-2']=
95549443574022,['paragraph-spacing']=90239604766759,['passport']=116022167541465
,['passport-minimalistic']=76249147601706,['password']=108958062185057,[
'password-minimalistic']=114975848070011,['password-minimalistic-input']=
135265823252301,['pause']=108033303358492,['pause-circle']=90119286381163,['paw'
]=86004936341358,['pen']=139224507144471,['pen-2']=79579669580124,[
'pen-new-round']=139995667511791,['pen-new-square']=107532273565583,[
'people-nearby']=93753043517782,['perfume']=89665077488198,['phone']=
106627490150757,['phone-calling']=118497451278440,['phone-calling-rounded']=
126846816166614,['phone-rounded']=138803353466491,['pie-chart']=116180090774230,
['pie-chart-2']=119052305114673,['pie-chart-3']=75874792169097,['pill']=
100372428511072,['pills']=78028338389518,['pills-2']=118250365651780,['pills-3']
=72133979211424,['pin']=81516746276415,['pin-circle']=99319242174185,['pin-list'
]=127244881692694,['pip']=74918487335973,['pip-2']=95652338235167,['pipette']=
133581508341712,['plaaylist-minimalistic']=101958669557540,['plain']=
104436508665228,['plain-2']=135764877723540,['plain-3']=110444508953815,[
'planet']=110926118391987,['planet-2']=97685269906778,['planet-3']=
114584522323443,['planet-4']=126853183441271,['plate']=131126152251497,['play']=
94251290360710,['play-circle']=126174487049903,['play-stream']=71973979059922,[
'playback-speed']=75658442425524,['playlist']=132670286884790,['playlist-2']=
101883736307128,['playlist-minimalistic-2']=134106383085691,[
'playlist-minimalistic-3']=92247757217964,['plug-circle']=138180123830220,[
'plus-minus']=104295007565085,['podcast']=73356483225559,['point-on-map']=
71186034817192,['point-on-map-perspective']=110360883026668,[
'posts-carousel-horizontal']=116942123304048,['posts-carousel-vertical']=
89038238613961,['power']=116822581093037,['presentation-graph']=116656393464390,
['printer']=99889574534641,['printer-2']=130778080492218,['printer-minimalistic'
]=81275571341906,['programming']=71466343335951,['projector']=139210998852889,[
'pulse']=89560893175804,['pulse-2']=139106093250291,['qr-code']=112581659796854,
['question-circle']=138795625519584,['question-square']=99401628420524,[
'quit-full-screen']=82801632530658,['quit-full-screen-circle']=105519683035641,[
'quit-full-screen-square']=98332680832491,['quit-pip']=94122003472728,['radar']=
131644584628608,['radar-2']=138254839603600,['radial-blur']=132056974448622,[
'radio']=107842194557490,['radio-minimalistic']=89235653631008,['ranking']=
90937800962544,['recive-square']=93342429514158,['recive-twice-square']=
71439700201365,['record']=122485335253573,['record-circle']=132489804811974,[
'record-minimalistic']=132191068013875,['record-square']=78471724812306,['reel']
=101242709875910,['reel-2']=116423317770454,['refresh']=129337684713976,[
'refresh-circle']=134055602900175,['refresh-square']=129609205924612,[
'remote-controller']=92924216388680,['remote-controller-2']=72902150820770,[
'remote-controller-minimalistic']=98183943186563,['remove-folder']=
126400094160951,['reorder']=119032799762106,['repeat']=114726563873786,[
'repeat-one']=131686730007022,['repeat-one-minimalistic']=70753920636219,[
'reply']=139095646898247,['reply-2']=84607993329604,['restart']=95329801274970,[
'restart-circle']=97403133577547,['restart-square']=112122170803458,['revote']=
95931868367643,['rewind-10-seconds-back']=91537197722698,[
'rewind-10-seconds-forward']=123931123372126,['rewind-15-seconds-back']=
106117742518223,['rewind-15-seconds-forward']=99986591566860,[
'rewind-5-seconds-back']=108620182757782,['rewind-5-seconds-forward']=
132426312965837,['rewind-back']=129702345365553,['rewind-back-circle']=
77065883077930,['rewind-forward']=135347483133717,['rewind-forward-circle']=
137261432367607,['rocket']=125278137665075,['rocket-2']=107854914989794,[
'rolling-pin']=134785489472314,['round-alt-arrow-down']=137709206640172,[
'round-alt-arrow-left']=122911768123230,['round-alt-arrow-right']=
108253689573115,['round-alt-arrow-up']=119474588732740,['round-arrow-down']=
78105440389214,['round-arrow-left']=121202406353568,['round-arrow-left-down']=
81318168220860,['round-arrow-left-up']=135262425341860,['round-arrow-right']=
99296997150346,['round-arrow-right-down']=107383245038267,[
'round-arrow-right-up']=79681232750390,['round-arrow-up']=95823152130765,[
'round-double-alt-arrow-down']=120876685531946,['round-double-alt-arrow-left']=
111304144085829,['round-double-alt-arrow-right']=108681982512244,[
'round-double-alt-arrow-up']=91877668365698,['round-graph']=140254424979639,[
'round-sort-horizontal']=115178957119835,['round-sort-vertical']=87456118802330,
['round-transfer-diagonal']=116195469047434,['round-transfer-horizontal']=
76835017137335,['round-transfer-vertical']=119101653132288,['rounded-magnifer']=
95134607537185,['rounded-magnifer-bug']=94433058810000,[
'rounded-magnifer-zoom-in']=78773101290333,['rounded-magnifer-zoom-out']=
126519861479187,['route']=102943663013157,['routing']=78564691541876,[
'routing-2']=88159920359144,['routing-3']=75106024435859,['ruble']=
122151992699406,['rugby']=95222072436079,['ruler']=119326382853863,[
'ruler-angular']=125826556933725,['ruler-cross-pen']=101501765759599,[
'ruler-pen']=96737749067188,['running']=89759466188696,['running-2']=
97162339719605,['running-round']=136675007343963,['sad-circle']=102956731011118,
['sad-square']=75434403130641,['safe-2']=96825790870143,['safe-circle']=
107515643413820,['safe-square']=131949849590358,['sale']=118095540025910,[
'sale-square']=115470965191356,['satellite']=127253775531051,['scale']=
103296279194255,['scanner']=101998785706398,['scanner-2']=110536896960142,[
'scissors']=77824226693775,['scissors-square']=133632397509548,['scooter']=
82847832551713,['screen-share']=123147801930077,['screencast']=88060745191178,[
'screencast-2']=89656277813513,['sd-card']=121054027274584,['send-square']=
105521306587375,['send-twice-square']=135998365078660,['server']=131822242188074
,['server-2']=89893828269204,['server-minimalistic']=116549199151156,[
'server-path']=132732889918226,['server-square']=89922620765551,[
'server-square-cloud']=81135490817323,['server-square-update']=77400928240062,[
'settings']=140704441124047,['settings-minimalistic']=72727338348045,['share']=
98205282026993,['share-circle']=131699812289817,['shield']=105619007041452,[
'shield-check']=138813829483190,['shield-cross']=73501670141022,[
'shield-keyhole']=126056849024542,['shield-keyhole-minimalistic']=
111757452305565,['shield-minimalistic']=80494162837154,['shield-minus']=
134582499220374,['shield-network']=86532242996762,['shield-plus']=
136784563828964,['shield-star']=70874760305945,['shield-up']=109643147383429,[
'shield-user']=96854505285284,['shield-warning']=130226573962640,[
'shock-absorber']=89555676609379,['shop']=87353934937155,['shop-2']=
92246295435163,['shop-minimalistic']=105022135170615,['shuffle']=98537688124004,
['sidebar-code']=93412654258157,['sidebar-minimalistic']=92696737298939,[
'siderbar']=110749999898163,['signpost']=76178537874048,['signpost-2']=
130799320325797,['sim-card']=131899681810623,['sim-card-minimalistic']=
77378751390989,['sim-cards']=73788905695106,['siren']=80264845612183,[
'siren-rounded']=95350629533255,['skateboard']=84369674199881,['skateboarding']=
113729282739078,['skateboarding-round']=137792094624164,['skip-next']=
127467521419903,['skip-previous']=92672240459844,['skirt']=138888640200277,[
'slash-circle']=95836958362585,['slash-square']=110781777562548,['sledgehammer']
=118270658402814,['sleeping']=74887623287217,['sleeping-circle']=87910637152184,
['sleeping-square']=79169508324127,['slider-horizontal']=96877645370923,[
'slider-minimalistic-horizontal']=99190245549027,['slider-vertical']=
89315075407870,['slider-vertical-minimalistic']=88646391149048,['smart-home']=
79549201427230,['smart-home-angle']=94982212036559,['smart-speaker']=
93700022659723,['smart-speaker-2']=131985660895037,['smart-speaker-minimalistic'
]=115485996029646,['smart-vacuum-cleaner']=96756851737943,[
'smart-vacuum-cleaner-2']=85352847346941,['smartphone']=79789057878832,[
'smartphone-2']=122351971813170,['smartphone-rotate-2']=134941817910385,[
'smartphone-rotate-angle']=108124568463208,['smartphone-rotate-orientation']=
77000218150348,['smartphone-update']=96587695327433,['smartphone-vibration']=
132347852148602,['smile-circle']=138760841166710,['smile-square']=
137865571533918,['snowflake']=108962750323036,['socket']=91359635834056,['sofa']
=140144996639548,['sofa-2']=93906279739092,['sofa-3']=132196771477458,['sort']=
98667743186414,['sort-by-alphabet']=70732409950355,['sort-by-time']=
124205311042948,['sort-from-bottom-to-top']=89111820626938,[
'sort-from-top-to-bottom']=95032665651269,['sort-horizontal']=82355230930420,[
'sort-vertical']=121618478093853,['soundwave']=128596073923474,[
'soundwave-circle']=90732151124063,['soundwave-square']=72531353857477,[
'speaker']=108547564852538,['speaker-minimalistic']=80844466691420,[
'special-effects']=119734418129837,['spedometer-low']=102193215915372,[
'spedometer-max']=97368814260855,['spedometer-middle']=71225968751991,[
'square-academic-cap']=117787825404757,['square-academic-cap-2']=126384010038084
,['square-alt-arrow-down']=134099958781743,['square-alt-arrow-left']=
79075944494583,['square-alt-arrow-right']=100823625938458,['square-alt-arrow-up'
]=79685754994513,['square-arrow-down']=97545824153313,['square-arrow-left']=
129305494230971,['square-arrow-left-down']=119608491906826,[
'square-arrow-left-up']=85225135130488,['square-arrow-right']=131581955873172,[
'square-arrow-right-down']=118212170630211,['square-arrow-right-up']=
108552252615996,['square-arrow-up']=72749816689089,['square-bottom-down']=
114577436375936,['square-bottom-up']=138137323744590,[
'square-double-alt-arrow-down']=138017005754487,['square-double-alt-arrow-left']
=94290333683906,['square-double-alt-arrow-right']=132384633231565,[
'square-double-alt-arrow-up']=138517487956716,['square-forward']=122359618460085
,['square-share-line']=111128598280002,['square-sort-horizontal']=78126092609858
,['square-sort-vertical']=138019096822861,['square-top-down']=105540501021737,[
'square-top-up']=130144243002536,['square-transfer-horizontal']=83149737584008,[
'square-transfer-vertical']=123809574427198,['ssd-round']=90202092250236,[
'ssd-square']=110794977715079,['star']=98157183283283,['star-angle']=
138967642353360,['star-circle']=134963294985291,['star-fall']=88380485367823,[
'star-fall-2']=99860835278060,['star-fall-minimalistic']=106537137820080,[
'star-fall-minimalistic-2']=114012243611304,['star-rainbow']=86471671471759,[
'star-ring']=110424632806655,['star-rings']=104928351789424,['star-shine']=
114100614749526,['stars']=117722835180948,['stars-line']=87693855497250,[
'stars-minimalistic']=73767297526258,['station']=93623212489133,[
'station-minimalistic']=128716477787126,['stethoscope']=76623615784640,[
'sticker-circle']=102702766597629,['sticker-smile-circle']=85204383335233,[
'sticker-smile-circle-2']=137842219783384,['sticker-smile-square']=
106650929786110,['sticker-square']=91592586854875,['stop']=81987034482699,[
'stop-circle']=108380991475628,['stopwatch']=118896472143182,['stopwatch-pause']
=87099558672298,['stopwatch-play']=97438410366861,['stream']=137050375293417,[
'streets']=73004429749236,['streets-map-point']=103312515400216,[
'streets-navigation']=106717116500472,['stretching']=93675711491420,[
'stretching-round']=78522785077975,['structure']=82592687617983,['subtitles']=
136386805103196,['suitcase']=104946983294612,['suitcase-lines']=124611109739574,
['suitcase-tag']=112174358534580,['sun']=117590500180033,['sun-2']=
91474658549548,['sun-fog']=87435280817694,['sunrise']=75484973989494,['sunset']=
71097081264800,['suspension']=84119842548959,['suspension-bolt']=70970017461409,
['suspension-cross']=116676205332516,['swimming']=86794234647329,['syringe']=
74944836618938,['t-shirt']=89083139578707,['tablet']=72450303882114,['tag']=
106092784438331,['tag-horizontal']=137208495811844,['tag-price']=139330352014349
,['target']=71083101429210,['tea-cup']=81269020320152,['telescope']=
112666909064777,['temperature']=112175927992686,['tennis']=100807633923595,[
'tennis-2']=132685927629405,['test-tube']=111440711942875,[
'test-tube-minimalistic']=70855878185407,['text']=134628365459549,['text-bold']=
139882292900892,['text-bold-circle']=79290285574949,['text-bold-square']=
79006047376007,['text-circle']=132900019115915,['text-cross']=75438637380021,[
'text-cross-circle']=75541869223727,['text-cross-square']=82573645024003,[
'text-field']=98911237764660,['text-field-focus']=124774821883834,['text-italic'
]=99711208999506,['text-italic-circle']=105822776188761,['text-italic-square']=
106379754206823,['text-selection']=137557112875450,['text-square']=
135137239265675,['text-square-2']=136952444331070,['text-underline']=
101539591432747,['text-underline-circle']=112775181426135,[
'text-underline-cross']=71846695076450,['thermometer']=118971215433255,[
'three-squares']=110449044402886,['ticker-star']=121997263518617,['ticket']=
128755105546658,['ticket-sale']=117816353388914,['to-pip']=122574042264102,[
'tornado']=135923045449439,['tornado-small']=99669240821087,['traffic']=
123402546058727,['traffic-economy']=77900625152722,['tram']=116303568356677,[
'transfer-horizontal']=102105242487044,['transfer-vertical']=120766061002835,[
'translation']=122179759560828,['translation-2']=78889094751104,['transmission']
=126322047226804,['transmission-circle']=109248720581180,['transmission-square']
=101980323704791,['trash-bin-2']=124950181079965,['trash-bin-minimalistic']=
70865927459256,['trash-bin-minimalistic-2']=137172537537016,['trash-bin-trash']=
76323366897784,['treadmill']=129648402750616,['treadmill-round']=94884397103011,
['trellis']=137017874479837,['tuning']=106185406308820,['tuning-2']=
82333306930313,['tuning-3']=75757152277151,['tuning-4']=135916377999987,[
'tuning-square']=138100521939866,['tuning-square-2']=93994359568129,['turntable'
]=89367537824987,['turntable-minimalistic']=115978033833640,[
'turntable-music-note']=73335854917174,['tv']=81328242137501,['ufo']=
74519584196021,['ufo-2']=108307092452400,['ufo-3']=140510327756200,['umbrella']=
91254497875369,['undo-left']=101535300462497,['undo-left-round']=93326283820468,
['undo-left-round-square']=121916928029783,['undo-left-square']=72621879478446,[
'undo-right']=130557105074315,['undo-right-round']=130521277062566,[
'undo-right-round-square']=88065835584182,['undo-right-square']=80269849465980,[
'unread']=110416886370701,['upload']=82181626860091,['upload-minimalistic']=
107646669869079,['upload-square']=119275582449778,['upload-track']=
123038174128910,['upload-track-2']=96082765006306,['upload-twice-square']=
81193322760208,['usb']=106112000914766,['usb-circle']=94849067026483,[
'usb-square']=86965694736385,['user']=125161627986415,['user-block']=
114355063515473,['user-block-rounded']=104794369369754,['user-check']=
93659367975786,['user-check-rounded']=119674379642330,['user-circle']=
86288701652149,['user-cross']=132471506730881,['user-cross-rounded']=
125371741244205,['user-hand-up']=77880631966096,['user-hands']=127075603959605,[
'user-heart']=138862194107927,['user-heart-rounded']=71668079240282,['user-id']=
98773947934088,['user-minus']=72399636270324,['user-minus-rounded']=
135268670474984,['user-plus']=94753090743326,['user-plus-rounded']=
96300834054336,['user-rounded']=94273456177524,['user-speak']=110385470358124,[
'user-speak-rounded']=107485687385793,['users-group-rounded']=126742251911152,[
'users-group-two-rounded']=127970090727557,['verified-check']=119783053916823,[
'video-frame']=73128756981234,['video-frame-2']=82337478304413,[
'video-frame-cut']=123929691789983,['video-frame-cut-2']=119780853690159,[
'video-frame-play-horizontal']=122648668294196,['video-frame-play-vertical']=
85138471863840,['video-frame-replace']=138891570992053,['video-library']=
79214944944624,['videocamera']=95818845453265,['videocamera-add']=89427892975850
,['videocamera-record']=88046262841338,['vinyl']=110848145855714,['vinyl-record'
]=88847483181728,['virus']=79496716882276,['volleyball']=130485373566106,[
'volleyball-2']=88021776097939,['volume']=102626706004883,['volume-cross']=
109348232574607,['volume-knob']=97370286327773,['volume-loud']=133324163109944,[
'volume-small']=116725011263323,['wad-of-money']=105559865289319,['walking']=
133190246297220,['walking-round']=105069478354242,['wallet']=115541316499580,[
'wallet-2']=103092721640216,['wallet-money']=91080748679499,['wallpaper']=
107668850940426,['washing-machine']=115544099026586,[
'washing-machine-minimalistic']=90822848541801,['watch-round']=131590076446195,[
'watch-square']=126156237544815,['watch-square-minimalistic']=79171579158341,[
'watch-square-minimalistic-charge']=71144410008870,['water']=73765249018538,[
'water-sun']=137004236197451,['waterdrop']=120397138191166,['waterdrops']=
111309368016355,['weigher']=86709006687497,['wheel']=82520002278171,[
'wheel-angle']=79409056509386,['whisk']=127929087299925,['wi-fi-router']=
71817970702020,['wi-fi-router-minimalistic']=140564253402469,[
'wi-fi-router-round']=115295340179143,['widget']=124133264580702,['widget-2']=
89625301483410,['widget-3']=82229378234667,['widget-4']=88900781944791,[
'widget-5']=136051733282290,['widget-6']=118797841936173,['widget-add']=
91034149066074,['win-rar']=72764770869567,['wind']=126825186378963,[
'window-frame']=87953247223226,['wineglass']=100205828816519,[
'wineglass-triangle']=128665733855452,['wireless-charge']=75123495054514,[
'women']=88280644952325,['xxx']=123101921891699,['zip-file']=99550940262109}}end
function __DARKLUA_BUNDLE_MODULES.c()local v=__DARKLUA_BUNDLE_MODULES.cache.c if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.c=v end return v.c
end end do local function __modImpl()return function(Library)local Assets={
Folder='CourageUI/assets/',BaseUrl=
[[https://raw.githubusercontent.com/felipeewashere/courage-library/main/v2/assets/]]
,IconUrl=
[[https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua]]
,Cache={}}Library.Assets=Assets local canFile=type(getcustomasset)=='function'
and type(writefile)=='function'and type(isfile)=='function'and type(readfile)==
'function'local function ensureFolder(path)if type(isfolder)~='function'or type(
makefolder)~='function'then return end local built=''local parts=string.split(
path,'/')parts[#parts]=nil for _,part in ipairs(parts)do built=built..part if
not isfolder(built)then makefolder(built)end built=built..'/'end end function
Assets.Get(path)local cached=Assets.Cache[path]if cached~=nil then return cached
or nil end local result=false if canFile then local ok,asset=pcall(function()
local file=Assets.Folder..path if not isfile(file)then local bytes=game:HttpGet(
Assets.BaseUrl..path)if type(bytes)~='string'or string.sub(bytes,2,4)~='PNG'then
error('not a png')end ensureFolder(file)writefile(file,bytes)end return
getcustomasset(file)end)if ok and asset then result=asset end end Assets.Cache[
path]=result return result or nil end function Assets.Apply(image,path,onDone)
task.spawn(function()local asset=Assets.Get(path)if asset then pcall(function()
image.Image=asset end)end if onDone then onDone(asset~=nil)end end)end local
Filled=__DARKLUA_BUNDLE_MODULES.c()Assets.Filled=Filled local function filledId(
name)if Library.FilledIcons==false then return nil end return Filled.Icons[
Filled.Map[name]or name]end local iconModule local waiting={}local function 
applyLucide(image,name)local ok,icon=pcall(iconModule.GetAsset,name)if not ok or
type(icon)~='table'then return false end pcall(function()image.Image=icon.Url
image.ImageRectOffset=icon.ImageRectOffset image.ImageRectSize=icon.
ImageRectSize end)return true end function Library:SetIconModule(module)
iconModule=module for _,entry in ipairs(waiting)do applyLucide(entry[1],entry[2]
)end table.clear(waiting)end function Library:GetIcon(name)local id=filledId(
name)if id then return{Url='rbxassetid://'..id,ImageRectOffset=Vector2.zero,
ImageRectSize=Vector2.zero}end if not iconModule then return nil end local ok,
icon=pcall(iconModule.GetAsset,name)return ok and icon or nil end function
Assets.LoadIcons()task.spawn(function()local ok,module=pcall(function()local
file='CourageUI/lucide.lua'local source if canFile and isfile(file)then source=
readfile(file)end if not source or#source<1000 then source=game:HttpGet(Assets.
IconUrl)if canFile then ensureFolder(file)pcall(writefile,file,source)end end
return loadstring(source)()end)if ok and type(module)=='table'and type(module.
GetAsset)=='function'then Library:SetIconModule(module)end end)end function
Assets.SetIcon(image,icon)if icon==nil or icon==''then return end if type(icon)
=='number'or(type(icon)=='string'and tonumber(icon))then image.Image=
'rbxassetid://'..tostring(icon)elseif type(icon)~='string'then return elseif
string.sub(icon,1,5)=='file:'then Assets.Apply(image,string.sub(icon,6))elseif
string.find(icon,'://',1,true)then image.Image=icon elseif filledId(icon)then
image.Image='rbxassetid://'..filledId(icon)image.ImageRectOffset,image.
ImageRectSize=Vector2.zero,Vector2.zero elseif iconModule then applyLucide(image
,icon)else table.insert(waiting,{image,icon})end end function Library:
GetCustomIcon(icon)return icon end end end function __DARKLUA_BUNDLE_MODULES.d()
local v=__DARKLUA_BUNDLE_MODULES.cache.d if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end do local function 
__modImpl()return function(Library)local Util=Library.Util local New=Util.New
local Services=Util.Services local Assets=Library.Assets local function scaled(
frame)local scale=New('UIScale',{Scale=Library.DPIScale,Parent=frame})table.
insert(Library.ScaleObjects,scale)return scale end local function logoInto(
parent,size)local image=New('ImageLabel',{Size=UDim2.fromOffset(size,size),
BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,Parent=parent})local
letter=New('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=
'C',FontFace='FontBold',TextSize=size*0.8,TextColor3='Accent',Parent=image})
Assets.Apply(image,'logo.png',function(found)if found then letter.Visible=false
end end)return image end function Library:ClosePopup()local popup=self.Popup if
not popup then return end self.Popup=nil popup.Close()end function Library:
_startPopupWatch()self:GiveSignal(Services.UserInputService.InputBegan:Connect(
function(input)local popup=self.Popup if not popup or not Util.IsClick(input)
then return end local point=Util.InputPos(input)for _,frame in ipairs(popup.
Frames)do if frame.Parent and Util.Inside(frame,point)then return end end self:
ClosePopup()end))end local tooltip,tooltipLabel,tooltipOwner function Library:
HideTooltip()tooltipOwner=nil if tooltip then tooltip.Visible=false end end
function Library:AddTooltip(object,text)if type(text)=='string'then if text==''
then return end text=self.Translate(text)elseif type(text)~='function'then
return end if not tooltip then tooltip=New('Frame',{Name='Tooltip',Size=UDim2.
fromOffset(0,0),AutomaticSize=Enum.AutomaticSize.XY,BackgroundColor3='Main',
Visible=false,ZIndex=100,Parent=self.Overlay})scaled(tooltip)Util.Corner(tooltip
,7)Util.Stroke(tooltip,'Outline')Util.Pad(tooltip,9,6)tooltipLabel=New(
'TextLabel',{Size=UDim2.fromOffset(0,0),AutomaticSize=Enum.AutomaticSize.XY,
BackgroundTransparency=1,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,
ZIndex=101,Parent=tooltip})New('UISizeConstraint',{MaxSize=Vector2.new(260,400),
Parent=tooltipLabel})tooltipLabel.TextWrapped=true end self:GiveSignal(object.
MouseEnter:Connect(function()tooltipOwner=object task.delay(0.45,function()if
tooltipOwner~=object or not self.Toggled then return end tooltipLabel.Text=type(
text)=='function'and text()or text local mouse=Services.UserInputService:
GetMouseLocation()tooltip.Position=UDim2.fromOffset(mouse.X+14,mouse.Y+16)
tooltip.Visible=true end)end))self:GiveSignal(object.MouseLeave:Connect(function
()if tooltipOwner==object then self:HideTooltip()end end))end local notifyHolder
,notifyLayout function Library:SetNotifySide(side)self.NotifySide=side=='Left'
and'Left'or'Right'if not notifyHolder then return end local left=self.NotifySide
=='Left'notifyHolder.AnchorPoint=Vector2.new(left and 0 or 1,1)notifyHolder.
Position=UDim2.new(left and 0 or 1,left and 16 or-16,1,-16)notifyLayout.
HorizontalAlignment=left and Enum.HorizontalAlignment.Left or Enum.
HorizontalAlignment.Right end function Library:Notify(info,duration)if type(info
)~='table'then info={Description=tostring(info),Time=duration}end local title=
self.Translate(info.Title or self.NotifyTitle or'Courage Hub')local description=
self.Translate(info.Description or info.Text or'')local time=tonumber(info.Time
or info.Duration or duration)or 4 local kind=string.lower(tostring(info.Type or
info.Variant or'default'))local variants={info={Color3.fromRGB(92,170,255),
'info-circle'},success={Color3.fromRGB(72,210,140),'check-circle'},warning={
Color3.fromRGB(250,190,62),'danger-triangle'},danger={Color3.fromRGB(255,86,110)
,'shield-warning'}}variants.risky,variants.error,variants.warn=variants.danger,
variants.danger,variants.warning local variant=variants[kind]local tone=variant
and variant[1]or'Accent'local glyphName=info.Icon or(variant and variant[2])or
'bell'if not notifyHolder then notifyHolder=New('Frame',{Name='Notifications',
Size=UDim2.new(0,300,1,-32),BackgroundTransparency=1,Parent=self.Overlay})
notifyLayout=Util.List(notifyHolder,8,nil,nil,Enum.VerticalAlignment.Bottom)
scaled(notifyHolder)self:SetNotifySide(self.NotifySide)end self.NotifyCount=(
self.NotifyCount or 0)+1 local left=self.NotifySide=='Left'local slot=New(
'Frame',{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,LayoutOrder=self.NotifyCount,Parent=notifyHolder})local
card=New('Frame',{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
Position=UDim2.fromScale(left and-1.2 or 1.2,0),BackgroundColor3='Main',Parent=
slot})Util.Corner(card,12)Util.Stroke(card,tone,1,variant and 0.45 or 0.6)New(
'UISizeConstraint',{MinSize=Vector2.new(0,58),Parent=card})local chip=New(
'Frame',{Position=UDim2.fromOffset(12,12),Size=UDim2.fromOffset(30,30),
BackgroundColor3=tone,BackgroundTransparency=0.84,Parent=card})Util.Corner(chip,
9)local glyph=New('ImageLabel',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.
fromScale(0.5,0.5),Size=UDim2.fromOffset(17,17),BackgroundTransparency=1,
ImageColor3=tone,Parent=chip})Assets.SetIcon(glyph,glyphName)local text=New(
'Frame',{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,Parent=card})New('UIPadding',{PaddingLeft=UDim.new(0,52
),PaddingRight=UDim.new(0,32),PaddingTop=UDim.new(0,11),PaddingBottom=UDim.new(0
,17),Parent=text})Util.List(text,3)New('TextLabel',{Size=UDim2.new(1,0,0,18),
BackgroundTransparency=1,Text=title,FontFace='FontBold',TextSize=13,TextColor3=
variant and tone or'Text',TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=
Enum.TextTruncate.AtEnd,LayoutOrder=1,Parent=text})local body if description~=''
then body=New('TextLabel',{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.
AutomaticSize.Y,BackgroundTransparency=1,Text=description,TextColor3='Dim',
TextSize=12,TextWrapped=true,RichText=true,TextXAlignment=Enum.TextXAlignment.
Left,LayoutOrder=2,Parent=text})end local close=New('TextButton',{AnchorPoint=
Vector2.new(1,0),Position=UDim2.new(1,-8,0,8),Size=UDim2.fromOffset(22,22),
BackgroundTransparency=1,Parent=card})for _,rotation in ipairs({45,-45})do local
line=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,
0.5),Size=UDim2.fromOffset(9,1.5),Rotation=rotation,BackgroundColor3='Dim',
Parent=close})Util.Corner(line,1)end local rail=New('Frame',{AnchorPoint=Vector2
.new(0,1),Position=UDim2.new(0,12,1,-7),Size=UDim2.new(1,-24,0,3),
BackgroundColor3='Outline',BackgroundTransparency=0.4,Parent=card})Util.Corner(
rail,2)local bar=New('Frame',{Size=UDim2.fromScale(1,1),BackgroundColor3=tone,
Parent=rail})Util.Corner(bar,2)if info.SoundId then pcall(function()local sound=
New('Sound',{SoundId='rbxassetid://'..tostring(info.SoundId):gsub(
'rbxassetid://',''),Volume=0.6,Parent=Services.SoundService})sound:Play()task.
delay(5,function()sound:Destroy()end)end)end local notification={}local closed=
false function notification:Destroy()if closed then return end closed=true Util.
Tween(card,0.3,{Position=UDim2.fromScale(left and-1.2 or 1.2,0)},Enum.
EasingStyle.Quad,Enum.EasingDirection.In)task.delay(0.3,function()local height=
slot.AbsoluteSize.Y/Library.DPIScale slot.AutomaticSize=Enum.AutomaticSize.None
slot.Size=UDim2.new(1,0,0,height)card.Visible=false Util.Tween(slot,0.2,{Size=
UDim2.new(1,0,0,0)})task.delay(0.22,function()Util.Destroy(slot)end)end)end
function notification:ChangeTitle(newTitle)title=newTitle end function
notification:ChangeDescription(newText)if body then body.Text=Library.Translate(
newText)end end close.MouseButton1Click:Connect(function()notification:Destroy()
end)Util.Tween(card,0.35,{Position=UDim2.new()})if time>0 then Util.Tween(bar,
time,{Size=UDim2.fromScale(0,1)},Enum.EasingStyle.Linear)task.delay(time,
function()notification:Destroy()end)end return notification end local watermark,
watermarkName,watermarkStats local function buildWatermark()watermark=New(
'TextButton',{Name='Watermark',Position=UDim2.fromOffset(16,68),Size=UDim2.
fromOffset(0,34),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=
'Background',Visible=false,Parent=Library.Hud})scaled(watermark)Util.Corner(
watermark,11)Util.Stroke(watermark,'Accent',1.2,0.35)Util.Pad(watermark,10,0,14,
0)Util.List(watermark,9,Enum.FillDirection.Horizontal,nil,Enum.VerticalAlignment
.Center)logoInto(watermark,20).LayoutOrder=1 New('Frame',{Size=UDim2.fromOffset(
1,16),BackgroundColor3='Outline',LayoutOrder=2,Parent=watermark})watermarkName=
New('TextLabel',{Size=UDim2.fromOffset(0,34),AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,Text='Courage Hub',FontFace='FontBold',TextSize=13,
LayoutOrder=3,Parent=watermark})New('Frame',{Size=UDim2.fromOffset(1,16),
BackgroundColor3='Outline',LayoutOrder=4,Parent=watermark})watermarkStats=New(
'TextLabel',{Size=UDim2.fromOffset(0,34),AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,Text='',TextSize=13,TextColor3='Dim',RichText=true,
LayoutOrder=5,Parent=watermark})Util.Draggable(watermark)local frames,elapsed=0,
0 Library:GiveSignal(Services.RunService.RenderStepped:Connect(function(dt)
frames+=1 elapsed+=dt if elapsed<0.5 then return end local fps=math.floor(frames
/elapsed+0.5)frames,elapsed=0,0 if not watermark.Visible or not Library.
WatermarkStats then return end local ping=0 pcall(function()ping=math.floor(
Services.Stats.Network.ServerStatsItem['Data Ping']:GetValue()+0.5)end)local
accent=Library.Theme.Accent:ToHex()watermarkStats.Text=string.format(
[[FPS: <font color="#%s">%d</font>   Ping: <font color="#%s">%d ms</font>]],
accent,fps,accent,ping)end))end function Library:SetWatermark(text)if not
watermark then buildWatermark()end watermarkName.Text=self.Translate(text)end
function Library:SetWatermarkVisibility(visible)if not watermark then
buildWatermark()end watermark.Visible=visible==true end local keyMenu,keyList
local keyRows={}local function buildKeyMenu()keyMenu=New('TextButton',{Name=
'Keybinds',AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,16,0.5,0),Size=
UDim2.fromOffset(190,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=
'Background',Visible=false,Parent=Library.Hud})scaled(keyMenu)Util.Corner(
keyMenu,11)Util.Stroke(keyMenu,'Accent',1.2,0.35)Util.List(keyMenu,0)local head=
New('Frame',{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,LayoutOrder=0,
Parent=keyMenu})local icon=New('ImageLabel',{AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,11,0.5,0),Size=UDim2.fromOffset(14,14),
BackgroundTransparency=1,ImageColor3='Accent',Parent=head})Assets.SetIcon(icon,
'keyboard')New('TextLabel',{Position=UDim2.fromOffset(32,0),Size=UDim2.new(1,-40
,1,0),BackgroundTransparency=1,Text='Keybinds',FontFace='FontBold',TextSize=13,
TextXAlignment=Enum.TextXAlignment.Left,Parent=head})keyList=New('Frame',{Size=
UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
LayoutOrder=1,Parent=keyMenu})Util.List(keyList,0)New('UIPadding',{PaddingBottom
=UDim.new(0,6),Parent=keyList})Util.Draggable(keyMenu)end local keyMenuDirty=
false function Library:RefreshKeybindMenu()if not keyMenu or keyMenuDirty then
return end keyMenuDirty=true task.defer(function()keyMenuDirty=false if not
keyMenu.Visible then return end for _,row in ipairs(keyRows)do Util.Destroy(row)
end table.clear(keyRows)for index,picker in ipairs(self.KeyPickers)do if not
picker.NoUI and picker.Value~='None'and picker.Text~=''then local active=picker:
GetState()local row=New('TextButton',{Size=UDim2.new(1,0,0,24),
BackgroundTransparency=1,LayoutOrder=index,Parent=keyList})New('TextLabel',{
Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-70,1,0),BackgroundTransparency
=1,Text=picker.Text,TextSize=12,TextColor3=active and'Text'or'Dim',
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
Parent=row})New('TextLabel',{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-
12,0,0),Size=UDim2.new(0,56,1,0),BackgroundTransparency=1,Text=self:
GetKeyString(picker.Value),TextSize=12,TextColor3=active and'Accent'or'Dim',
TextXAlignment=Enum.TextXAlignment.Right,Parent=row})row.MouseButton1Click:
Connect(function()picker:DoClick()end)table.insert(keyRows,row)end end end)end
function Library:SetKeybindMenuVisible(visible)if not keyMenu then buildKeyMenu(
)end keyMenu.Visible=visible==true self:RefreshKeybindMenu()end Library.
SetKeybindViewerVisible=Library.SetKeybindMenuVisible Library.KeybindFrame=
setmetatable({},{__index=function(_,key)if key=='Visible'then return keyMenu~=
nil and keyMenu.Visible end if not keyMenu then buildKeyMenu()end return keyMenu
[key]end,__newindex=function(_,key,value)if key=='Visible'then return Library:
SetKeybindMenuVisible(value)end if not keyMenu then buildKeyMenu()end keyMenu[
key]=value end})local pill local function buildPill()pill=New('TextButton',{Name
='TogglePill',AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-16,0,68),Size=
UDim2.fromOffset(0,40),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=
'Background',Visible=false,Parent=Library.Hud})scaled(pill)Util.Corner(pill,13)
Util.Stroke(pill,'Accent',1.5,0.3)Util.Pad(pill,9,0,13,0)Util.List(pill,9,Enum.
FillDirection.Horizontal,nil,Enum.VerticalAlignment.Center)logoInto(pill,24).
LayoutOrder=1 New('TextLabel',{Size=UDim2.fromOffset(0,40),AutomaticSize=Enum.
AutomaticSize.X,BackgroundTransparency=1,Text='Courage',FontFace='FontBold',
TextSize=14,LayoutOrder=2,Parent=pill})local wave=New('Frame',{Size=UDim2.
fromOffset(31,22),BackgroundTransparency=1,LayoutOrder=3,Parent=pill})local
heights={8,16,22,12,18,9}for index,height in ipairs(heights)do local bar=New(
'Frame',{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,(index-1)*5.5,0.5,0
),Size=UDim2.fromOffset(3,4),BackgroundColor3='Accent',Parent=wave})Util.Corner(
bar,2)Services.TweenService:Create(bar,TweenInfo.new(0.35+index*0.07,Enum.
EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true,index*0.05),{Size=UDim2.
fromOffset(3,height)}):Play()end local startPointer,startPosition,moved Util.
Drag(pill,function(pointer)startPointer,startPosition,moved=pointer,pill.
Position,false end,function(pointer)local delta=pointer-startPointer if delta.
Magnitude>6 then moved=true end if moved then pill.Position=UDim2.new(
startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,
startPosition.Y.Offset+delta.Y)end end,function()if not moved then Library:
Toggle()end end)end function Library:RefreshPill()local mode=self.
ShowToggleButton local show=mode==true or(mode=='Mobile'and self.IsMobile)if
show and not pill then buildPill()end if pill then pill.Visible=show end end
function Library:SetDPIScale(percent)local scale=(tonumber(percent)or 100)/100
self.DPIScale=math.clamp(scale,0.5,2)for _,object in ipairs(self.ScaleObjects)do
object.Scale=self.DPIScale end if self.Window then self.Window.Scale.Scale=self.
DPIScale end self:ClosePopup()end local cursor,modal,cursorOn,savedIcon,
cursorShown function Library:SetCustomCursor(enabled)self.CustomCursor=enabled==
true if cursor then return end local UserInputService=Services.UserInputService
cursor=New('ImageLabel',{Name='Cursor',Image='rbxassetid://81857207543459',
ImageColor3='Accent',BackgroundTransparency=1,Size=UDim2.fromOffset(24,24),
Visible=false,ZIndex=9999,Parent=Library.Overlay})modal=New('TextButton',{Name=
'Modal',BackgroundTransparency=1,Text='',Size=UDim2.fromOffset(0,0),Modal=false,
Parent=Library.Overlay})Library:GiveSignal(Services.RunService.RenderStepped:
Connect(function()local want=Library.CustomCursor and Library.Toggled==true if
want~=cursorShown then cursorShown=want cursor.Visible=want modal.Modal=want if
want then savedIcon=UserInputService.MouseIconEnabled elseif savedIcon~=nil then
UserInputService.MouseIconEnabled=savedIcon end end if want then
UserInputService.MouseIconEnabled=false local at=UserInputService:
GetMouseLocation()cursor.Position=UDim2.fromOffset(at.X-7,at.Y)end end))Library:
OnUnload(function()if cursorShown and savedIcon~=nil then UserInputService.
MouseIconEnabled=savedIcon end end)end end end function __DARKLUA_BUNDLE_MODULES
.e()local v=__DARKLUA_BUNDLE_MODULES.cache.e if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c end end do local function 
__modImpl()return function(Library)local Util=Library.Util local New=Util.New
local Base={}Base.__index=Base function Base.extend()local class=setmetatable({}
,Base)class.__index=class return class end function Base.init(class,container,
kind,idx,info)local self=setmetatable({},class)self.Type=kind self.Idx=idx self.
Info=info self.Text=Library.Translate(info.Text or(type(idx)=='string'and idx)or
'')self.Visible=info.Visible~=false self.Disabled=info.Disabled==true self.Risky
=info.Risky==true self.Callback=info.Callback self.Container=container self.
Addons={}table.insert(container.Elements,self)return self end function Base:Row(
height)local container=self.Container container.Order+=1 local holder=New(
'Frame',{Name=self.Type,Size=UDim2.new(1,0,0,height),BackgroundTransparency=1,
LayoutOrder=container.Order,Visible=self.Visible,Parent=container.Content})New(
'Frame',{Name='Line',Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-24,0,1),
BackgroundColor3='Outline',BackgroundTransparency=0.55,Parent=holder})self.
Holder=holder if self.Info.Tooltip then Library:AddTooltip(holder,self.Info.
Tooltip)end return holder end function Base:Title(holder,reserved)self.Reserved=
reserved or 0 local label=New('TextLabel',{Name='Title',Position=UDim2.
fromOffset(14,0),Size=UDim2.new(1,-self.Reserved-26,1,0),BackgroundTransparency=
1,Text=self.Text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.
TextTruncate.AtEnd,TextColor3=self.Risky and'Red'or'Text',Parent=holder})self.
Label=label return label end function Base:AddonStrip(holder)local strip=New(
'Frame',{Name='Addons',AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-14,
0.5,0),Size=UDim2.new(0,0,0,22),AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,Parent=holder})Util.List(strip,6,Enum.FillDirection.
Horizontal,Enum.HorizontalAlignment.Right,Enum.VerticalAlignment.Center)self.
Strip=strip return strip end function Base:Reserve(width)self.Reserved=(self.
Reserved or 0)+width if self.Label then self.Label.Size=UDim2.new(1,-self.
Reserved-26,1,0)end end function Base:Refresh()if self.Holder then self.Holder.
Visible=self.Visible and not self.SearchHidden end end function Base:SetVisible(
visible)self.Visible=visible~=false self:Refresh()end function Base:SetDisabled(
disabled)self.Disabled=disabled==true if self.Label then self.Label.
TextTransparency=self.Disabled and 0.55 or 0 end if self.Display then self:
Display()end end function Base:SetText(text)self.Text=Library.Translate(text)if
self.Label then self.Label.Text=self.Text end end function Base:SetTooltip(text)
if self.Holder then Library:AddTooltip(self.Holder,text)end end function Base:
OnChanged(callback)self.Changed=callback end function Base:RunChanged()Util.
Safe(self.Callback,self.Value)Util.Safe(self.Changed,self.Value)end function
Base:Commit()Library:UpdateDependencyBoxes()self:RunChanged()end function Base:
Destroy()local idx=self.Idx if idx~=nil then if Library.Options[idx]==self then
Library.Options[idx]=nil end if Library.Toggles[idx]==self then Library.Toggles[
idx]=nil end end local list=self.Container.Elements local index=table.find(list,
self)if index then table.remove(list,index)end if self.Holder then Util.Destroy(
self.Holder)end end function Base:Register()if self.Idx==nil then return end if
self.Type=='Toggle'then Library.Toggles[self.Idx]=self else Library.Options[self
.Idx]=self end end return Base end end function __DARKLUA_BUNDLE_MODULES.f()
local v=__DARKLUA_BUNDLE_MODULES.cache.f if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.f=v end return v.c end end do local function 
__modImpl()return function(Library,Base)local Util=Library.Util local New=Util.
New local Toggle=Base.extend()function Toggle:Display(instant)local on=self.
Value local time=instant and 0 or 0.2 Util.TweenTheme(self.Track,time,{
BackgroundColor3=on and'Accent'or'Raised'})Util.Tween(self.Knob,time,{Position=
on and UDim2.new(1,-17,0.5,0)or UDim2.new(0,3,0.5,0)})self.TrackStroke.
Transparency=on and 1 or 0.3 self.Track.BackgroundTransparency=self.Disabled and
0.6 or 0 self.Knob.BackgroundTransparency=self.Disabled and 0.5 or 0 end
function Toggle:SetValue(value)value=value and true or false if self.Value==
value then return end self.Value=value self:Display()for _,addon in ipairs(self.
Addons)do if addon.Type=='KeyPicker'and addon.SyncToggleState then addon:
SyncFromToggle(value)end end self:Commit()end function Toggle:AddKeyPicker(idx,
info)return Library.Elements.KeyPicker(self,idx,info or{})end function Toggle:
AddColorPicker(idx,info)return Library.Elements.ColorPicker(self,idx,info or{})
end return function(container,idx,info)info=info or{}local self=Base.init(Toggle
,container,'Toggle',idx,info)self.Value=info.Default==true local holder=self:
Row(34)local hit=New('TextButton',{Name='Hit',Size=UDim2.fromScale(1,1),
BackgroundColor3='White',BackgroundTransparency=1,Parent=holder})self:Title(
holder,44)local strip=self:AddonStrip(holder)strip.ZIndex=2 local track=New(
'TextButton',{Name='Switch',Size=UDim2.fromOffset(38,20),BackgroundColor3=
'Raised',LayoutOrder=100,Parent=strip})Util.Corner(track,10)self.TrackStroke=
Util.Stroke(track,'Outline',1,0.3)local knob=New('Frame',{AnchorPoint=Vector2.
new(0,0.5),Position=UDim2.new(0,3,0.5,0),Size=UDim2.fromOffset(14,14),
BackgroundColor3='White',Parent=track})Util.Corner(knob,7)self.Track,self.Knob=
track,knob local function click()if self.Disabled then return end self:SetValue(
not self.Value)end Library:GiveSignal(hit.MouseButton1Click:Connect(click))
Library:GiveSignal(track.MouseButton1Click:Connect(click))Util.Hover(hit,
function()Util.Tween(hit,0.15,{BackgroundTransparency=0.965})end,function()Util.
Tween(hit,0.15,{BackgroundTransparency=1})end)self:Display(true)self:Register()
return self end end end function __DARKLUA_BUNDLE_MODULES.g()local v=
__DARKLUA_BUNDLE_MODULES.cache.g if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.g=v end return v.c end end do local function 
__modImpl()return function(Library,Base)local Util=Library.Util local New=Util.
New local Button=Base.extend()local function layout(row)local count=#row.Buttons
for index,button in ipairs(row.Buttons)do button.Frame.AnchorPoint=Vector2.new(
0.5,0.5)button.Frame.Size=UDim2.new(1/count,-6*(count-1)/count,1,0)button.Frame.
Position=UDim2.new((index-0.5)/count,(6*(index-1)-3*(count-1))/count,0.5,0)end
end function Button:Display()self.Frame.BackgroundTransparency=self.Disabled and
0.6 or 0 self.Caption.TextTransparency=self.Disabled and 0.5 or 0 end function
Button:SetText(text)self.Text=Library.Translate(text)self.Caption.Text=self.Text
end function Button:SetVisible(visible)self.Visible=visible~=false if self.IsSub
then self.Frame.Visible=self.Visible else self:Refresh()end end function Button:
AddButton(a,b)local info=type(a)=='table'and a or{Text=a,Func=b}return Button.
build(self.Container,info,self.RowData)end function Button.build(container,info,
row)local self if row then self=setmetatable({Type='Button',Info=info,Container=
container,Addons={},IsSub=true,Text=Library.Translate(info.Text or''),Visible=
true,Disabled=info.Disabled==true},Button)else self=Base.init(Button,container,
'Button',nil,info)local holder=self:Row(42)row={Buttons={},Frame=New('Frame',{
Position=UDim2.fromOffset(12,7),Size=UDim2.new(1,-24,0,29),
BackgroundTransparency=1,Parent=holder})}end self.RowData=row self.Func=info.
Func or info.Callback local risky=info.Risky==true local secondary=info.Style==
'Secondary'local frame=New('TextButton',{Name='Button',BackgroundColor3=risky
and'Red'or(secondary and'Raised'or'Accent'),Parent=row.Frame})Util.Corner(frame,
8)if not secondary then New('UIGradient',{Rotation=90,Color=ColorSequence.new(
Color3.new(1,1,1),Color3.new(0.72,0.72,0.8)),Parent=frame})else Util.Stroke(
frame,'Outline',1,0.2)end local shine=New('Frame',{Name='Shine',Size=UDim2.
fromScale(1,1),BackgroundColor3='White',BackgroundTransparency=1,Parent=frame})
Util.Corner(shine,8)local caption=New('TextLabel',{Size=UDim2.new(1,-12,1,0),
Position=UDim2.fromOffset(6,0),BackgroundTransparency=1,Text=self.Text,FontFace=
'FontSemi',TextSize=13,TextColor3=secondary and'Text'or'White',TextTruncate=Enum
.TextTruncate.AtEnd,Parent=frame})local scale=New('UIScale',{Parent=frame})self.
Frame,self.Caption=frame,caption if info.Tooltip then Library:AddTooltip(frame,
info.Tooltip)end Util.Hover(frame,function()if not self.Disabled then Util.
Tween(shine,0.15,{BackgroundTransparency=0.88})end end,function()Util.Tween(
shine,0.15,{BackgroundTransparency=1})end)Library:GiveSignal(frame.
MouseButton1Down:Connect(function()if not self.Disabled then Util.Tween(scale,
0.08,{Scale=0.96})end end))Library:GiveSignal(frame.InputEnded:Connect(function(
input)if Util.IsClick(input)then Util.Tween(scale,0.18,{Scale=1},Enum.
EasingStyle.Back)end end))local armed=false Library:GiveSignal(frame.
MouseButton1Click:Connect(function()if self.Disabled then return end if info.
DoubleClick and not armed then armed=true caption.Text='Are you sure?'task.
delay(1.5,function()if armed then armed=false caption.Text=self.Text end end)
return end armed=false caption.Text=self.Text Util.Safe(self.Func)end))table.
insert(row.Buttons,self)layout(row)self:Display()return self end return function
(container,a,b)local info=type(a)=='table'and a or{Text=a,Func=b}return Button.
build(container,info,nil)end end end function __DARKLUA_BUNDLE_MODULES.h()local
v=__DARKLUA_BUNDLE_MODULES.cache.h if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.h=v end return v.c end end do local function 
__modImpl()return function(Library,Base)local Util=Library.Util local New=Util.
New local Label=Base.extend()function Label:AddKeyPicker(idx,info)return Library
.Elements.KeyPicker(self,idx,info or{})end function Label:AddColorPicker(idx,
info)return Library.Elements.ColorPicker(self,idx,info or{})end local function 
label(container,a,b,c)local idx,info if type(b)=='table'then idx,info=a,b elseif
type(a)=='table'then info=a else idx,info=c,{Text=a,DoesWrap=b}end local self=
Base.init(Label,container,'Label',idx,info)if info.DoesWrap then local holder=
self:Row(0)holder.AutomaticSize=Enum.AutomaticSize.Y New('UIPadding',{PaddingTop
=UDim.new(0,8),PaddingBottom=UDim.new(0,8),Parent=holder})holder.Line.Position=
UDim2.fromOffset(12,-8)self.Label=New('TextLabel',{Name='Title',Position=UDim2.
fromOffset(14,0),Size=UDim2.new(1,-28,0,0),AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,Text=self.Text,TextWrapped=true,RichText=true,
TextXAlignment=Enum.TextXAlignment.Left,TextColor3='Dim',TextSize=13,Parent=
holder})else local holder=self:Row(30)self:Title(holder,0)self.Label.RichText=
true end self:Register()return self end local Divider=Base.extend()local 
function divider(container)local self=Base.init(Divider,container,'Divider',nil,
{})local holder=self:Row(11)holder.Line.Visible=false local line=New('Frame',{
AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,12,0.5,0),Size=UDim2.new(1,-
24,0,1),BackgroundColor3='Accent',Parent=holder})New('UIGradient',{Transparency=
NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(
0.5,0.2),NumberSequenceKeypoint.new(1,1)}),Parent=line})return self end return
label,divider end end function __DARKLUA_BUNDLE_MODULES.i()local v=
__DARKLUA_BUNDLE_MODULES.cache.i if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.i=v end return v.c end end do local function 
__modImpl()return function(Library,Base)local Util=Library.Util local New=Util.
New local Slider=Base.extend()local function round(value,places)local scale=10^(
places or 0)return math.floor(value*scale+0.5)/scale end function Slider:Format(
value)local text=self.Rounding>0 and string.format('%.'..self.Rounding..'f',
value)or tostring(math.floor(value+0.5))return self.Prefix..text..self.Suffix
end function Slider:Display(instant)local alpha=math.clamp((self.Value-self.Min)
/math.max(self.Max-self.Min,1e-9),0,1)local time=instant and 0 or 0.1 Util.
Tween(self.Fill,time,{Size=UDim2.new(alpha,0,1,0)})Util.Tween(self.Knob,time,{
Position=UDim2.new(alpha,0,0.5,0)})self.Box.Text=self:Format(self.Value)self.Hit
.Active=not self.Disabled self.Track.BackgroundTransparency=self.Disabled and
0.6 or 0 end function Slider:SetValue(value)value=tonumber(value)if not value
then return end value=round(math.clamp(value,self.Min,self.Max),self.Rounding)if
self.Value==value then self.Box.Text=self:Format(value)return end self.Value=
value self:Display()self:Commit()end function Slider:SetMin(value)self.Min=value
self:SetValue(math.max(self.Value,value))self:Display(true)end function Slider:
SetMax(value)self.Max=value self:SetValue(math.min(self.Value,value))self:
Display(true)end function Slider:SetPrefix(text)self.Prefix=text or''self:
Display(true)end function Slider:SetSuffix(text)self.Suffix=text or''self:
Display(true)end return function(container,idx,info)info=info or{}local self=
Base.init(Slider,container,'Slider',idx,info)self.Min=tonumber(info.Min)or 0
self.Max=tonumber(info.Max)or 100 self.Rounding=tonumber(info.Rounding)or 0 self
.Prefix=info.Prefix or''self.Suffix=info.Suffix or''self.Value=round(math.clamp(
tonumber(info.Default)or self.Min,self.Min,self.Max),self.Rounding)local holder=
self:Row(36)self:Title(holder,0)self.Label.Size=UDim2.new(0.42,-14,1,0)local box
=New('TextBox',{Name='Value',AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1
,-12,0.5,0),Size=UDim2.fromOffset(50,22),BackgroundTransparency=1,Text='',
TextSize=13,TextColor3='Text',TextXAlignment=Enum.TextXAlignment.Right,
ClearTextOnFocus=true,Parent=holder})local hit=New('TextButton',{Name='Hit',
AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0.42,6,0.5,0),Size=UDim2.new(
0.58,-78,0,22),BackgroundTransparency=1,Parent=holder})local track=New('Frame',{
Name='Track',AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromScale(0,0.5),Size
=UDim2.new(1,0,0,4),BackgroundColor3='Raised',Parent=hit})Util.Corner(track,2)
local fill=New('Frame',{Name='Fill',Size=UDim2.fromScale(0,1),BackgroundColor3=
'Accent',Parent=track})Util.Corner(fill,2)local knob=New('Frame',{Name='Knob',
AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.
fromOffset(14,14),BackgroundColor3='White',Parent=track})Util.Corner(knob,7)Util
.Stroke(knob,'Accent',2,0.35)self.Box,self.Hit,self.Track,self.Fill,self.Knob=
box,hit,track,fill,knob local scroller local function fromPointer(pointer)local
alpha=math.clamp((pointer.X-track.AbsolutePosition.X)/math.max(track.
AbsoluteSize.X,1),0,1)self:SetValue(self.Min+alpha*(self.Max-self.Min))end Util.
Drag(hit,function(pointer)if self.Disabled then return false end scroller=holder
:FindFirstAncestorOfClass('ScrollingFrame')if scroller then scroller.
ScrollingEnabled=false end Util.Tween(knob,0.12,{Size=UDim2.fromOffset(17,17)})
fromPointer(pointer)return true end,fromPointer,function()if scroller then
scroller.ScrollingEnabled=true end Util.Tween(knob,0.12,{Size=UDim2.fromOffset(
14,14)})end)Library:GiveSignal(box.FocusLost:Connect(function()local number=
tonumber((string.gsub(box.Text,'[^%d%.%-]','')))if number and not self.Disabled
then self:SetValue(number)end box.Text=self:Format(self.Value)end))self:Display(
true)self:Register()return self end end end function __DARKLUA_BUNDLE_MODULES.j(
)local v=__DARKLUA_BUNDLE_MODULES.cache.j if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.j=v end return v.c end end do local function 
__modImpl()return function(Library,Base)local Util=Library.Util local New=Util.
New local Services=Util.Services local ITEM=28 local Dropdown=Base.extend()local 
function toSet(list)local set={}if type(list)=='table'then for key,value in
pairs(list)do if type(key)=='number'then set[value]=true elseif value then set[
key]=true end end elseif list~=nil then set[list]=true end return set end local 
function sameSet(a,b)for key in pairs(a)do if not b[key]then return false end
end for key in pairs(b)do if not a[key]then return false end end return true end
function Dropdown:Format(value)if self.Info.FormatDisplayValue then local ok,
text=pcall(self.Info.FormatDisplayValue,value)if ok and text~=nil then return
tostring(text)end end return Library.Translate(tostring(value))end function
Dropdown:Summary()if self.Multi then local list={}for _,value in ipairs(self.
Values)do if self.Value[value]then list[#list+1]=self:Format(value)end end if#
list==0 then return nil end return table.concat(list,', ')end if self.Value==nil
then return nil end return self:Format(self.Value)end function Dropdown:Display(
)local summary=self:Summary()self.Current.Text=summary or'None'Util.Register(
self.Current,{TextColor3=summary and'Text'or'Dim'})self.Box.
BackgroundTransparency=self.Disabled and 0.6 or 0 if self.Popup then self:
RenderList()end end function Dropdown:GetActiveValues()if self.Multi then local
count=0 for _ in pairs(self.Value)do count+=1 end return count end return self.
Value~=nil and 1 or 0 end function Dropdown:SetValue(value)if self.Multi then
local set=toSet(value)if sameSet(self.Value,set)then return end self.Value=set
else if type(value)=='number'and self.Values[value]~=nil and not table.find(self
.Values,value)then value=self.Values[value]end if self.Value==value then return
end self.Value=value end self:Display()self:Commit()end function Dropdown:
SetValues(values)self.Values=values or{}local present=toSet(self.Values)if self.
Multi then local kept={}for key in pairs(self.Value)do if present[key]then kept[
key]=true end end if not sameSet(kept,self.Value)then self:SetValue(kept)return
end elseif self.Value~=nil and not present[self.Value]then self:SetValue(nil)
return end self:Display()end function Dropdown:AddValues(values)local merged=
table.clone(self.Values)for _,value in ipairs(type(values)=='table'and values or
{values})do table.insert(merged,value)end self:SetValues(merged)end function
Dropdown:SetDisabledValues(values)self.DisabledValues=toSet(values)if self.Popup
then self:RenderList()end end function Dropdown:IsSelected(value)if self.Multi
then return self.Value[value]==true end return self.Value==value end function
Dropdown:Pick(value)if self.Multi then local set=table.clone(self.Value)set[
value]=(not set[value])or nil self:SetValue(set)else if self.Value==value then
if self.AllowNull then self:SetValue(nil)end else self:SetValue(value)end self:
CloseList()end end function Dropdown:RenderList()local popup=self.Popup if not
popup then return end local list=popup.List for _,child in ipairs(list:
GetChildren())do if child:IsA('TextButton')then Util.Destroy(child)end end local
filter=popup.Filter and string.lower(popup.Filter)or''for index,value in ipairs(
self.Values)do local text=self:Format(value)if filter==''or string.find(string.
lower(text),filter,1,true)then local selected=self:IsSelected(value)local
disabled=self.DisabledValues[value]==true local row=New('TextButton',{Size=UDim2
.new(1,0,0,ITEM-2),BackgroundColor3=selected and'AccentSoft'or'Raised',
BackgroundTransparency=selected and 0 or 1,LayoutOrder=index,Parent=list})Util.
Corner(row,6)local indent=10 if self.SpecialType=='Player'then local player=
Services.Players:FindFirstChild(tostring(value))local face=New('ImageLabel',{
AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,6,0.5,0),Size=UDim2.
fromOffset(20,20),BackgroundColor3='Raised',Image=player and string.format(
'rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48',player.UserId)or'',Parent=row})
Util.Corner(face,10)indent=34 end New('TextLabel',{Position=UDim2.fromOffset(
indent,0),Size=UDim2.new(1,-indent-20,1,0),BackgroundTransparency=1,Text=text,
TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.
TextTruncate.AtEnd,TextColor3=disabled and'Dim'or(selected and'Text'or'Dim'),
TextTransparency=disabled and 0.5 or 0,Parent=row})if selected then local dot=
New('Frame',{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size
=UDim2.fromOffset(6,6),BackgroundColor3='Accent',Parent=row})Util.Corner(dot,3)
end if not disabled then row.MouseEnter:Connect(function()if not self:
IsSelected(value)then row.BackgroundTransparency=0.4 end end)row.MouseLeave:
Connect(function()if not self:IsSelected(value)then row.BackgroundTransparency=1
end end)row.MouseButton1Click:Connect(function()self:Pick(value)end)end end end
end function Dropdown:CloseList()local popup=self.Popup if not popup then return
end self.Popup=nil if Library.Popup and Library.Popup.Owner==self then Library.
Popup=nil end Util.Tween(self.Arrow,0.2,{Rotation=0})local tween=Util.Tween(
popup.Frame,0.14,{Size=UDim2.fromOffset(popup.Width,0)})if tween then tween.
Completed:Once(function()Util.Destroy(popup.Frame)end)else Util.Destroy(popup.
Frame)end end function Dropdown:OpenList()if self.Disabled then return end if
self.Popup then self:CloseList()return end Library:ClosePopup()if self.Reload
then self.Reload()end local count=#self.Values local searchable=self.Info.
Searchable==true or count>12 local shown=math.clamp(count,1,self.Info.
MaxVisibleDropdownItems or 8)local width=math.max(150,self.Box.AbsoluteSize.X/
Library.DPIScale)local height=shown*ITEM+8+(searchable and 34 or 0)local frame=
New('Frame',{Name='DropdownList',Size=UDim2.fromOffset(width,0),BackgroundColor3
='Main',ClipsDescendants=true,Parent=Library.Overlay})New('UIScale',{Scale=
Library.DPIScale,Parent=frame})Util.Corner(frame,9)Util.Stroke(frame,'Outline',1
,0)Util.PlacePopup(frame,self.Box,width,height)local popup={Frame=frame,Width=
width}if searchable then local search=New('TextBox',{Position=UDim2.fromOffset(
10,4),Size=UDim2.new(1,-20,0,28),BackgroundTransparency=1,PlaceholderText=
'Search...',PlaceholderColor3='Dim',TextSize=13,Text='',TextXAlignment=Enum.
TextXAlignment.Left,ClearTextOnFocus=false,Parent=frame})New('Frame',{Position=
UDim2.fromOffset(8,33),Size=UDim2.new(1,-16,0,1),BackgroundColor3='Outline',
BackgroundTransparency=0.4,Parent=frame})search:GetPropertyChangedSignal('Text')
:Connect(function()popup.Filter=search.Text self:RenderList()end)end local top=
searchable and 38 or 4 popup.List=New('ScrollingFrame',{Position=UDim2.
fromOffset(4,top),Size=UDim2.new(1,-8,1,-top-4),BackgroundTransparency=1,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollBarThickness=2,ScrollBarImageColor3='Accent',ScrollingDirection=Enum.
ScrollingDirection.Y,Parent=frame})Util.List(popup.List,2)self.Popup=popup
Library.Popup={Owner=self,Frames={frame,self.Box},Close=function()self:
CloseList()end}self:RenderList()Util.Tween(self.Arrow,0.2,{Rotation=180})Util.
Tween(frame,0.2,{Size=UDim2.fromOffset(width,height)})end local function 
playerNames(excludeLocal)local list={}for _,player in ipairs(Services.Players:
GetPlayers())do if not(excludeLocal and player==Services.Players.LocalPlayer)
then list[#list+1]=player.Name end end table.sort(list)return list end local 
function teamNames()local list={}for _,team in ipairs(Services.Teams:GetTeams())
do list[#list+1]=team.Name end table.sort(list)return list end return function(
container,idx,info)info=info or{}local self=Base.init(Dropdown,container,
'Dropdown',idx,info)self.Multi=info.Multi==true self.AllowNull=info.AllowNull==
true self.DisabledValues=toSet(info.DisabledValues)self.Values=info.Values or{}
self.SpecialType=info.SpecialType if info.SpecialType=='Player'then self.Values=
playerNames(info.ExcludeLocalPlayer)self.Reload=function()self.Values=
playerNames(info.ExcludeLocalPlayer)end elseif info.SpecialType=='Team'then self
.Values=teamNames()self.Reload=function()self.Values=teamNames()end end local
default=info.Default if self.Multi then self.Value=toSet(default)else if type(
default)=='number'and self.Values[default]~=nil and not table.find(self.Values,
default)then default=self.Values[default]end self.Value=default end local holder
=self:Row(40)local titled=self.Text~=''if titled then self:Title(holder,0)self.
Label.Size=UDim2.new(0.42,-14,1,0)end local box=New('TextButton',{Name='Box',
AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=titled and
UDim2.new(0.58,-18,0,28)or UDim2.new(1,-24,0,28),BackgroundColor3='Raised',
Parent=holder})Util.Corner(box,7)local stroke=Util.Stroke(box,'Outline',1,0.2)
self.Current=New('TextLabel',{Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-
34,1,0),BackgroundTransparency=1,TextSize=13,TextXAlignment=Enum.TextXAlignment.
Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=box})self.Arrow=Util.Chevron(
box,'Dim')self.Arrow.AnchorPoint=Vector2.new(1,0.5)self.Arrow.Position=UDim2.
new(1,-9,0.5,0)self.Box=box Library:GiveSignal(box.MouseButton1Click:Connect(
function()self:OpenList()end))Util.Hover(box,function()Util.TweenTheme(stroke,
0.15,{Color='Accent'})end,function()Util.TweenTheme(stroke,0.15,{Color='Outline'
})end)self:Display()self:Register()return self end end end function
__DARKLUA_BUNDLE_MODULES.k()local v=__DARKLUA_BUNDLE_MODULES.cache.k if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.k=v end return v.c end end
do local function __modImpl()return function(Library,Base)local Util=Library.
Util local New=Util.New local Input=Base.extend()function Input:Clean(text)text=
tostring(text==nil and''or text)if self.Numeric then text=string.gsub(text,
'[^%d%.%-]','')end if self.MaxLength then text=string.sub(text,1,self.MaxLength)
end return text end function Input:SetValue(text)text=self:Clean(text)if self.
Box.Text~=text then self.Box.Text=text end if self.Value==text then return end
self.Value=text self:Commit()end function Input:Display()self.Box.TextEditable=
not self.Disabled self.Field.BackgroundTransparency=self.Disabled and 0.6 or 0
end return function(container,idx,info)info=info or{}local self=Base.init(Input,
container,'Input',idx,info)self.Numeric=info.Numeric==true self.MaxLength=info.
MaxLength self.Value=self:Clean(info.Default)local holder=self:Row(40)local
titled=self.Text~=''if titled then self:Title(holder,0)self.Label.Size=UDim2.
new(0.42,-14,1,0)end local field=New('Frame',{Name='Field',AnchorPoint=Vector2.
new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=titled and UDim2.new(0.58,-18,0,
28)or UDim2.new(1,-24,0,28),BackgroundColor3='Raised',Parent=holder})Util.
Corner(field,7)local stroke=Util.Stroke(field,'Outline',1,0.2)local box=New(
'TextBox',{Position=UDim2.fromOffset(9,0),Size=UDim2.new(1,-18,1,0),
BackgroundTransparency=1,Text=self.Value,TextSize=13,PlaceholderText=info.
Placeholder or'',PlaceholderColor3='Dim',TextXAlignment=Enum.TextXAlignment.Left
,ClearTextOnFocus=info.ClearTextOnFocus==true,ClipsDescendants=true,Parent=field
})self.Field,self.Box=field,box Library:GiveSignal(box.Focused:Connect(function(
)Util.TweenTheme(stroke,0.15,{Color='Accent'})end))Library:GiveSignal(box.
FocusLost:Connect(function()Util.TweenTheme(stroke,0.15,{Color='Outline'})self:
SetValue(box.Text)end))if not info.Finished then Library:GiveSignal(box:
GetPropertyChangedSignal('Text'):Connect(function()local clean=self:Clean(box.
Text)if clean~=box.Text then box.Text=clean return end self:SetValue(clean)end))
end self:Display()self:Register()return self end end end function
__DARKLUA_BUNDLE_MODULES.l()local v=__DARKLUA_BUNDLE_MODULES.cache.l if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.l=v end return v.c end end
do local function __modImpl()return function(Library,Base)local Util=Library.
Util local New=Util.New local UserInputService=Util.Services.UserInputService
local SHORT={LeftShift='LShift',RightShift='RShift',LeftControl='LCtrl',
RightControl='RCtrl',LeftAlt='LAlt',RightAlt='RAlt',CapsLock='Caps',Return=
'Enter',Backspace='Back',PageUp='PgUp',PageDown='PgDn',Insert='Ins',Delete='Del'
,None='None'}local MOUSE={[Enum.UserInputType.MouseButton1]='MB1',[Enum.
UserInputType.MouseButton2]='MB2',[Enum.UserInputType.MouseButton3]='MB3'}local
KeyPicker=setmetatable({},Base)KeyPicker.__index=KeyPicker local function keyOf(
input)if input.UserInputType==Enum.UserInputType.Keyboard then return input.
KeyCode.Name end return MOUSE[input.UserInputType]end Library.KeyOf=keyOf
function Library:GetKeyString(key)return SHORT[key]or key end function KeyPicker
:Display()local bound=self.Value~='None'for _,dot in ipairs(self.Dots)do Util.
Register(dot,{BackgroundColor3=bound and'Accent'or'Dim'})end local menu=self.
Menu if menu then menu.Key.Text=self.Picking and'Press a key...'or(bound and(
SHORT[self.Value]or self.Value)or'Click to bind')Util.Register(menu.Key,{
TextColor3=(self.Picking or bound)and'Text'or'Dim'})for mode,button in pairs(
menu.Modes)do local active=mode==self.Mode Util.Register(button,{
BackgroundColor3=active and'Accent'or'Raised',TextColor3=active and'White'or
'Dim'})end end Library:RefreshKeybindMenu()end KeyPicker.Update=KeyPicker.
Display function KeyPicker:GetState()if self.Mode=='Always'then return true end
if self.Mode=='Hold'then local key=self.Value if key=='None'then return false
end if key=='MB1'then return UserInputService:IsMouseButtonPressed(Enum.
UserInputType.MouseButton1)end if key=='MB2'then return UserInputService:
IsMouseButtonPressed(Enum.UserInputType.MouseButton2)end if key=='MB3'then
return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)end
local ok,code=pcall(function()return Enum.KeyCode[key]end)return ok and
UserInputService:IsKeyDown(code)and not UserInputService:GetFocusedTextBox()or
false end return self.Toggled end function KeyPicker:SetValue(data,mode)local
key if type(data)=='table'then key,mode=data[1],data[2]else key=data end if
typeof(key)=='EnumItem'then key=key.Name end self.Value=key or self.Value self.
Mode=mode or self.Mode if self.Mode=='Press'then self.Mode='Toggle'end self:
Display()Util.Safe(self.ChangedCallback,self.Value)Util.Safe(self.Changed,self.
Value)end function KeyPicker:OnClick(callback)self.Clicked=callback end function
KeyPicker:SetText(text)self.Text=Library.Translate(text)Library:
RefreshKeybindMenu()end function KeyPicker:DoClick()if self.Mode=='Toggle'then
self.Toggled=not self.Toggled end local state=self:GetState()if self.
SyncToggleState and self.Host.Type=='Toggle'then self.Host:SetValue(self.Mode==
'Toggle'and self.Toggled or state)end Util.Safe(self.Callback,state)Util.Safe(
self.Clicked,state)self:Display()end function KeyPicker:SyncFromToggle(value)if
self.Toggled==value then return end self.Toggled=value self:Display()end
function KeyPicker:Released()if self.Mode~='Hold'then return end if self.
SyncToggleState and self.Host.Type=='Toggle'then self.Host:SetValue(false)end
Util.Safe(self.Callback,false)self:Display()end function KeyPicker:CloseMenu()
local menu=self.Menu if not menu then return end self.Menu=nil if Library.Popup
and Library.Popup.Owner==self then Library.Popup=nil end if self.Picking then
self.Picking=false if Library.PickingKey==self then Library.PickingKey=nil end
end Util.Destroy(menu.Frame)end function KeyPicker:OpenMenu()if self.Menu then
return self:CloseMenu()end Library:ClosePopup()local width,height=196,110 local
frame=New('Frame',{Name='KeybindMenu',Size=UDim2.fromOffset(width,height),
BackgroundColor3='Main',Parent=Library.Overlay})New('UIScale',{Scale=Library.
DPIScale,Parent=frame})Util.Corner(frame,10)Util.Stroke(frame,'Outline')Util.
PlacePopup(frame,self.Button,width,height)New('TextLabel',{Position=UDim2.
fromOffset(12,8),Size=UDim2.new(1,-24,0,16),BackgroundTransparency=1,Text=
'Keybind',FontFace='FontBold',TextSize=12,TextColor3='Dim',TextXAlignment=Enum.
TextXAlignment.Left,Parent=frame})local key=New('TextButton',{Position=UDim2.
fromOffset(10,30),Size=UDim2.new(1,-52,0,30),BackgroundColor3='Raised',TextSize=
13,FontFace='FontSemi',Parent=frame})Util.Corner(key,8)Util.Stroke(key,'Outline'
,1,0.2)local clear=New('TextButton',{AnchorPoint=Vector2.new(1,0),Position=UDim2
.new(1,-10,0,30),Size=UDim2.fromOffset(30,30),BackgroundColor3='Raised',Parent=
frame})Util.Corner(clear,8)Util.Stroke(clear,'Outline',1,0.2)for _,rotation in
ipairs({45,-45})do local bar=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(10,1.5),Rotation=
rotation,BackgroundColor3='Dim',Parent=clear})Util.Corner(bar,1)end Library:
AddTooltip(clear,'Remove the key')local modes={}local count=#self.Modes local
row=New('Frame',{Position=UDim2.fromOffset(10,70),Size=UDim2.new(1,-20,0,28),
BackgroundTransparency=1,Parent=frame})for index,mode in ipairs(self.Modes)do
local button=New('TextButton',{Position=UDim2.new((index-1)/count,4*(index-1)/
count,0,0),Size=UDim2.new(1/count,-4*(count-1)/count,1,0),BackgroundColor3=
'Raised',Text=mode,TextSize=12,FontFace='FontSemi',TextColor3='Dim',Parent=row})
Util.Corner(button,8)modes[mode]=button button.MouseButton1Click:Connect(
function()if mode~='Toggle'then self.Toggled=false end self:SetValue(self.Value,
mode)end)end key.MouseButton1Click:Connect(function()if self.Picking then return
end self.Picking=true self:Display()task.defer(function()Library.PickingKey=self
end)end)clear.MouseButton1Click:Connect(function()self:SetValue('None')end)self.
Menu={Frame=frame,Key=key,Modes=modes}Library.Popup={Owner=self,Frames={frame,
self.Button},Close=function()self:CloseMenu()end}self:Display()end function
Library:_startKeyInput()self:GiveSignal(UserInputService.InputBegan:Connect(
function(input)local key=keyOf(input)if not key then return end local picking=
self.PickingKey if picking then self.PickingKey=nil picking.Picking=false if key
=='Escape'or key=='Backspace'then key='None'end picking:SetValue(key)return end
if UserInputService:GetFocusedTextBox()then return end local menuKey=self.
ToggleKeybind if type(menuKey)=='table'then menuKey=menuKey.Value elseif typeof(
menuKey)=='EnumItem'then menuKey=menuKey.Name end if menuKey==key then self:
Toggle()end for _,picker in ipairs(self.KeyPickers)do if picker.Value==key and
picker.Mode~='Always'then picker:DoClick()end end end))self:GiveSignal(
UserInputService.InputEnded:Connect(function(input)local key=keyOf(input)if not
key then return end for _,picker in ipairs(self.KeyPickers)do if picker.Value==
key then picker:Released()end end end))end return function(host,idx,info)local
self=setmetatable({Type='KeyPicker',Idx=idx,Info=info,Host=host,Container=host.
Container,Addons={},Text=Library.Translate(info.Text or host.Text or''),Value=
info.Default or'None',Mode=info.Mode or'Toggle',Toggled=false,SyncToggleState=
info.SyncToggleState==true,NoUI=info.NoUI==true,Callback=info.Callback,
ChangedCallback=info.ChangedCallback,Modes=info.Modes or{'Toggle','Hold'},
Visible=true,Dots={}},KeyPicker)if typeof(self.Value)=='EnumItem'then self.Value
=self.Value.Name end if self.Mode=='Press'then self.Mode='Toggle'end if self.
SyncToggleState and host.Type=='Toggle'then self.Toggled=host.Value end local
strip=host.Strip or host:AddonStrip(host.Holder)local button=New('TextButton',{
Name='Key',Size=UDim2.fromOffset(20,20),BackgroundColor3='Raised',
BackgroundTransparency=1,LayoutOrder=50,Parent=strip})Util.Corner(button,6)for
index=1,3 do local dot=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=
UDim2.new(0.5,(index-2)*5,0.5,0),Size=UDim2.fromOffset(3,3),BackgroundColor3=
'Dim',Parent=button})Util.Corner(dot,2)self.Dots[index]=dot end self.Button=
button host:Reserve(26)table.insert(host.Addons,self)table.insert(Library.
KeyPickers,self)Library:AddTooltip(button,'Keybind')Library:GiveSignal(button.
MouseButton1Click:Connect(function()self:OpenMenu()end))Util.Hover(button,
function()button.BackgroundTransparency=0 end,function()button.
BackgroundTransparency=1 end)self:Display()if idx~=nil then Library.Options[idx]
=self end return self end end end function __DARKLUA_BUNDLE_MODULES.m()local v=
__DARKLUA_BUNDLE_MODULES.cache.m if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.m=v end return v.c end end do local function 
__modImpl()return function(Library,Base)local Util=Library.Util local New=Util.
New local WIDTH,SQUARE=196,124 local ColorPicker=setmetatable({},Base)
ColorPicker.__index=ColorPicker local RAINBOW=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(
0.16666666666666666,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(
0.3333333333333333,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3
.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.6666666666666666,Color3.
fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.8333333333333334,Color3.fromRGB(
255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))})function
ColorPicker:Display()self.Swatch.BackgroundColor3=self.Value self.Swatch.
BackgroundTransparency=self.Transparency or 0 local popup=self.Popup if not
popup then return end popup.Square.BackgroundColor3=Color3.fromHSV(self.Hue,1,1)
popup.Cursor.Position=UDim2.fromScale(self.Sat,1-self.Vib)popup.HueMark.Position
=UDim2.fromScale(self.Hue,0.5)popup.Hex.Text='#'..self.Value:ToHex()if popup.
Alpha then popup.Alpha.BackgroundColor3=self.Value popup.AlphaMark.Position=
UDim2.fromScale(self.Transparency or 0,0.5)end end ColorPicker.Update=
ColorPicker.Display function ColorPicker:RunChanged()Util.Safe(self.Callback,
self.Value,self.Transparency)Util.Safe(self.Changed,self.Value,self.Transparency
)end function ColorPicker:SetValueRGB(color,transparency)self.Value=color if
transparency~=nil and self.Transparency~=nil then self.Transparency=transparency
end self.Hue,self.Sat,self.Vib=color:ToHSV()self:Display()self:RunChanged()end
function ColorPicker:SetValue(hsv,transparency)if typeof(hsv)=='Color3'then
return self:SetValueRGB(hsv,transparency)end if type(hsv)=='table'then self:
SetValueRGB(Color3.fromHSV(hsv[1],hsv[2],hsv[3]),transparency)end end function
ColorPicker:SetHSV(hue,sat,vib)self.Hue,self.Sat,self.Vib=hue,sat,vib self.Value
=Color3.fromHSV(hue,sat,vib)self:Display()self:RunChanged()end function
ColorPicker:Close()local popup=self.Popup if not popup then return end self.
Popup=nil if Library.Popup and Library.Popup.Owner==self then Library.Popup=nil
end Util.Destroy(popup.Frame)end local function bar(parent,y)local frame=New(
'TextButton',{Position=UDim2.fromOffset(10,y),Size=UDim2.fromOffset(WIDTH-20,12)
,BackgroundColor3=Color3.new(1,1,1),Parent=parent})Util.Corner(frame,6)local
mark=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(6,16),
BackgroundColor3='White',Parent=frame})Util.Corner(mark,3)Util.Stroke(mark,
'Black',1,0.5)return frame,mark end function ColorPicker:Open()if self.Popup
then self:Close()return end Library:ClosePopup()local hasAlpha=self.Transparency
~=nil local height=SQUARE+20+22+(hasAlpha and 22 or 0)+38 local frame=New(
'Frame',{Name='ColorPicker',Size=UDim2.fromOffset(WIDTH,height),BackgroundColor3
='Main',Parent=Library.Overlay})New('UIScale',{Scale=Library.DPIScale,Parent=
frame})Util.Corner(frame,10)Util.Stroke(frame,'Outline')Util.PlacePopup(frame,
self.Swatch,WIDTH,height)local square=New('TextButton',{Position=UDim2.
fromOffset(10,10),Size=UDim2.fromOffset(WIDTH-20,SQUARE),Parent=frame})Util.
Corner(square,7)local white=New('Frame',{Size=UDim2.fromScale(1,1),
BackgroundColor3=Color3.new(1,1,1),Parent=square})Util.Corner(white,7)New(
'UIGradient',{Transparency=NumberSequence.new(0,1),Parent=white})local black=
New('Frame',{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),Parent
=square})Util.Corner(black,7)New('UIGradient',{Rotation=90,Transparency=
NumberSequence.new(1,0),Parent=black})local cursor=New('Frame',{AnchorPoint=
Vector2.new(0.5,0.5),Size=UDim2.fromOffset(10,10),BackgroundTransparency=1,
ZIndex=2,Parent=square})Util.Corner(cursor,5)Util.Stroke(cursor,'White',2)local
hue,hueMark=bar(frame,SQUARE+20)New('UIGradient',{Color=RAINBOW,Parent=hue})
local popup={Frame=frame,Square=square,Cursor=cursor,HueMark=hueMark}local y=
SQUARE+42 if hasAlpha then local alpha,alphaMark=bar(frame,y)New('UIGradient',{
Transparency=NumberSequence.new(0,1),Parent=alpha})popup.Alpha,popup.AlphaMark=
alpha,alphaMark Util.Drag(alpha,nil,function(pointer)self.Transparency=math.
clamp((pointer.X-alpha.AbsolutePosition.X)/alpha.AbsoluteSize.X,0,1)self:
Display()self:RunChanged()end)y+=22 end local field=New('Frame',{Position=UDim2.
fromOffset(10,y),Size=UDim2.fromOffset(WIDTH-20,26),BackgroundColor3='Raised',
Parent=frame})Util.Corner(field,6)popup.Hex=New('TextBox',{Size=UDim2.fromScale(
1,1),BackgroundTransparency=1,TextSize=13,Text='',ClearTextOnFocus=false,Parent=
field})popup.Hex.FocusLost:Connect(function()local ok,color=pcall(Color3.fromHex
,popup.Hex.Text)if ok then self:SetValueRGB(color)else self:Display()end end)
local function pickSquare(pointer)local position,size=square.AbsolutePosition,
square.AbsoluteSize self:SetHSV(self.Hue,math.clamp((pointer.X-position.X)/size.
X,0,1),1-math.clamp((pointer.Y-position.Y)/size.Y,0,1))end Util.Drag(square,
function(pointer)pickSquare(pointer)end,pickSquare)local function pickHue(
pointer)self:SetHSV(math.clamp((pointer.X-hue.AbsolutePosition.X)/hue.
AbsoluteSize.X,0,1),self.Sat,self.Vib)end Util.Drag(hue,function(pointer)
pickHue(pointer)end,pickHue)self.Popup=popup Library.Popup={Owner=self,Frames={
frame,self.Swatch},Close=function()self:Close()end}self:Display()end return
function(host,idx,info)local self=setmetatable({Type='ColorPicker',Idx=idx,Info=
info,Host=host,Container=host.Container,Addons={},Text=Library.Translate(info.
Title or info.Text or host.Text or''),Value=info.Default or Color3.new(1,1,1),
Transparency=info.Transparency,Callback=info.Callback,Visible=true},ColorPicker)
if self.Transparency==true then self.Transparency=0 end self.Hue,self.Sat,self.
Vib=self.Value:ToHSV()local strip=host.Strip or host:AddonStrip(host.Holder)
local swatch=New('TextButton',{Name='Color',Size=UDim2.fromOffset(26,16),
BackgroundColor3=self.Value,LayoutOrder=40,Parent=strip})Util.Corner(swatch,5)
Util.Stroke(swatch,'Outline',1,0)self.Swatch=swatch host:Reserve(32)table.
insert(host.Addons,self)Library:GiveSignal(swatch.MouseButton1Click:Connect(
function()self:Open()end))self:Display()if idx~=nil then Library.Options[idx]=
self end return self end end end function __DARKLUA_BUNDLE_MODULES.n()local v=
__DARKLUA_BUNDLE_MODULES.cache.n if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.n=v end return v.c end end do local function 
__modImpl()return function(Library)local Util=Library.Util local New=Util.New
local Elements=Library.Elements local Adders={}Adders.__index=Adders Library.
Adders=Adders function Adders:AddToggle(idx,info)return Elements.Toggle(self,idx
,info)end Adders.AddCheckbox=Adders.AddToggle function Adders:AddButton(a,b)
return Elements.Button(self,a,b)end function Adders:AddLabel(a,b,c)return
Elements.Label(self,a,b,c)end function Adders:AddDivider()return Elements.
Divider(self)end function Adders:AddSlider(idx,info)return Elements.Slider(self,
idx,info)end function Adders:AddDropdown(idx,info)return Elements.Dropdown(self,
idx,info)end function Adders:AddInput(idx,info)return Elements.Input(self,idx,
info)end function Adders:AddBlank(height)self.Order+=1 New('Frame',{Size=UDim2.
new(1,0,0,height or 6),BackgroundTransparency=1,LayoutOrder=self.Order,Parent=
self.Content})end function Adders:Resize()end local DependencyBox=setmetatable({
},Adders)DependencyBox.__index=DependencyBox function DependencyBox:Update()
local satisfied=true for _,rule in ipairs(self.Rules)do local element,expected=
rule[1],rule[2]if type(element)~='table'then satisfied=false break end local
value=element.Value if element.Type=='Dropdown'and type(value)=='table'then if
not value[expected]then satisfied=false break end elseif value~=expected then
satisfied=false break end end self.Content.Visible=satisfied and self.Visible
end function DependencyBox:SetupDependencies(rules)self.Rules=rules or{}self:
Update()end function DependencyBox:SetVisible(visible)self.Visible=visible~=
false self:Update()end function Adders:AddDependencyBox()self.Order+=1 local
frame=New('Frame',{Name='DependencyBox',Size=UDim2.new(1,0,0,0),AutomaticSize=
Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=self.Order,Parent=self
.Content})Util.List(frame,0)local box=setmetatable({Type='DependencyBox',Content
=frame,Elements={},Order=0,Rules={},Visible=true,Groupbox=self.Groupbox},
DependencyBox)table.insert(Library.DependencyBoxes,box)table.insert(self.
Elements,box)return box end function Library:UpdateDependencyBoxes()for _,box in
ipairs(self.DependencyBoxes)do box:Update()end end local Groupbox=setmetatable({
},Adders)Groupbox.__index=Groupbox local function card(column,name)column.Order
+=1 local frame=New('Frame',{Name=name,Size=UDim2.new(1,0,0,0),AutomaticSize=
Enum.AutomaticSize.Y,BackgroundColor3='Main',LayoutOrder=column.Order,Parent=
column.Frame})Util.Corner(frame,12)local stroke=Util.Stroke(frame,'Outline',1,0)
New('Frame',{Name='HeaderLine',Position=UDim2.fromOffset(0,39),Size=UDim2.new(1,
0,0,1),BackgroundColor3='Outline',ZIndex=3,Parent=frame})Util.Hover(frame,
function()Util.TweenTheme(stroke,0.2,{Color='Accent'})end,function()Util.
TweenTheme(stroke,0.25,{Color='Outline'})end)return frame end local function 
body(frame)local clip=New('Frame',{Name='Clip',Position=UDim2.fromOffset(0,39),
Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,ClipsDescendants=true,Parent=frame})local content=New(
'Frame',{Name='Content',Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize
.Y,BackgroundTransparency=1,Parent=clip})Util.List(content,0)New('UIPadding',{
PaddingBottom=UDim.new(0,5),Parent=content})return clip,content end function
Groupbox:SetCollapsed(collapsed,instant)collapsed=collapsed==true if self.
Collapsed==collapsed then return end self.Collapsed=collapsed Util.Tween(self.
Arrow,0.14,{Rotation=collapsed and-90 or 0})local clip=self.Clip local measured=
self.Content.AbsoluteSize.Y/Library.DPIScale if collapsed and measured>0 then
self.FullHeight=measured end if instant or not Library.Animations or not self.
FullHeight then clip.AutomaticSize=Enum.AutomaticSize.Y clip.Visible=not
collapsed return end clip.AutomaticSize=Enum.AutomaticSize.None if collapsed
then clip.Size=UDim2.new(1,0,0,self.FullHeight)Util.Tween(clip,0.14,{Size=UDim2.
new(1,0,0,0)},Enum.EasingStyle.Quad).Completed:Once(function()if self.Collapsed
then clip.Visible=false end end)else clip.Size=UDim2.new(1,0,0,0)clip.Visible=
true Util.Tween(clip,0.16,{Size=UDim2.new(1,0,0,self.FullHeight)},Enum.
EasingStyle.Quad).Completed:Once(function()if not self.Collapsed then clip.
AutomaticSize=Enum.AutomaticSize.Y end end)end end function Groupbox:
ToggleCollapsed()self:SetCollapsed(not self.Collapsed)end function Groupbox:
SetVisible(visible)self.Visible=visible~=false self.Frame.Visible=self.Visible
and not self.SearchHidden end function Groupbox:SetText(text)self.Name=Library.
Translate(text)self.Title.Text=self.Name end Groupbox.SetTitle=Groupbox.SetText
function Groupbox:SetImage(image,size)size=size or 90 if not self.Image then
local row=New('Frame',{Name='Image',Size=UDim2.new(1,0,0,size+16),
BackgroundTransparency=1,LayoutOrder=-1,Parent=self.Content})self.Image=New(
'ImageLabel',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5)
,Size=UDim2.fromOffset(size,size),BackgroundColor3='Raised',ScaleType=Enum.
ScaleType.Crop,Parent=row})Util.Corner(self.Image,math.ceil(size/2))Util.Stroke(
self.Image,'Outline')end Library.Assets.SetIcon(self.Image,image)end function
Groupbox:Destroy()self.Frame:Destroy()end function Library._Groupbox(column,name
,icon)name=Library.Translate(name or'')local frame=card(column,name)local header
=New('TextButton',{Name='Header',Size=UDim2.new(1,0,0,40),BackgroundTransparency
=1,Parent=frame})local left=14 if icon and icon~=''then local image=New(
'ImageLabel',{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,13,0.5,0),Size
=UDim2.fromOffset(19,19),BackgroundTransparency=1,ImageColor3='Accent',Parent=
header})Library.Assets.SetIcon(image,icon)left=41 end local title=New(
'TextLabel',{Position=UDim2.fromOffset(left,0),Size=UDim2.new(1,-left-34,1,0),
BackgroundTransparency=1,Text=name,FontFace='FontBold',TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
Parent=header})local arrow=Util.Chevron(header,'Dim')arrow.AnchorPoint=Vector2.
new(1,0.5)arrow.Position=UDim2.new(1,-14,0.5,0)local clip,content=body(frame)
local self=setmetatable({Type='Groupbox',Name=name,Frame=frame,Header=header,
Title=title,Arrow=arrow,Clip=clip,Content=content,Elements={},Order=0,Visible=
true,Collapsed=false},Groupbox)self.Groupbox=self self.Column=column table.
insert(column.Groupboxes,self)table.insert(Library.Groupboxes,self)Library.
Layout.RegisterBox(self)Library.Layout.HeaderDrag(self)return self end function
Library:SetSectionImage(title,image,size)for _,box in ipairs(self.Groupboxes)do
if box.Name==title then box:SetImage(image,size)end end local profile=self.Tabs.
Profile if title=='Discord'and profile then profile:SetImage(image)end end local
Tabbox={}Tabbox.__index=Tabbox local TabboxTab=setmetatable({},Adders)TabboxTab.
__index=TabboxTab function TabboxTab:Show()local box=self.Tabbox for _,tab in
ipairs(box.Tabs)do local active=tab==self tab.Clip.Visible=active Util.
TweenTheme(tab.Button,0.18,{TextColor3=active and'Text'or'Dim'})Util.Tween(tab.
Underline,0.18,{BackgroundTransparency=active and 0 or 1})end box.Active=self
end function Tabbox:AddTab(name)name=Library.Translate(name or'')local first=#
self.Tabs==0 local button=New('TextButton',{Size=UDim2.new(0,0,1,0),
AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=name,FontFace=
'FontSemi',TextSize=13,TextColor3=first and'Text'or'Dim',LayoutOrder=#self.Tabs+
1,Parent=self.Strip})local underline=New('Frame',{AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,2),BackgroundColor3='Accent',
BackgroundTransparency=first and 0 or 1,ZIndex=4,Parent=button})Util.Corner(
underline,1)local clip,content=body(self.Frame)clip.Visible=first local tab=
setmetatable({Type='TabboxTab',Name=name,Tabbox=self,Button=button,Underline=
underline,Clip=clip,Content=content,Elements={},Order=0,Visible=true},TabboxTab)
tab.Groupbox=self table.insert(self.Tabs,tab)if first then self.Active=tab end
Library:GiveSignal(button.MouseButton1Click:Connect(function()tab:Show()end))
return tab end function Tabbox:SetVisible(visible)self.Visible=visible~=false
self.Frame.Visible=self.Visible and not self.SearchHidden end function Tabbox:
Resize()end function Library._Tabbox(column,name)local frame=card(column,name or
'Tabbox')local strip=New('Frame',{Name='Tabs',Position=UDim2.fromOffset(14,0),
Size=UDim2.new(1,-28,0,39),BackgroundTransparency=1,Parent=frame})Util.List(
strip,16,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Left,Enum.
VerticalAlignment.Center)local self=setmetatable({Type='Tabbox',Name=name or'',
Frame=frame,Strip=strip,Tabs={},Visible=true},Tabbox)self.Column=column table.
insert(column.Groupboxes,self)return self end end end function
__DARKLUA_BUNDLE_MODULES.o()local v=__DARKLUA_BUNDLE_MODULES.cache.o if not v
then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.o=v end return v.c end end
do local function __modImpl()return function(Library)local Util=Library.Util
local New=Util.New local Services=Util.Services local Assets=Library.Assets
local ASPECT=1.5546558704453441 local EYES={Vector2.new(0.3746,0.6093),Vector2.
new(0.6272,0.6096)}local STATES={'awake','happy','squint','sleep','wave'}local
NAP_AFTER=25 local WIDTH=150 Library._Cat=function(root)local Cat={State=
'hidden',Active=false}local height=math.floor(WIDTH/ASPECT+0.5)local holder=New(
'TextButton',{Name='Cat',AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0
,0,22),Size=UDim2.fromOffset(WIDTH,height),BackgroundTransparency=1,Visible=
false,ZIndex=70,Parent=root})local body=New('Frame',{Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,Parent=holder})local frames={}for _,name in ipairs(
STATES)do frames[name]=New('ImageLabel',{Name=name,Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,Visible=false,Parent=body})end local burst=New(
'ImageLabel',{Name='Burst',Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
Visible=false,ZIndex=3,Parent=body})local eyes={}for index,centre in ipairs(EYES
)do local white=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.
fromScale(centre.X,centre.Y),Size=UDim2.fromOffset(20,20),BackgroundColor3=
Color3.fromRGB(250,246,255),Visible=false,ZIndex=2,Parent=body})Util.Corner(
white,10)local iris=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2
.fromScale(0.5,0.5),Size=UDim2.fromOffset(12,12),BackgroundColor3=Color3.
fromRGB(140,70,235),ZIndex=3,Parent=white})Util.Corner(iris,6)local pupil=New(
'Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size
=UDim2.fromOffset(6,6),BackgroundColor3=Color3.fromRGB(28,14,48),ZIndex=4,Parent
=iris})Util.Corner(pupil,3)local shine=New('Frame',{Position=UDim2.fromScale(
0.58,0.1),Size=UDim2.fromOffset(3,3),BackgroundColor3=Color3.new(1,1,1),ZIndex=5
,Parent=iris})Util.Corner(shine,2)eyes[index]={White=white,Iris=iris}end local
fx={}local busyUntil=0 local lastMouse,lastMove=Vector2.zero,os.clock()local
nextSneeze=os.clock()+math.random(40,90)local nextBlink=os.clock()+math.random(3
,6)local nextZ=0 local function setState(state)Cat.State=state for name,image in
pairs(frames)do image.Visible=name==(state=='sneeze'and'squint'or state)end
burst.Visible=state=='sneeze'for _,eye in ipairs(eyes)do eye.White.Visible=state
=='awake'end end local function float(kind,x,size)local asset=fx[kind]if not
asset then return end local image=New('ImageLabel',{AnchorPoint=Vector2.new(0.5,
0.5),Position=UDim2.fromScale(x,0.12),Size=UDim2.fromOffset(size,size),
BackgroundTransparency=1,Image=asset,ZIndex=6,Parent=holder})local tween=
Services.TweenService:Create(image,TweenInfo.new(1.3,Enum.EasingStyle.Sine,Enum.
EasingDirection.Out),{Position=UDim2.new(x+(math.random()-0.5)*0.25,0,0.12,-34),
ImageTransparency=1,Rotation=math.random(-18,18)})tween.Completed:Once(function(
)image:Destroy()end)tween:Play()end local function hop()local up=Services.
TweenService:Create(body,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.
EasingDirection.Out),{Position=UDim2.fromOffset(0,-7)})up.Completed:Once(
function()Services.TweenService:Create(body,TweenInfo.new(0.4,Enum.EasingStyle.
Bounce,Enum.EasingDirection.Out),{Position=UDim2.new()}):Play()end)up:Play()end
function Cat:Pet()if self.State=='hidden'then return end lastMove=os.clock()if
not self.Single then setState('happy')end busyUntil=os.clock()+1.5 hop()float(
'heart',0.3,18)task.delay(0.15,function()float('heart',0.68,15)end)task.delay(
0.3,function()float('sparkle',0.5,16)end)end function Cat:Sneeze()if self.State
~='awake'then return end setState('sneeze')busyUntil=os.clock()+0.9 body.
Rotation=-5 Services.TweenService:Create(body,TweenInfo.new(0.5,Enum.EasingStyle
.Elastic,Enum.EasingDirection.Out),{Rotation=0}):Play()end local function blink(
)for _,eye in ipairs(eyes)do local close=Services.TweenService:Create(eye.White,
TweenInfo.new(0.07),{Size=UDim2.fromOffset(20,2)})close.Completed:Once(function(
)Services.TweenService:Create(eye.White,TweenInfo.new(0.1),{Size=UDim2.
fromOffset(20,20)}):Play()end)close:Play()end end function Cat:SetActive(active)
self.Active=active if active and self.State~='hidden'and not self.Single then
lastMove=os.clock()setState('wave')busyUntil=os.clock()+1.6 end end function Cat
:SetVisible(visible)self.Hidden=visible==false holder.Visible=not self.Hidden
and self.State~='hidden'end Library:GiveSignal(holder.MouseButton1Click:Connect(
function()Cat:Pet()end))Library:GiveSignal(Services.RunService.RenderStepped:
Connect(function()if not Cat.Active or Cat.State=='hidden'or Cat.Hidden then
return end local now=os.clock()if Cat.Single then if now>nextZ then nextZ=now+
2.4 float('zzz',0.72,20)end return end local mouse=Util.Mouse()local moved=(
mouse-lastMouse).Magnitude>1 if moved then lastMouse,lastMove=mouse,now if Cat.
State=='sleep'then local centre=holder.AbsolutePosition+holder.AbsoluteSize/2 if
(mouse-centre).Magnitude<170 then setState('awake')hop()end end end if now<
busyUntil then return end local state=Cat.State if state~='awake'and state~=
'sleep'then setState('awake')state='awake'end if state=='awake'then if moved
then for _,eye in ipairs(eyes)do local white=eye.White local delta=mouse-(white.
AbsolutePosition+white.AbsoluteSize/2)local length=delta.Magnitude if length>0
then delta=delta/length*math.min(length/45,1)*3 end eye.Iris.Position=UDim2.new(
0.5,delta.X,0.5,delta.Y)end end if now-lastMove>NAP_AFTER then setState('sleep')
nextZ=now+0.4 elseif now>nextSneeze then nextSneeze=now+math.random(40,90)Cat:
Sneeze()elseif now>nextBlink then nextBlink=now+math.random(3,6)blink()end
elseif now>nextZ then nextZ=now+2.4 float('zzz',0.72,20)end end))task.spawn(
function()fx.heart=Assets.Get('cat/fx_heart.png')fx.sparkle=Assets.Get(
'cat/fx_sparkle.png')fx.zzz=Assets.Get('cat/fx_zzz.png')local drawn=Assets.Get(
'cat/cat_v2_sleep.png')if drawn then Cat.Single=true frames.sleep.Image=drawn
setState('sleep')holder.Visible=not Cat.Hidden return end local awake=Assets.
Get('cat/cat_awake.png')if not awake then return end frames.awake.Image=awake
for _,name in ipairs(STATES)do if name~='awake'then frames[name].Image=Assets.
Get('cat/cat_'..name..'.png')or awake end end burst.Image=Assets.Get(
'cat/cat_burst.png')or''fx.heart=Assets.Get('cat/fx_heart.png')fx.sparkle=Assets
.Get('cat/fx_sparkle.png')fx.zzz=Assets.Get('cat/fx_zzz.png')setState('awake')
holder.Visible=not Cat.Hidden if Cat.Active then Cat:SetActive(true)end end)
return Cat end end end function __DARKLUA_BUNDLE_MODULES.p()local v=
__DARKLUA_BUNDLE_MODULES.cache.p if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.p=v end return v.c end end do local function 
__modImpl()return function(Library)local Util=Library.Util local New=Util.New
local Services=Util.Services local Assets=Library.Assets local Layout={Columns={
},Boxes={},Data={tabs={},order={},moves={}}}Library.Layout=Layout local ICONS={
'star','heart','bolt','flame','fire','shield','target','ghost','crown','gift',
'rocket','leaf','map-point','compass','eye','user','users-group-rounded',
'settings','widget','folder','bookmark','flag','bell','gamepad','stars','home',
'cat','paw','bomb','magic-stick','cup-star','medal-star'}do local seen,rest={},{
}for _,name in ipairs(ICONS)do seen[name]=true end for name in pairs(Assets.
Filled.Icons)do if not seen[name]then table.insert(rest,name)end end table.sort(
rest)table.move(rest,1,#rest,#ICONS+1,ICONS)end local canFile=type(isfile)==
'function'and type(readfile)=='function'and type(writefile)=='function'local 
function path()return Library.LayoutFile or('CourageUI/layout_'..tostring(game.
GameId)..'.json')end function Layout.Load()if not canFile then return end pcall(
function()if not isfile(path())then return end local data=Services.HttpService:
JSONDecode(readfile(path()))if type(data)=='table'then Layout.Data={tabs=data.
tabs or{},order=data.order or{},moves=data.moves or{}}end end)end function
Layout.Save()local window,data=Library.Window,Layout.Data data.moves={}for key,
box in pairs(Layout.Boxes)do if box.Moved then data.moves[key]={column=box.
Column.Key,index=table.find(box.Column.Groupboxes,box)or 1}end end local tabs={}
for _,tab in ipairs(window.Tabs)do if not tab.IsFooter then table.insert(tabs,
tab)end end table.sort(tabs,function(a,b)return a.Button.LayoutOrder<b.Button.
LayoutOrder end)data.order={}for index,tab in ipairs(tabs)do data.order[index]=
tab.Key end if not canFile then return end pcall(function()local built=''local
parts=string.split(path(),'/')parts[#parts]=nil for _,part in ipairs(parts)do
built=built..part if not isfolder(built)then makefolder(built)end built=built..
'/'end writefile(path(),Services.HttpService:JSONEncode(data))end)end local 
function renumber(column)for index,box in ipairs(column.Groupboxes)do box.Frame.
LayoutOrder=index*2 end column.Order=#column.Groupboxes*2 if column.Owner then
column.Owner:RefreshEmpty()end end function Layout.Move(box,column,index)local
from=box.Column local at=table.find(from.Groupboxes,box)if at then table.remove(
from.Groupboxes,at)end table.insert(column.Groupboxes,math.clamp(index,1,#column
.Groupboxes+1),box)box.Column=column box.Frame.Parent=column.Frame renumber(from
)if column~=from then renumber(column)end end function Layout.RegisterColumn(
column)Layout.Columns[column.Key]=column end function Layout.RegisterBox(box)
local key=box.Column.Key..'|'..box.Name while Layout.Boxes[key]do key=key..'+'
end box.Key,box.Home=key,box.Column Layout.Boxes[key]=box Layout.Schedule()end
function Layout.Apply()local list={}for key,move in pairs(Layout.Data.moves)do
local box,column=Layout.Boxes[key],Layout.Columns[move.column]if box and column
and not box.Applied then table.insert(list,{box,column,tonumber(move.index)or 1}
)end end table.sort(list,function(a,b)return a[3]<b[3]end)for _,item in ipairs(
list)do item[1].Applied,item[1].Moved=true,true Layout.Move(item[1],item[2],item
[3])end local window,order=Library.Window,Layout.Data.order if window and#order>
0 then for _,tab in ipairs(window.Tabs)do if not tab.IsFooter then local index=
table.find(order,tab.Key)if index then tab.Button.LayoutOrder=index elseif tab.
Button.LayoutOrder<500 then tab.Button.LayoutOrder+=500 end end end end end
local pending=false function Layout.Schedule()if pending then return end pending
=true task.delay(0.25,function()pending=false if not Library.Unloaded then
Layout.Apply()end end)end function Layout.HeaderDrag(box)local start,dragging,
ghost,marker,target,targetIndex,last,stepper local function update(pointer)local
inset=Services.GuiService:GetGuiInset()ghost.Position=UDim2.fromOffset(pointer.X
+inset.X,pointer.Y+inset.Y)local window=Library.Window for _,tab in ipairs(
window.Tabs)do if tab~=window.ActiveTab and tab.Button.Visible and Util.Inside(
tab.Button,pointer)then tab:Show()end end local tab=window.ActiveTab for _,sub
in ipairs(tab.SubTabs)do if sub~=tab.ActiveSub and Util.Inside(sub.Button,
pointer)then sub:Show()end end local page=(tab.ActiveSub or tab).Page local
frame=page.Frame local column=pointer.X<frame.AbsolutePosition.X+frame.
AbsoluteSize.X/2 and page.Left or page.Right local index,before=1,nil for _,
other in ipairs(column.Groupboxes)do if other~=box then if other.Frame.Visible
and pointer.Y<other.Frame.AbsolutePosition.Y+other.Frame.AbsoluteSize.Y/2 then
before=other break end index+=1 end end target,targetIndex=column,index marker.
LayoutOrder=before and(before.Frame.LayoutOrder-1)or 100000 marker.Parent=column
.Frame end local function autoScroll(dt)local window=Library.Window local tab=
window.ActiveTab for _,scroll in ipairs({window.TabList,(tab.ActiveSub or tab).
Page.Frame})do local position,size=scroll.AbsolutePosition,scroll.AbsoluteSize
if last.X>=position.X and last.X<=position.X+size.X then local direction=0 if
last.Y<position.Y+46 and last.Y>position.Y-30 then direction=-1 elseif last.Y>
position.Y+size.Y-46 and last.Y<position.Y+size.Y+30 then direction=1 end if
direction~=0 then local limit=math.max(0,scroll.AbsoluteCanvasSize.Y-size.Y)/
Library.DPIScale local y=math.clamp(scroll.CanvasPosition.Y+direction*dt*520,0,
limit)if y~=scroll.CanvasPosition.Y then scroll.CanvasPosition=Vector2.new(0,y)
update(last)end end end end end Util.Drag(box.Header,function(pointer)start,
dragging,target=pointer,false,nil end,function(pointer)if not dragging then if(
pointer-start).Magnitude<8 then return end dragging=true Library:ClosePopup()
ghost=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(180,36
),BackgroundColor3='Main',ZIndex=150,Parent=Library.Overlay})New('UIScale',{
Scale=Library.DPIScale,Parent=ghost})Util.Corner(ghost,10)Util.Stroke(ghost,
'Accent',1.5)New('TextLabel',{Size=UDim2.new(1,-20,1,0),Position=UDim2.
fromOffset(10,0),BackgroundTransparency=1,Text=box.Name,FontFace='FontBold',
TextSize=13,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=151,Parent=ghost})marker
=New('Frame',{Name='DropMarker',Size=UDim2.new(1,0,0,3),BackgroundColor3=
'Accent'})Util.Corner(marker,2)box.Frame.BackgroundTransparency=0.6 stepper=
Services.RunService.RenderStepped:Connect(autoScroll)end last=pointer update(
pointer)end,function()if not dragging then return box:ToggleCollapsed()end if
stepper then stepper:Disconnect()end Util.Destroy(ghost)Util.Destroy(marker)box.
Frame.BackgroundTransparency=0 if not target then return end local from=box.
Column Layout.Move(box,target,targetIndex)for _,column in ipairs({from,target})
do for _,other in ipairs(column.Groupboxes)do if other.Key then other.Moved,
other.Applied=true,true end end end Layout.Save()end)end function Layout.TabDrag
(tab)local start,dragging Util.Drag(tab.Button,function(pointer)start,dragging=
pointer,false end,function(pointer)if not dragging then if math.abs(pointer.Y-
start.Y)<8 then return end dragging=true end local tabs={}for _,other in ipairs(
tab.Window.Tabs)do if other~=tab and not other.IsFooter then table.insert(tabs,
other)end end table.sort(tabs,function(a,b)return a.Button.LayoutOrder<b.Button.
LayoutOrder end)local index=1 for _,other in ipairs(tabs)do if other.Button.
Visible and pointer.Y>other.Button.AbsolutePosition.Y+other.Button.AbsoluteSize.
Y/2 then index+=1 end end table.insert(tabs,math.min(index,#tabs+1),tab)for
order,other in ipairs(tabs)do other.Button.LayoutOrder=order end end,function()
if dragging then Layout.Save()else tab:Show()end end)end local function trim(
text)return(string.gsub(text,'^%s*(.-)%s*$','%1'))end local function pagesOf(tab
)local pages={tab.Page}for _,sub in ipairs(tab.SubTabs)do table.insert(pages,sub
.Page)end return pages end function Layout.CreateCustom(entry)local window=
Library.Window local tab=window:AddTab({Name=entry.name,Icon=entry.icon or'star'
,Key='custom:'..tostring(entry.id),Custom=true})tab.Entry=entry tab.Button.
LayoutOrder=900 tab.EmptyLabel=New('TextLabel',{AnchorPoint=Vector2.new(0.5,0.5)
,Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(260,40),
BackgroundTransparency=1,Text='Drag Features here',FontFace='FontSemi',TextSize=
16,TextColor3='Dim',Parent=tab.Holder})local pencil=New('TextButton',{Name=
'Edit',AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-12,1,-12),Size=UDim2.
fromOffset(32,32),BackgroundColor3='Raised',ZIndex=5,Parent=tab.Holder})Util.
Corner(pencil,10)Util.Stroke(pencil,'Outline')local image=New('ImageLabel',{
AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.
fromOffset(15,15),BackgroundTransparency=1,ImageColor3='Text',ZIndex=6,Parent=
pencil})Assets.SetIcon(image,'pencil')Library:GiveSignal(pencil.
MouseButton1Click:Connect(function()Layout.Edit(tab)end))for _,name in ipairs(
entry.subs or{})do tab:AddSubTab(name)end tab:RefreshEmpty()return tab end local 
function deleteCustom(tab)local window=Library.Window for _,page in ipairs(
pagesOf(tab))do for _,column in ipairs({page.Left,page.Right})do for _,box in
ipairs(table.clone(column.Groupboxes))do if box.Home then Layout.Move(box,box.
Home,#box.Home.Groupboxes+1)end end Layout.Columns[column.Key]=nil end end local
at=table.find(window.Tabs,tab)if at then table.remove(window.Tabs,at)end at=
table.find(Layout.Data.tabs,tab.Entry)if at then table.remove(Layout.Data.tabs,
at)end if window.ActiveTab==tab then window.ActiveTab=nil for _,other in ipairs(
window.Tabs)do if not other.IsFooter then other:Show()break end end end Util.
Destroy(tab.Button)Util.Destroy(tab.Holder)Layout.Save()end function Layout.Edit
(tab)local window=Library.Window local entry=tab and tab.Entry or{name='',icon=
'star',subs={}}local icon=entry.icon or'star'local shade=New('TextButton',{Name=
'TabEditor',Size=UDim2.fromScale(1,1),BackgroundColor3='Black',
BackgroundTransparency=1,ZIndex=40,Parent=window.Main})Util.Corner(shade,16)
local card=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.
fromScale(0.5,0.5),Size=UDim2.fromOffset(340,0),AutomaticSize=Enum.AutomaticSize
.Y,BackgroundColor3='Main',ZIndex=41,Parent=shade})Util.Corner(card,14)Util.
Stroke(card,'Accent',1,0.4)Util.Pad(card,18,16)Util.List(card,8)local scale=New(
'UIScale',{Scale=0.9,Parent=card})local order=0 local function label(text,bold)
order+=1 return New('TextLabel',{Size=UDim2.new(1,0,0,bold and 22 or 16),
BackgroundTransparency=1,Text=text,FontFace=bold and'FontBold'or'Font',TextSize=
bold and 16 or 12,TextColor3=bold and'Text'or'Dim',TextXAlignment=Enum.
TextXAlignment.Left,LayoutOrder=order,ZIndex=42,Parent=card})end local function 
field(text,placeholder)order+=1 local frame=New('Frame',{Size=UDim2.new(1,0,0,30
),BackgroundColor3='Raised',LayoutOrder=order,ZIndex=42,Parent=card})Util.
Corner(frame,8)Util.Stroke(frame,'Outline',1,0.2)return New('TextBox',{Position=
UDim2.fromOffset(10,0),Size=UDim2.new(1,-20,1,0),BackgroundTransparency=1,Text=
text,PlaceholderText=placeholder,PlaceholderColor3='Dim',TextSize=13,
TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,ZIndex=43,Parent=
frame})end label(tab and'Edit tab'or'New tab',true)label('Name')local nameBox=
field(entry.name,'My tab')label('Sub tabs (optional, separated by commas)')local
subsBox=field(table.concat(entry.subs or{},', '),'Farm, Combat')label('Icon')
local iconSearch=field('','Search '..tostring(#ICONS)..' icons')order+=1 local
grid=New('ScrollingFrame',{Size=UDim2.new(1,0,0,152),BackgroundTransparency=1,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollBarThickness=2,ScrollBarImageColor3='Accent',ScrollingDirection=Enum.
ScrollingDirection.Y,LayoutOrder=order,ZIndex=42,Parent=card})New('UIGridLayout'
,{CellSize=UDim2.fromOffset(32,32),CellPadding=UDim2.fromOffset(5,6),SortOrder=
Enum.SortOrder.LayoutOrder,Parent=grid})local strokes={}local function fill()for
_,child in ipairs(grid:GetChildren())do if child:IsA('TextButton')then Util.
Destroy(child)end end table.clear(strokes)local query=string.lower(iconSearch.
Text)local shown=0 local function add(name)shown+=1 local button=New(
'TextButton',{BackgroundColor3='Raised',LayoutOrder=shown,ZIndex=43,Parent=grid}
)Util.Corner(button,8)strokes[name]=Util.Stroke(button,'Accent',1.5,name==icon
and 0 or 1)local image=New('ImageLabel',{AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(18,18),
BackgroundTransparency=1,ImageColor3='Text',ZIndex=44,Parent=button})Assets.
SetIcon(image,name)Library:AddTooltip(button,name)button.MouseButton1Click:
Connect(function()if strokes[icon]then strokes[icon].Transparency=1 end icon=
name strokes[icon].Transparency=0 end)end if query==''and Assets.Filled.Icons[
icon]then add(icon)end for _,name in ipairs(ICONS)do if shown>=160 then break
end if name~=icon or query~=''then if query==''or string.find(name,query,1,true)
then add(name)end end end end fill()iconSearch:GetPropertyChangedSignal('Text'):
Connect(fill)order+=1 local row=New('Frame',{Size=UDim2.new(1,0,0,34),
BackgroundTransparency=1,LayoutOrder=order,ZIndex=42,Parent=card})Util.List(row,
8,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Right,Enum.
VerticalAlignment.Bottom)local function dismiss()Util.Tween(scale,0.15,{Scale=
0.92})local tween=Util.Tween(shade,0.15,{BackgroundTransparency=1})if tween then
tween.Completed:Once(function()Util.Destroy(shade)end)else Util.Destroy(shade)
end end local function button(text,color,textColor,callback)local item=New(
'TextButton',{Size=UDim2.fromOffset(0,30),AutomaticSize=Enum.AutomaticSize.X,
BackgroundColor3=color,Text=text,FontFace='FontSemi',TextSize=13,TextColor3=
textColor,LayoutOrder=#row:GetChildren(),ZIndex=43,Parent=row})Util.Corner(item,
8)Util.Pad(item,14,0)item.MouseButton1Click:Connect(callback)end if tab then
button('Delete','Red','White',function()dismiss()deleteCustom(tab)end)end
button('Cancel','Raised','Text',dismiss)button('Save','Accent','White',function(
)local name=trim(nameBox.Text)if name==''then name='Custom'end local subs={}for
part in string.gmatch(subsBox.Text,'[^,]+')do part=trim(part)if part~=''and not
table.find(subs,part)then table.insert(subs,part)end end if tab then entry.name,
entry.icon=name,icon tab.Name=name Assets.SetIcon(tab.Icon,icon)entry.subs=entry
.subs or{}for _,sub in ipairs(subs)do if not table.find(entry.subs,sub)then tab:
AddSubTab(sub)table.insert(entry.subs,sub)end end else entry.id=tostring(os.
time())..tostring(math.random(100,999))entry.name,entry.icon,entry.subs=name,
icon,subs table.insert(Layout.Data.tabs,entry)tab=Layout.CreateCustom(entry)tab:
Show()end if#tab.SubTabs>0 then for _,side in ipairs({'Left','Right'})do for _,
box in ipairs(table.clone(tab.Page[side].Groupboxes))do local column=tab.SubTabs
[1].Page[side]Layout.Move(box,column,#column.Groupboxes+1)end end end tab:
RefreshEmpty()Layout.Save()dismiss()end)Util.Tween(shade,0.2,{
BackgroundTransparency=0.45})Util.Tween(scale,0.25,{Scale=1},Enum.EasingStyle.
Back)end function Layout.Start(window)Layout.Load()for _,entry in ipairs(Layout.
Data.tabs)do if type(entry)=='table'and entry.id then pcall(Layout.CreateCustom,
entry)end end local plus=New('TextButton',{Name='NewTab',Size=UDim2.fromOffset(
44,44),BackgroundColor3='Accent',BackgroundTransparency=1,LayoutOrder=1000000,
Parent=window.TabList})Util.Corner(plus,13)local dashed=Util.Stroke(plus,
'Outline',1.5,0)local bars={}for _,rotation in ipairs({0,90})do local bar=New(
'Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size
=UDim2.fromOffset(14,2),Rotation=rotation,BackgroundColor3='Dim',Parent=plus})
Util.Corner(bar,1)table.insert(bars,bar)end Library:AddTooltip(plus,'New tab')
Util.Hover(plus,function()Util.TweenTheme(dashed,0.15,{Color='Accent'})for _,bar
in ipairs(bars)do Util.TweenTheme(bar,0.15,{BackgroundColor3='Text'})end end,
function()Util.TweenTheme(dashed,0.15,{Color='Outline'})for _,bar in ipairs(bars
)do Util.TweenTheme(bar,0.15,{BackgroundColor3='Dim'})end end)Library:
GiveSignal(plus.MouseButton1Click:Connect(function()Layout.Edit(nil)end))end end
end function __DARKLUA_BUNDLE_MODULES.q()local v=__DARKLUA_BUNDLE_MODULES.cache.
q if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.q=v end return v
.c end end do local function __modImpl()return function(Library)local Util=
Library.Util local New=Util.New local ROW,MAX_ROWS,MAX_RESULTS=40,7,40 Library.
_Search=function(window,anchor,box)local popup local function close()if popup
then Util.Destroy(popup)popup=nil end if Library.Popup and Library.Popup.Owner==
window then Library.Popup=nil end end local function reveal(tab,sub,inner,group,
target)box.Text=''tab:Show()if sub and tab.ActiveSub~=sub then sub:Show()end if
inner then inner:Show()end if group.Collapsed then group:SetCollapsed(false,true
)end task.delay(0.05,function()if not target.Parent then return end local scroll
=(sub or tab).Page.Frame local offset=(target.AbsolutePosition.Y-scroll.
AbsolutePosition.Y)/Library.DPIScale+scroll.CanvasPosition.Y scroll.
CanvasPosition=Vector2.new(0,math.max(0,offset-70))local flash=New('Frame',{Size
=UDim2.fromScale(1,1),BackgroundColor3='Accent',BackgroundTransparency=0.55,
ZIndex=20,Parent=target})Util.Corner(flash,8)local tween=Util.Services.
TweenService:Create(flash,TweenInfo.new(1.4,Enum.EasingStyle.Quad),{
BackgroundTransparency=1})tween.Completed:Once(function()Util.Destroy(flash)end)
tween:Play()end)end local function collect(query)local results={}local function 
matches(text)return type(text)=='string'and text~=''and string.find(string.
lower(text),query,1,true)~=nil end for _,tab in ipairs(window.Tabs)do local
pages={{tab.Page}}for _,sub in ipairs(tab.SubTabs)do table.insert(pages,{sub.
Page,sub})end for _,entry in ipairs(pages)do local page,sub=entry[1],entry[2]
local where=tab.Name..(sub and(' / '..sub.Name)or'')for _,column in ipairs({page
.Left,page.Right})do for _,group in ipairs(column.Groupboxes)do local isTabbox=
group.Type=='Tabbox'if not isTabbox and matches(group.Name)then table.insert(
results,{group.Name,where,function()reveal(tab,sub,nil,group,group.Header)end})
end for _,container in ipairs(isTabbox and group.Tabs or{group})do local trail=
where..' / '..(container.Name or'')local function scan(holder)for _,element in
ipairs(holder.Elements)do if element.Type=='DependencyBox'then scan(element)
elseif element.Holder and element.Visible and matches(element.Text)then table.
insert(results,{element.Text,trail,function()reveal(tab,sub,isTabbox and
container or nil,group,element.Holder)end})end if#results>=MAX_RESULTS then
return end end end scan(container)if#results>=MAX_RESULTS then return results
end end end end end end return results end local function render()local query=
string.lower(box.Text)close()if query==''or not Library.Toggled then return end
Library:ClosePopup()local results=collect(query)local width=math.max(300,anchor.
AbsoluteSize.X/Library.DPIScale)local height=math.max(1,math.min(#results,
MAX_ROWS))*ROW+8 popup=New('Frame',{Name='SearchResults',Size=UDim2.fromOffset(
width,height),BackgroundColor3='Main',Parent=Library.Overlay})New('UIScale',{
Scale=Library.DPIScale,Parent=popup})Util.Corner(popup,10)Util.Stroke(popup,
'Outline')Util.PlacePopup(popup,anchor,width,height)local list=New(
'ScrollingFrame',{Position=UDim2.fromOffset(4,4),Size=UDim2.new(1,-8,1,-8),
BackgroundTransparency=1,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.
AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3='Accent',
ScrollingDirection=Enum.ScrollingDirection.Y,Parent=popup})Util.List(list,0)if#
results==0 then New('TextLabel',{Size=UDim2.new(1,0,0,ROW),
BackgroundTransparency=1,Text='Nothing found',TextColor3='Dim',TextSize=13,
Parent=list})end for index,result in ipairs(results)do local row=New(
'TextButton',{Size=UDim2.new(1,0,0,ROW),BackgroundColor3='Raised',
BackgroundTransparency=1,LayoutOrder=index,Parent=list})Util.Corner(row,7)New(
'TextLabel',{Position=UDim2.fromOffset(10,5),Size=UDim2.new(1,-20,0,16),
BackgroundTransparency=1,Text=result[1],FontFace='FontSemi',TextSize=13,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
Parent=row})New('TextLabel',{Position=UDim2.fromOffset(10,21),Size=UDim2.new(1,-
20,0,14),BackgroundTransparency=1,Text=result[2],TextSize=11,TextColor3='Dim',
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
Parent=row})row.MouseEnter:Connect(function()row.BackgroundTransparency=0.3 end)
row.MouseLeave:Connect(function()row.BackgroundTransparency=1 end)row.
MouseButton1Click:Connect(result[3])end Library.Popup={Owner=window,Frames={
popup,anchor},Close=close}end Library:GiveSignal(box:GetPropertyChangedSignal(
'Text'):Connect(render))Library:GiveSignal(box.Focused:Connect(render))end end
end function __DARKLUA_BUNDLE_MODULES.r()local v=__DARKLUA_BUNDLE_MODULES.cache.
r if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.r=v end return v
.c end end do local function __modImpl()return function(Library)local Util=
Library.Util local New=Util.New local Services=Util.Services local Assets=
Library.Assets local HEADER,SIDEBAR=58,64 local function after(tween,callback)if
tween then tween.Completed:Once(callback)else callback()end end local function 
newPage(parent,key,owner)local scroll=New('ScrollingFrame',{Name='Page',Size=
UDim2.fromScale(1,1),BackgroundTransparency=1,CanvasSize=UDim2.new(),
AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,
ScrollBarImageColor3='Accent',ScrollBarImageTransparency=0.35,ScrollingDirection
=Enum.ScrollingDirection.Y,Visible=false,Parent=parent})local inner=New('Frame',
{Position=UDim2.fromOffset(12,12),Size=UDim2.new(1,-24,0,0),AutomaticSize=Enum.
AutomaticSize.Y,BackgroundTransparency=1,Parent=scroll})New('UIPadding',{
PaddingBottom=UDim.new(0,24),Parent=inner})local function column(scale,offset)
local frame=New('Frame',{Position=UDim2.new(scale,offset,0,0),Size=UDim2.new(0.5
,-6,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=
inner})Util.List(frame,12)return{Frame=frame,Order=0,Groupboxes={},Owner=owner}
end local page={Frame=scroll,Left=column(0,0),Right=column(0.5,6)}page.Left.Key,
page.Right.Key=key..'|L',key..'|R'Library.Layout.RegisterColumn(page.Left)
Library.Layout.RegisterColumn(page.Right)return page end local PageMethods={}
function PageMethods:AddLeftGroupbox(name,icon)return Library._Groupbox(self.
Page.Left,name,icon)end function PageMethods:AddRightGroupbox(name,icon)return
Library._Groupbox(self.Page.Right,name,icon)end function PageMethods:AddGroupbox
(info)info=info or{}local side=info.Side==2 or info.Side=='Right'return Library.
_Groupbox(side and self.Page.Right or self.Page.Left,info.Name,info.IconName or
info.Icon)end function PageMethods:AddLeftTabbox(name)return Library._Tabbox(
self.Page.Left,name)end function PageMethods:AddRightTabbox(name)return Library.
_Tabbox(self.Page.Right,name)end function PageMethods:AddTabbox(info)info=info
or{}local side=info.Side==2 or info.Side=='Right'return Library._Tabbox(side and
self.Page.Right or self.Page.Left,info.Name)end function PageMethods:Resize()end
local SubTab=setmetatable({},{__index=PageMethods})SubTab.__index=SubTab
function SubTab:Show()local tab=self.Tab for _,sub in ipairs(tab.SubTabs)do
local active=sub==self sub.Page.Frame.Visible=active Util.TweenTheme(sub.Button,
0.18,{TextColor3=active and'Text'or'Dim'})Util.Tween(sub.Underline,0.18,{Size=
UDim2.new(active and 1 or 0,0,0,2)})end tab.ActiveSub=self tab.Window:Flash()
Library:ClosePopup()tab:RefreshEmpty()end local Tab=setmetatable({},{__index=
PageMethods})Tab.__index=Tab function Tab:_paint(active,instant)local time=
instant and 0 or 0.2 Util.Tween(self.Button,time,{BackgroundTransparency=active
and 0.86 or 1})Util.Tween(self.Bar,time,{Size=UDim2.fromOffset(3,active and 22
or 0)})if self.Icon then Util.TweenTheme(self.Icon,time,{ImageColor3=active and
'Text'or'Dim'})end if self.Letter then Util.TweenTheme(self.Letter,time,{
TextColor3=active and'Text'or'Dim'})end end function Tab:Show()local window=self
.Window if window.ActiveTab==self then return end Library:ClosePopup()local
previous=window.ActiveTab if previous then previous.Holder.Visible=false
previous:_paint(false)end window.ActiveTab=self Library.ActiveTab=self self:
_paint(true)self.Holder.Visible=true window:Flash()self:RefreshEmpty()end
function Tab:RefreshEmpty()if not self.EmptyLabel then return end local page=(
self.ActiveSub or self).Page self.EmptyLabel.Visible=#page.Left.Groupboxes+#page
.Right.Groupboxes==0 end function Tab:SetImage(image)if not self.Avatar then
self.Avatar=New('ImageLabel',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.
fromScale(0.5,0.5),Size=UDim2.fromOffset(30,30),BackgroundColor3='Raised',
ScaleType=Enum.ScaleType.Crop,Parent=self.Button})Util.Corner(self.Avatar,15)
Util.Stroke(self.Avatar,'Outline')end Assets.SetIcon(self.Avatar,image)if self.
Icon then self.Icon.Visible=false end if self.Letter then self.Letter.Visible=
false end end function Tab:AddSubTab(name,icon)name=Library.Translate(name or'')
if not self.SubBar then self.SubBar=New('Frame',{Name='SubTabs',Size=UDim2.new(1
,0,0,42),BackgroundTransparency=1,Parent=self.Holder})Util.List(self.SubBar,6,
Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Left,Enum.
VerticalAlignment.Center)New('UIPadding',{PaddingLeft=UDim.new(0,12),PaddingTop=
UDim.new(0,6),Parent=self.SubBar})self.SubBar.Visible=false self.Page.Frame.
Visible=false end if#self.SubTabs==1 then self.SubBar.Visible=true self.Pages.
Position=UDim2.fromOffset(0,38)self.Pages.Size=UDim2.new(1,0,1,-38)end local
button=New('TextButton',{Size=UDim2.fromOffset(0,26),AutomaticSize=Enum.
AutomaticSize.X,BackgroundColor3='AccentSoft',BackgroundTransparency=1,Text=name
,FontFace='FontSemi',TextSize=13,TextColor3='Dim',LayoutOrder=#self.SubTabs+1,
Parent=self.SubBar})Util.Pad(button,10,0)local underline=New('Frame',{
AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,2),Size=UDim2.new(0,0,
0,2),BackgroundColor3='Accent',Parent=button})Util.Corner(underline,1)local sub=
setmetatable({Type='SubTab',Name=name,Tab=self,Button=button,Underline=underline
,Page=newPage(self.Pages,self.Key..'/'..name,self)},SubTab)table.insert(self.
SubTabs,sub)Library:GiveSignal(button.MouseButton1Click:Connect(function()if
self.ActiveSub~=sub then sub:Show()end end))if#self.SubTabs==1 then self.
ActiveSub=sub sub.Page.Frame.Visible=true underline.Size=UDim2.new(1,0,0,2)Util.
Register(button,{TextColor3='Text'})end return sub end function Tab:SetOrder(
order)self.Order=order self.Button.LayoutOrder=order end function Tab:SetVisible
(visible)self.Button.Visible=visible~=false end function Tab:SetTooltip(text)
Library:AddTooltip(self.Button,text)end local Window={}Window.__index=Window
function Window:AddTab(a,b,c)local info=type(a)=='table'and a or{Name=a,Icon=b}
if type(c)=='table'then for key,value in pairs(c)do info[key]=value end end
local name=Library.Translate(info.Name or'Tab')local footer=info.Footer==true or
(info.Footer==nil and table.find(self.FooterTabs,info.Name)~=nil)self.TabCount+=
1 local button=New('TextButton',{Name=name,Size=UDim2.fromOffset(44,44),
BackgroundColor3='Accent',BackgroundTransparency=1,LayoutOrder=(footer and info.
Name=='Profile')and 0 or self.TabCount,Parent=footer and self.Footer or self.
TabList})Util.Corner(button,10)local bar=New('Frame',{Name='Bar',AnchorPoint=
Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(3,0),
BackgroundColor3='Accent',Parent=button})Util.Corner(bar,2)local tab=
setmetatable({Type='Tab',Name=name,Key=info.Key or name,IsFooter=footer,Window=
self,Button=button,Bar=bar,SubTabs={},Order=self.TabCount},Tab)if footer and(
info.Name=='UI Settings'or info.Name=='Settings')then info.Icon=
'settings-minimalistic'end if info.Icon and info.Icon~=''then local icon=21 tab.
Icon=New('ImageLabel',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.
fromScale(0.5,0.5),Size=UDim2.fromOffset(icon,icon),BackgroundTransparency=1,
ImageColor3='Dim',Parent=button})Assets.SetIcon(tab.Icon,info.Icon)else tab.
Letter=New('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=
string.upper(string.sub(name,1,1)),FontFace='FontBold',TextSize=17,TextColor3=
'Dim',Parent=button})end Library:AddTooltip(button,function()return info.
Description and(tab.Name..'\n'..info.Description)or tab.Name end)tab.Holder=New(
'Frame',{Name=name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=
false,Parent=self.Body})tab.Pages=New('Frame',{Name='Pages',Size=UDim2.
fromScale(1,1),BackgroundTransparency=1,Parent=tab.Holder})tab.Page=newPage(tab.
Pages,tab.Key,tab)tab.Page.Frame.Visible=true if footer then Library:GiveSignal(
button.MouseButton1Click:Connect(function()tab:Show()end))else Library.Layout.
TabDrag(tab)end Util.Hover(button,function()if self.ActiveTab~=tab then Util.
Tween(button,0.15,{BackgroundTransparency=0.92})end end,function()if self.
ActiveTab~=tab then Util.Tween(button,0.15,{BackgroundTransparency=1})end end)
table.insert(self.Tabs,tab)if not info.Custom then Library.Tabs[name]=tab end
Library.Layout.Schedule()if footer then self.FooterCount+=1 self:_layoutSidebar(
)end if not self.ActiveTab and not footer and not info.Custom then self.
ActiveTab=tab Library.ActiveTab=tab tab.Holder.Visible=true tab:_paint(true,true
)end return tab end function Window:ApplySearch()end function Window:
_layoutSidebar()local count=self.FooterCount local height=count>0 and(count*44+(
count-1)*8)or 0 self.Footer.Size=UDim2.new(1,0,0,height)self.Footer.Position=
UDim2.new(0,0,1,-(height+14))self.Divider.Visible=count>0 self.Divider.Position=
UDim2.new(0.5,0,1,-(height+24))self.TabList.Size=UDim2.new(1,0,1,count>0 and-(
height+34)or-8)end function Window:SetTitle(text)self.TitleLabel.Text=Library.
Translate(text or'')end Window.ChangeTitle=Window.SetTitle function Window:
SetFooter(text)self.FooterLabel.Text=Library.Translate(text or'')end function
Window:ShowTabs()end function Window:Toggle(visible)Library:Toggle(visible)end
function Window:AddDialog(_,info)info=info or{}local shade=New('TextButton',{
Name='Dialog',Size=UDim2.fromScale(1,1),BackgroundColor3='Black',
BackgroundTransparency=1,ZIndex=40,Parent=self.Main})Util.Corner(shade,16)local
card=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,
0.5),Size=UDim2.fromOffset(340,0),AutomaticSize=Enum.AutomaticSize.Y,
BackgroundColor3='Main',ZIndex=41,Parent=shade})Util.Corner(card,14)Util.Stroke(
card,'Accent',1,0.4)Util.Pad(card,18,16)Util.List(card,10)local scale=New(
'UIScale',{Scale=0.9,Parent=card})New('TextLabel',{Size=UDim2.new(1,0,0,20),
BackgroundTransparency=1,Text=Library.Translate(info.Title or''),FontFace=
'FontBold',TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=1,
ZIndex=42,Parent=card})New('TextLabel',{Size=UDim2.new(1,0,0,0),AutomaticSize=
Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=Library.Translate(info.
Description or''),TextColor3='Dim',TextSize=13,TextWrapped=true,TextXAlignment=
Enum.TextXAlignment.Left,LayoutOrder=2,ZIndex=42,Parent=card})local row=New(
'Frame',{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,LayoutOrder=3,ZIndex=
42,Parent=card})Util.List(row,8,Enum.FillDirection.Horizontal,Enum.
HorizontalAlignment.Right,Enum.VerticalAlignment.Center)local dialog={}function
dialog.Dismiss()if not shade.Parent then return end Util.Tween(scale,0.15,{Scale
=0.92})after(Util.Tween(shade,0.15,{BackgroundTransparency=1}),function()Util.
Destroy(shade)end)end dialog.Close=dialog.Dismiss local buttons={}for _,button
in pairs(info.FooterButtons or{})do table.insert(buttons,button)end table.sort(
buttons,function(a,b)return(a.Order or 0)<(b.Order or 0)end)if#buttons==0 then
buttons[1]={Title='OK'}end for index,data in ipairs(buttons)do local destructive
=data.Variant=='Destructive'local primary=data.Variant=='Primary'or destructive
local button=New('TextButton',{Size=UDim2.fromOffset(0,30),AutomaticSize=Enum.
AutomaticSize.X,BackgroundColor3=destructive and'Red'or(primary and'Accent'or
'Raised'),Text=Library.Translate(data.Title or'OK'),FontFace='FontSemi',TextSize
=13,TextColor3=primary and'White'or'Text',LayoutOrder=index,ZIndex=43,Parent=row
})Util.Corner(button,8)Util.Pad(button,14,0)button.MouseButton1Click:Connect(
function()if data.Callback then Util.Safe(data.Callback,dialog)else dialog.
Dismiss()end end)end Util.Tween(shade,0.2,{BackgroundTransparency=0.45})Util.
Tween(scale,0.25,{Scale=1},Enum.EasingStyle.Back)return dialog end function
Window:_animate(open)local root,cover=self.Root,self.Cover local blur=Library.
BlurEnabled and 12 or 0 if open then root.Visible=true cover.
BackgroundTransparency=0 Util.Tween(cover,0.22,{BackgroundTransparency=1},Enum.
EasingStyle.Sine)Util.Tween(Library.Dim,0.22,{BackgroundTransparency=Library.
DimEnabled and 0.5 or 1},Enum.EasingStyle.Sine)Util.Tween(Library.Tint,0.22,{
BackgroundTransparency=Library.DimEnabled and 0 or 1},Enum.EasingStyle.Sine)
Library.Blur.Size=blur else Library.Blur.Size=0 Util.Tween(Library.Dim,0.15,{
BackgroundTransparency=1},Enum.EasingStyle.Sine)Util.Tween(Library.Tint,0.15,{
BackgroundTransparency=1},Enum.EasingStyle.Sine)after(Util.Tween(cover,0.12,{
BackgroundTransparency=0},Enum.EasingStyle.Sine),function()if not Library.
Toggled then root.Visible=false end end)end end function Window:Flash()local
veil=self.Veil veil.BackgroundTransparency=0.25 Util.Tween(veil,0.2,{
BackgroundTransparency=1},Enum.EasingStyle.Sine)end function Library:IsOpen()
return self.Toggled end function Library:Toggle(visible)local window=self.Window
if not window then return end if visible==nil then visible=not self.Toggled end
visible=visible==true if visible==self.Toggled then return end self.Toggled=
visible self:ClosePopup()self:HideTooltip()window:_animate(visible)if self.Cat
then self.Cat:SetActive(visible)end self:RefreshPill()end local function 
glyphButton(parent,x,kind)local button=New('TextButton',{AnchorPoint=Vector2.
new(1,0.5),Position=UDim2.new(1,x,0.5,0),Size=UDim2.fromOffset(28,28),
BackgroundTransparency=1,Parent=parent})local bars={}for _,rotation in ipairs(
kind=='close'and{45,-45}or{0})do local bar=New('Frame',{AnchorPoint=Vector2.new(
0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(14,2),Rotation=
rotation,BackgroundColor3='Dim',Parent=button})Util.Corner(bar,1)table.insert(
bars,bar)end Util.Hover(button,function()for _,bar in ipairs(bars)do Util.
TweenTheme(bar,0.15,{BackgroundColor3=kind=='close'and'Red'or'Text'})end end,
function()for _,bar in ipairs(bars)do Util.TweenTheme(bar,0.15,{BackgroundColor3
='Dim'})end end)return button end function Library:CreateWindow(config)config=
config or{}local dpi=self.DPIScale local camera=Services.Workspace.CurrentCamera
local view=camera and camera.ViewportSize or Vector2.new(1280,720)local size=
config.Size or UDim2.fromOffset(720,600)local showCat=false local width=math.
min(size.X.Offset,math.floor((view.X-20)/dpi))local height=math.min(size.Y.
Offset,math.floor((view.Y-(showCat and 70 or 20))/dpi))if config.NotifySide then
self:SetNotifySide(config.NotifySide)end if config.ToggleKeybind then self.
ToggleKeybind=config.ToggleKeybind end local root=New('Frame',{Name='Window',
AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,showCat and 14 or
0),Size=UDim2.fromOffset(width,height),BackgroundTransparency=1,Visible=false,
Parent=self.Layer})local scale=New('UIScale',{Scale=dpi,Parent=root})for _,ring
in ipairs({{4,0.86},{9,0.94}})do local glow=New('Frame',{Name='Glow',Size=UDim2.
fromScale(1,1),BackgroundTransparency=1,Parent=root})Util.Corner(glow,16)Util.
Stroke(glow,'Accent',ring[1],ring[2])end local main=New('Frame',{Name='Main',
Size=UDim2.fromScale(1,1),BackgroundColor3='Background',Parent=root})Util.
Corner(main,16)local border=New('UIStroke',{Color=Color3.new(1,1,1),Thickness=
1.5,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=main})local light=New(
'UIGradient',{Parent=border})Util.Register(light,{Color=function(theme)return
ColorSequence.new({ColorSequenceKeypoint.new(0,theme.Outline),
ColorSequenceKeypoint.new(0.42,theme.Outline),ColorSequenceKeypoint.new(0.5,
theme.Accent:Lerp(Color3.new(1,1,1),0.35)),ColorSequenceKeypoint.new(0.58,theme.
Outline),ColorSequenceKeypoint.new(1,theme.Outline)})end})Services.TweenService:
Create(light,TweenInfo.new(6,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,
-1),{Rotation=360}):Play()local header=New('TextButton',{Name='Header',Size=
UDim2.new(1,0,0,HEADER),BackgroundTransparency=1,Parent=main})Util.Draggable(
root,header)local logo=New('ImageLabel',{Position=UDim2.fromOffset(9,6),Size=
UDim2.fromOffset(46,46),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,
Parent=header})local letter=New('TextLabel',{Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,Text='C',FontFace='FontBold',TextSize=34,TextColor3=
'Accent',Parent=logo})local icon=config.Icon if type(icon)~='string'or icon==''
or string.sub(icon,1,1)=='@'then icon='file:logo.png'end if type(icon)=='string'
and string.sub(icon,1,5)=='file:'then Assets.Apply(logo,string.sub(icon,6),
function(found)if found then letter.Visible=false end end)else Assets.SetIcon(
logo,icon)letter.Visible=false end local title=New('TextLabel',{Position=UDim2.
fromOffset(SIDEBAR+2,11),Size=UDim2.new(0.3,0,0,18),BackgroundTransparency=1,
Text=self.Translate(config.Title or'Courage Hub'),FontFace='FontBold',TextSize=
15,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
Parent=header})local footer=New('TextLabel',{Position=UDim2.fromOffset(SIDEBAR+2
,30),Size=UDim2.new(0.3,0,0,14),BackgroundTransparency=1,Text=self.Translate(
config.Footer or''),TextSize=12,TextColor3='Dim',TextXAlignment=Enum.
TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=header})local
close=glyphButton(header,-12,'close')local minimize=glyphButton(header,-42,
'minimize')local search=New('Frame',{Name='Search',AnchorPoint=Vector2.new(1,0.5
),Position=UDim2.new(1,-82,0.5,0),Size=UDim2.fromOffset(math.min(200,width*0.28)
,30),BackgroundColor3='Inset',BackgroundTransparency=0.25,Parent=header})Util.
Corner(search,9)local searchStroke=Util.Stroke(search,'Outline',1,0.1)local
glass=New('ImageLabel',{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,9,
0.5,0),Size=UDim2.fromOffset(14,14),BackgroundTransparency=1,ImageColor3='Dim',
Parent=search})Assets.SetIcon(glass,'search')local hint=self.IsMobile and 0 or
50 local searchBox=New('TextBox',{Position=UDim2.fromOffset(30,0),Size=UDim2.
new(1,-36-hint,1,0),BackgroundTransparency=1,PlaceholderText='Search...',
PlaceholderColor3='Dim',Text='',TextSize=13,ClearTextOnFocus=false,
TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,Parent=search})if
not self.IsMobile then local chip=New('TextLabel',{AnchorPoint=Vector2.new(1,0.5
),Position=UDim2.new(1,-5,0.5,0),Size=UDim2.fromOffset(46,20),BackgroundColor3=
'Raised',Text='Ctrl + K',TextSize=11,TextColor3='Dim',Parent=search})Util.
Corner(chip,5)end local sidebar=New('Frame',{Name='Sidebar',Position=UDim2.
fromOffset(0,HEADER),Size=UDim2.new(0,SIDEBAR,1,-HEADER),BackgroundTransparency=
1,Parent=main})local tabList=New('ScrollingFrame',{Name='Tabs',Size=UDim2.new(1,
0,1,-62),BackgroundTransparency=1,CanvasSize=UDim2.new(),AutomaticCanvasSize=
Enum.AutomaticSize.Y,ScrollBarThickness=0,ScrollingDirection=Enum.
ScrollingDirection.Y,Parent=sidebar})Util.List(tabList,8,nil,Enum.
HorizontalAlignment.Center)New('UIPadding',{PaddingTop=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),Parent=tabList})local divider=New('Frame',{Name=
'Divider',AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,1,-56),Size=
UDim2.fromOffset(34,1),BackgroundColor3='Outline',Visible=false,Parent=sidebar})
local footerRow=New('Frame',{Name='Footer',Position=UDim2.new(0,0,1,-50),Size=
UDim2.new(1,0,0,0),BackgroundTransparency=1,Parent=sidebar})Util.List(footerRow,
8,nil,Enum.HorizontalAlignment.Center)local body=New('Frame',{Name='Body',
Position=UDim2.fromOffset(SIDEBAR,HEADER),Size=UDim2.new(1,-SIDEBAR,1,-HEADER),
BackgroundColor3='Inset',ClipsDescendants=true,Parent=main})Util.Corner(body,16)
for _,spot in ipairs({{0,0},{1,0},{0,1}})do New('Frame',{Name='Square',
AnchorPoint=Vector2.new(spot[1],spot[2]),Position=UDim2.fromScale(spot[1],spot[2
]),Size=UDim2.fromOffset(16,16),BackgroundColor3='Inset',Parent=body})end New(
'Frame',{Name='TopLine',Size=UDim2.new(1,0,0,1),BackgroundColor3='Outline',
BackgroundTransparency=0.15,ZIndex=20,Parent=body})New('Frame',{Name='LeftLine',
Size=UDim2.new(0,1,1,0),BackgroundColor3='Outline',BackgroundTransparency=0.15,
ZIndex=20,Parent=body})local motes=New('Frame',{Name='Motes',Size=UDim2.
fromScale(1,1),BackgroundTransparency=1,Parent=body})local random=Random.new(11)
for _=1,14 do local size=random:NextInteger(2,4)local x,y=random:NextNumber(0.03
,0.97),random:NextNumber(0.15,1)local mote=New('Frame',{Position=UDim2.
fromScale(x,y),Size=UDim2.fromOffset(size,size),BackgroundColor3='Accent',
BackgroundTransparency=random:NextNumber(0.35,0.7),Parent=motes})Util.Corner(
mote,2)Services.TweenService:Create(mote,TweenInfo.new(random:NextNumber(7,15),
Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Position=UDim2.
fromScale(x+random:NextNumber(-6E-2,0.06),y-random:NextNumber(0.12,0.3)),
BackgroundTransparency=0.95}):Play()end local veil=New('Frame',{Name='Veil',Size
=UDim2.fromScale(1,1),BackgroundColor3='Inset',BackgroundTransparency=1,ZIndex=
30,Parent=body})Util.Corner(veil,16)local cover=New('Frame',{Name='Cover',Size=
UDim2.fromScale(1,1),BackgroundColor3='Background',BackgroundTransparency=1,
ZIndex=60,Parent=main})Util.Corner(cover,16)local window=setmetatable({Root=root
,Scale=scale,Main=main,Header=header,Body=body,TabList=tabList,Veil=veil,Footer=
footerRow,Divider=divider,FooterCount=0,Cover=cover,SearchBox=searchBox,
TitleLabel=title,FooterLabel=footer,Tabs={},TabCount=0,FooterTabs=config.
FooterTabs or{'UI Settings','Settings','Profile'}},Window)self.Window=window
self._Search(window,search,searchBox)self.Layout.Start(window)self:GiveSignal(
searchBox.Focused:Connect(function()Util.TweenTheme(searchStroke,0.15,{Color=
'Accent'})end))self:GiveSignal(searchBox.FocusLost:Connect(function()Util.
TweenTheme(searchStroke,0.15,{Color='Outline'})end))self:GiveSignal(Services.
UserInputService.InputBegan:Connect(function(input)if input.KeyCode==Enum.
KeyCode.K and self.Toggled and(Services.UserInputService:IsKeyDown(Enum.KeyCode.
LeftControl)or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightControl))
then task.defer(function()searchBox:CaptureFocus()end)end end))self:GiveSignal(
minimize.MouseButton1Click:Connect(function()self:Toggle(false)if not self.
IsMobile and not self.MinimizeHintShown then self.MinimizeHintShown=true local
key=self.ToggleKeybind if type(key)=='table'then key=key.Value elseif typeof(key
)=='EnumItem'then key=key.Name end self:Notify({Title='Hidden',Description=
'Press '..tostring(self:GetKeyString(key or'RightShift'))..
' to show the menu again.',Time=4})end end))self:GiveSignal(close.
MouseButton1Click:Connect(function()window:AddDialog('Unload',{Title='Close '..
title.Text..'?',Description='This unloads the script and removes the menu.',
FooterButtons={Cancel={Title='Cancel',Order=1},Unload={Title='Unload',Variant=
'Destructive',Order=2,Callback=function()self:Unload()end}}})end))self:
GiveSignal(Services.UserInputService.InputBegan:Connect(function(input)if not
Util.IsClick(input)or not self.Toggled or not self.ClickRipple then return end
local point=Util.InputPos(input)if not Util.Inside(root,point)then return end
local inset=Services.GuiService:GetGuiInset()local ripple=Instance.new('Frame')
ripple.AnchorPoint=Vector2.new(0.5,0.5)ripple.Position=UDim2.fromOffset(point.X+
inset.X,point.Y+inset.Y)ripple.Size=UDim2.fromOffset(6,6)ripple.BackgroundColor3
=self.Theme.Text ripple.BackgroundTransparency=0.72 ripple.BorderSizePixel=0
ripple.ZIndex=200 Instance.new('UICorner',ripple).CornerRadius=UDim.new(1,0)
ripple.Parent=self.Overlay local size=46*self.DPIScale local tween=Services.
TweenService:Create(ripple,TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.
EasingDirection.Out),{Size=UDim2.fromOffset(size,size),BackgroundTransparency=1}
)tween.Completed:Once(function()ripple:Destroy()end)tween:Play()end))if config.
Resizable~=false then local grip=New('TextButton',{Name='Resize',AnchorPoint=
Vector2.new(1,1),Position=UDim2.fromScale(1,1),Size=UDim2.fromOffset(16,16),
BackgroundTransparency=1,ZIndex=5,Parent=main})local startPointer,startSize Util
.Drag(grip,function(pointer)startPointer,startSize=pointer,root.Size end,
function(pointer)local delta=(pointer-startPointer)/dpi root.Size=UDim2.
fromOffset(math.max(480,startSize.X.Offset+delta.X*2),math.max(360,startSize.Y.
Offset+delta.Y*2))end)end self.Toggled=false if config.AutoShow~=false then self
:Toggle(true)end return window end end end function __DARKLUA_BUNDLE_MODULES.s()
local v=__DARKLUA_BUNDLE_MODULES.cache.s if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.s=v end return v.c end end do local function 
__modImpl()local HttpService=game:GetService('HttpService')local ThemeManager={
Folder='CourageUI',Library=nil}local COLORS={{'BackgroundColor','Background'},{
'MainColor','Panels'},{'AccentColor','Accent'},{'OutlineColor','Outline'},{
'FontColor','Text'}}local canFile=type(isfile)=='function'and type(readfile)==
'function'and type(writefile)=='function'and type(isfolder)=='function'and type(
makefolder)=='function'and type(listfiles)=='function'function ThemeManager:
SetLibrary(library)self.Library=library end function ThemeManager:SetFolder(
folder)self.Folder=folder self:BuildFolderTree()end function ThemeManager:
BuildFolderTree()if not canFile then return end pcall(function()if not isfolder(
self.Folder)then makefolder(self.Folder)end if not isfolder(self.Folder..
'/themes')then makefolder(self.Folder..'/themes')end end)end function
ThemeManager:GetCustomTheme(name)if not canFile then return nil end local path=
self.Folder..'/themes/'..name..'.json'local ok,data=pcall(function()return
HttpService:JSONDecode(readfile(path))end)if not ok or type(data)~='table'then
return nil end local theme={}for key,value in pairs(data)do if key=='FontName'
then theme.FontName=value else local parsed,color=pcall(Color3.fromHex,value)if
parsed then theme[key]=color end end end return theme end function ThemeManager:
ReloadCustomThemes()local list={}if not canFile then return list end pcall(
function()for _,file in ipairs(listfiles(self.Folder..'/themes'))do local name=
string.match(file,'([^/\\]+)%.json$')if name then table.insert(list,name)end end
end)table.sort(list)return list end function ThemeManager:ApplyTheme(name)local
library=self.Library local theme=library.Themes[name]or self:GetCustomTheme(name
)if not theme then return false end for key,value in pairs(theme)do library.
Scheme[key]=value end self.Applying=true for _,entry in ipairs(COLORS)do local
option=library.Options[entry[1] ]if option then option:SetValueRGB(library.
Scheme[entry[1] ])end end self.Applying=false library:UpdateColorsUsingRegistry(
)return true end function ThemeManager:ThemeUpdate()if self.Applying then return
end local library=self.Library for _,entry in ipairs(COLORS)do local option=
library.Options[entry[1] ]if option then library.Scheme[entry[1] ]=option.Value
end end library:UpdateColorsUsingRegistry()end function ThemeManager:
SaveCustomTheme(name)if not canFile or type(name)~='string'or string.gsub(name,
'%s','')==''then return false end self:BuildFolderTree()local data={FontName=
self.Library.Scheme.FontName}for _,entry in ipairs(COLORS)do data[entry[1] ]=
self.Library.Scheme[entry[1] ]:ToHex()end return pcall(writefile,self.Folder..
'/themes/'..name..'.json',HttpService:JSONEncode(data))end function ThemeManager
:SaveDefault(name)if not canFile then return end self:BuildFolderTree()pcall(
writefile,self.Folder..'/themes/default.txt',name)end function ThemeManager:
LoadDefault()local name='Courage'if canFile then pcall(function()local path=self
.Folder..'/themes/default.txt'if isfile(path)then name=readfile(path)end end)end
if not self:ApplyTheme(name)then self:ApplyTheme('Courage')end return name end
function ThemeManager:CreateThemeManager(groupbox)local library=self.Library for
_,entry in ipairs(COLORS)do groupbox:AddLabel(entry[2]..' color'):
AddColorPicker(entry[1],{Default=library.Scheme[entry[1] ],Callback=function()
self:ThemeUpdate()end})end local fonts={}for name in pairs(library.FontFamilies)
do table.insert(fonts,name)end table.sort(fonts)groupbox:AddDropdown(
'ThemeManager_Font',{Text='Font',Values=fonts,Default=library.Scheme.FontName,
Callback=function(font)if font then library.Scheme.FontName=font library:
UpdateColorsUsingRegistry()end end})groupbox:AddDivider()groupbox:AddDropdown(
'ThemeManager_ThemeList',{Text='Theme',Values=library.ThemeOrder,Default=
'Courage',Callback=function(name)if name then self:ApplyTheme(name)end end})
groupbox:AddButton('Set as default',function()local name=library.Options.
ThemeManager_ThemeList.Value if name then self:SaveDefault(name)library:Notify({
Title='Themes',Description='Default theme set to '..name..'.'})end end)groupbox:
AddDivider()groupbox:AddInput('ThemeManager_CustomThemeName',{Text=
'Custom theme',Placeholder='Name'})groupbox:AddDropdown(
'ThemeManager_CustomThemeList',{Text='Saved themes',Values=self:
ReloadCustomThemes(),AllowNull=true})groupbox:AddButton('Save',function()local
name=library.Options.ThemeManager_CustomThemeName.Value if self:SaveCustomTheme(
name)then library.Options.ThemeManager_CustomThemeList:SetValues(self:
ReloadCustomThemes())library:Notify({Title='Themes',Description='Saved theme '..
name..'.'})else library:Notify({Title='Themes',Description='Type a name first.'}
)end end):AddButton('Load',function()local name=library.Options.
ThemeManager_CustomThemeList.Value if name and self:ApplyTheme(name)then self:
SaveDefault(name)end end)self:LoadDefault()end function ThemeManager:
CreateMenuSettings(groupbox)local library=self.Library groupbox:AddLabel(
'Menu key'):AddKeyPicker('MenuKeybind',{Default='RightShift',NoUI=true,Text=
'Menu key'})library.ToggleKeybind=library.Options.MenuKeybind groupbox:
AddToggle('Menu_Blur',{Text='Background blur',Default=library.BlurEnabled,
Callback=function(on)library:SetBlur(on)end})groupbox:AddToggle('Menu_Dim',{Text
='Dim the game',Default=library.DimEnabled,Callback=function(on)library:SetDim(
on)end})groupbox:AddToggle('Menu_Animations',{Text='Animations',Default=library.
Animations,Callback=function(on)library.Animations=on end})groupbox:AddToggle(
'Menu_Watermark',{Text='Watermark',Default=false,Callback=function(on)library:
SetWatermarkVisibility(on)end})groupbox:AddToggle('Menu_Keybinds',{Text=
'Keybind list',Default=false,Callback=function(on)library:SetKeybindMenuVisible(
on)end})groupbox:AddToggle('Menu_Cat',{Text='Show the cat',Default=true,Callback
=function(on)if library.Cat then library.Cat:SetVisible(on)end end})groupbox:
AddDropdown('Menu_Scale',{Text='UI scale',Values={'75%','90%','100%','110%',
'125%'},Default='100%',Callback=function(value)if value then library:
SetDPIScale(tonumber((string.gsub(value,'%%',''))))end end})groupbox:AddButton({
Text='Unload',Risky=true,DoubleClick=true,Func=function()library:Unload()end})
end function ThemeManager:ApplyToGroupbox(groupbox)self:BuildFolderTree()self:
CreateThemeManager(groupbox)end function ThemeManager:ApplyToTab(tab)local
groupbox=tab:AddLeftGroupbox('Themes','palette')self:ApplyToGroupbox(groupbox)
return groupbox end return ThemeManager end function __DARKLUA_BUNDLE_MODULES.t(
)local v=__DARKLUA_BUNDLE_MODULES.cache.t if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.t=v end return v.c end end do local function 
__modImpl()local HttpService=game:GetService('HttpService')local SaveManager={
Folder='CourageUI',SubFolder='',Ignore={},Library=nil}local canFile=type(isfile)
=='function'and type(readfile)=='function'and type(writefile)=='function'and
type(isfolder)=='function'and type(makefolder)=='function'and type(listfiles)==
'function'local Parser={Toggle={Save=function(object)return{value=object.Value}
end,Load=function(object,data)object:SetValue(data.value==true)end},Slider={Save
=function(object)return{value=object.Value}end,Load=function(object,data)object:
SetValue(data.value)end},Dropdown={Save=function(object)if object.Multi then
local list={}for value in pairs(object.Value)do table.insert(list,value)end
return{value=list,multi=true}end return{value=object.Value}end,Load=function(
object,data)object:SetValue(data.value)end},Input={Save=function(object)return{
value=object.Value}end,Load=function(object,data)if type(data.value)=='string'
then object:SetValue(data.value)end end},KeyPicker={Save=function(object)return{
key=object.Value,mode=object.Mode}end,Load=function(object,data)object:SetValue(
{data.key,data.mode})end},ColorPicker={Save=function(object)return{value=object.
Value:ToHex(),transparency=object.Transparency}end,Load=function(object,data)
local ok,color=pcall(Color3.fromHex,data.value)if ok then object:SetValueRGB(
color,data.transparency)end end}}function SaveManager:SetLibrary(library)self.
Library=library end function SaveManager:SetFolder(folder)self.Folder=folder
self:BuildFolderTree()end function SaveManager:SetSubFolder(folder)self.
SubFolder=folder or''self:BuildFolderTree()end function SaveManager:
SetIgnoreIndexes(list)for _,idx in ipairs(list)do self.Ignore[idx]=true end end
function SaveManager:IgnoreThemeSettings()self:SetIgnoreIndexes({
'BackgroundColor','MainColor','AccentColor','OutlineColor','FontColor',
'ThemeManager_Font','ThemeManager_ThemeList','ThemeManager_CustomThemeList',
'ThemeManager_CustomThemeName'})end function SaveManager:Path()local path=self.
Folder..'/settings'if self.SubFolder~=''then path=path..'/'..self.SubFolder end
return path end function SaveManager:BuildFolderTree()if not canFile then return
end pcall(function()local built=''for _,part in ipairs(string.split(self:Path(),
'/'))do built=built==''and part or(built..'/'..part)if not isfolder(built)then
makefolder(built)end end end)end function SaveManager:Save(name)if not canFile
then return false,'this executor has no file functions'end if type(name)~=
'string'or string.gsub(name,'%s','')==''then return false,'no config name'end
local library=self.Library local data={objects={}}for _,group in ipairs({library
.Toggles,library.Options})do for idx,object in pairs(group)do local parser=
Parser[object.Type]if parser and not self.Ignore[idx]then local entry=parser.
Save(object)entry.type,entry.idx=object.Type,idx table.insert(data.objects,entry
)end end end self:BuildFolderTree()local ok,reason=pcall(function()writefile(
self:Path()..'/'..name..'.json',HttpService:JSONEncode(data))end)if not ok then
return false,tostring(reason)end return true end function SaveManager:Load(name)
if not canFile then return false,'this executor has no file functions'end if
type(name)~='string'or name==''then return false,'no config selected'end local
path=self:Path()..'/'..name..'.json'local ok,data=pcall(function()return
HttpService:JSONDecode(readfile(path))end)if not ok or type(data)~='table'or
type(data.objects)~='table'then return false,'the config file could not be read'
end local library=self.Library for _,entry in ipairs(data.objects)do local
object=(entry.type=='Toggle'and library.Toggles or library.Options)[entry.idx]
local parser=Parser[entry.type]if object and parser and object.Type==entry.type
and not self.Ignore[entry.idx]then task.spawn(function()pcall(parser.Load,object
,entry)end)end end return true end function SaveManager:Delete(name)if not
canFile or type(delfile)~='function'then return false,
'this executor cannot delete files'end if type(name)~='string'or name==''then
return false,'no config selected'end local ok,reason=pcall(delfile,self:Path()..
'/'..name..'.json')if not ok then return false,tostring(reason)end return true
end function SaveManager:RefreshConfigList()local list={}if not canFile then
return list end self:BuildFolderTree()pcall(function()for _,file in ipairs(
listfiles(self:Path()))do local name=string.match(file,'([^/\\]+)%.json$')if
name then table.insert(list,name)end end end)table.sort(list)return list end
function SaveManager:GetAutoloadConfig()if not canFile then return nil end local
ok,name=pcall(function()local path=self:Path()..'/autoload.txt'return isfile(
path)and readfile(path)or nil end)if ok and name~=''then return name end return
nil end function SaveManager:SaveAutoloadConfig(name)if not canFile then return
false end self:BuildFolderTree()return pcall(writefile,self:Path()..
'/autoload.txt',name or'')end function SaveManager:LoadAutoloadConfig()local
name=self:GetAutoloadConfig()if not name then return end local ok,reason=self:
Load(name)if ok then self.Library:Notify({Title='Configs',Description=
'Loaded autoload config '..name..'.'})else self.Library:Notify({Title='Configs',
Description='Autoload failed: '..tostring(reason)})end end function SaveManager:
BuildConfigSection(tab)local library=self.Library local box=tab:
AddRightGroupbox('Configuration','save')local function say(text)library:Notify({
Title='Configs',Description=text})end local function selected()return library.
Options.SaveManager_ConfigList.Value end local function refresh()library.Options
.SaveManager_ConfigList:SetValues(self:RefreshConfigList())end box:AddInput(
'SaveManager_ConfigName',{Text='Config name',Placeholder='Name'})box:AddButton(
'Create config',function()local name=library.Options.SaveManager_ConfigName.
Value local ok,reason=self:Save(name)if not ok then return say(
'Could not create it: '..tostring(reason))end refresh()library.Options.
SaveManager_ConfigList:SetValue(name)say('Created config '..name..'.')end)box:
AddDivider()box:AddDropdown('SaveManager_ConfigList',{Text='Configs',Values=self
:RefreshConfigList(),AllowNull=true})box:AddButton('Load',function()local ok,
reason=self:Load(selected())say(ok and('Loaded config '..selected()..'.')or(
'Could not load it: '..tostring(reason)))end):AddButton('Overwrite',function()
local ok,reason=self:Save(selected())say(ok and('Saved config '..selected()..'.'
)or('Could not save it: '..tostring(reason)))end)box:AddButton({Text='Delete',
Style='Secondary',DoubleClick=true,Func=function()local name=selected()local ok,
reason=self:Delete(name)if ok then if self:GetAutoloadConfig()==name then self:
SaveAutoloadConfig('')end refresh()end say(ok and('Deleted config '..name..'.')
or('Could not delete it: '..tostring(reason)))end}):AddButton({Text='Refresh',
Style='Secondary',Func=refresh})local autoload=box:AddLabel('Autoload: '..(self:
GetAutoloadConfig()or'none'),true)box:AddButton('Set as autoload',function()
local name=selected()if not name then return say('Pick a config first.')end self
:SaveAutoloadConfig(name)autoload:SetText('Autoload: '..name)say(name..
' now loads on start.')end):AddButton({Text='Clear',Style='Secondary',Func=
function()self:SaveAutoloadConfig('')autoload:SetText('Autoload: none')end})self
:SetIgnoreIndexes({'SaveManager_ConfigList','SaveManager_ConfigName'})return box
end return SaveManager end function __DARKLUA_BUNDLE_MODULES.u()local v=
__DARKLUA_BUNDLE_MODULES.cache.u if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.u=v end return v.c end end end local Util=
__DARKLUA_BUNDLE_MODULES.a()local env=type(getgenv)=='function'and getgenv()or
_G if type(env.CourageUI)=='table'and type(env.CourageUI.Unload)=='function'then
pcall(env.CourageUI.Unload,env.CourageUI)end local Services=Util.Services local
Library={Version='2.0.0',Options={},Toggles={},Tabs={},Registry={},
ThemeListeners={},Signals={},UnloadCallbacks={},DependencyBoxes={},Groupboxes={}
,KeyPickers={},ScaleObjects={},Elements={},Animations=true,BlurEnabled=true,
DimEnabled=true,WatermarkStats=true,ShowToggleButton=true,ClickRipple=true,
NotifySide='Right',ToggleKeybind=Enum.KeyCode.RightShift,Toggled=false,Unloaded=
false,Debug=false,Translate=function(text)return text end,Util=Util}Util.Library
=Library local UserInputService=Services.UserInputService Library.IsMobile=
UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled do local
camera=Services.Workspace.CurrentCamera local view=camera and camera.
ViewportSize or Vector2.new(1280,720)Library.DPIScale=Library.IsMobile and math.
clamp(view.Y/560,0.6,1)or 1 end function Library:GiveSignal(connection)table.
insert(self.Signals,connection)return connection end function Library:OnUnload(
callback)table.insert(self.UnloadCallbacks,callback)end function Library:
SetTabAccentEnabled()end function Library:SafeCallback(callback,...)Util.Safe(
callback,...)end local install1=__DARKLUA_BUNDLE_MODULES.b()install1(Library)
Library:UpdateColorsUsingRegistry()local parent=Services.CoreGui if type(gethui)
=='function'then local ok,hidden=pcall(gethui)if ok and hidden then parent=
hidden end end for _,name in ipairs({'CourageUI'})do local old=parent:
FindFirstChild(name)if old then old:Destroy()end end local oldBlur=Services.
Lighting:FindFirstChild('CourageUIBlur')if oldBlur then oldBlur:Destroy()end
local New=Util.New local gui=New('ScreenGui',{Name='CourageUI',IgnoreGuiInset=
true,ResetOnSpawn=false,DisplayOrder=999990,ZIndexBehavior=Enum.ZIndexBehavior.
Sibling,Parent=parent})Library.ScreenGui=gui Library.Dim=New('Frame',{Name='Dim'
,Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,ZIndex=1,Parent=gui})Library.Tint=New('Frame',{Name=
'Tint',AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1),Size=UDim2.
fromScale(1,0.6),BackgroundColor3='Accent',BackgroundTransparency=1,Parent=
Library.Dim})New('UIGradient',{Rotation=90,Transparency=NumberSequence.new(1,
0.82),Parent=Library.Tint})Library.Hud=New('Frame',{Name='Hud',Size=UDim2.
fromScale(1,1),BackgroundTransparency=1,ZIndex=3,Parent=gui})Library.Layer=New(
'Frame',{Name='Windows',Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
ZIndex=2,Parent=gui})Library.Overlay=New('Frame',{Name='Overlay',Size=UDim2.
fromScale(1,1),BackgroundTransparency=1,ZIndex=4,Parent=gui})Library.Blur=New(
'BlurEffect',{Name='CourageUIBlur',Size=0,Parent=Services.Lighting})local
install2=__DARKLUA_BUNDLE_MODULES.d()install2(Library)local install3=
__DARKLUA_BUNDLE_MODULES.e()install3(Library)local Base=(
__DARKLUA_BUNDLE_MODULES.f())(Library)Library.Elements.Toggle=(
__DARKLUA_BUNDLE_MODULES.g())(Library,Base)Library.Elements.Button=(
__DARKLUA_BUNDLE_MODULES.h())(Library,Base)Library.Elements.Label,Library.
Elements.Divider=(__DARKLUA_BUNDLE_MODULES.i())(Library,Base)Library.Elements.
Slider=(__DARKLUA_BUNDLE_MODULES.j())(Library,Base)Library.Elements.Dropdown=(
__DARKLUA_BUNDLE_MODULES.k())(Library,Base)Library.Elements.Input=(
__DARKLUA_BUNDLE_MODULES.l())(Library,Base)Library.Elements.KeyPicker=(
__DARKLUA_BUNDLE_MODULES.m())(Library,Base)Library.Elements.ColorPicker=(
__DARKLUA_BUNDLE_MODULES.n())(Library,Base)local install4=
__DARKLUA_BUNDLE_MODULES.o()install4(Library)local install5=
__DARKLUA_BUNDLE_MODULES.p()install5(Library)local installLayout=
__DARKLUA_BUNDLE_MODULES.q()installLayout(Library)local installSearch=
__DARKLUA_BUNDLE_MODULES.r()installSearch(Library)local install6=
__DARKLUA_BUNDLE_MODULES.s()install6(Library)Library.ThemeManager=
__DARKLUA_BUNDLE_MODULES.t()Library.SaveManager=__DARKLUA_BUNDLE_MODULES.u()
Library.ThemeManager:SetLibrary(Library)Library.SaveManager:SetLibrary(Library)
Library:_startKeyInput()Library:_startPopupWatch()Library.Assets.LoadIcons()
Library:RefreshPill()function Library:SetBlur(enabled)self.BlurEnabled=enabled==
true if self.Toggled then self.Blur.Size=self.BlurEnabled and 12 or 0 end end
function Library:SetDim(enabled)self.DimEnabled=enabled==true if self.Toggled
then Util.Tween(self.Dim,0.25,{BackgroundTransparency=self.DimEnabled and 0.5 or
1})Util.Tween(self.Tint,0.25,{BackgroundTransparency=self.DimEnabled and 0 or 1}
)end end function Library:Unload()if self.Unloaded then return end self.Unloaded
=true for _,callback in ipairs(self.UnloadCallbacks)do Util.Safe(callback)end
for _,connection in ipairs(self.Signals)do pcall(function()connection:
Disconnect()end)end pcall(function()self.Blur:Destroy()end)pcall(function()gui:
Destroy()end)if env.CourageUI==self then env.CourageUI=nil env.Toggles=nil env.
Options=nil end end env.CourageLucide=function(name)return Library:GetIcon(name)
end env.CourageUI=Library env.Toggles=Library.Toggles env.Options=Library.
Options return Library