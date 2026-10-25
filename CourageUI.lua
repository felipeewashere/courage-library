-- Courage Hub UI backend (hosted separately, loaded by the hub via HttpGet).
-- Contains the UI bundle plus the facade shim the hub's adapter speaks.

	local CourageUI
	local CourageLib = nil

	-- font globals the aux windows use; the hosted UI fallback refines these
	-- with custom fonts, the default path keeps the stock Inter asset
	__CH_FONT_BODY = __CH_FONT_BODY or "rbxassetid://12187365364"
	__CH_BRAND_FONT = __CH_BRAND_FONT or "rbxassetid://12187365364"

	do
		local okCourage, resultCourage = pcall(function()
			return (function()
	-- Courage UI library bundle.

	local fn23 = nil

	local tbl14 = {
		function()
			local v, v43, v44 = fn23(1)

			return (function()
				local courageInstance = getgenv().__ETHOS_INSTANCE

				if type(courageInstance) == "table" and type(courageInstance.Destroy) == "function" then
					local ok, result = pcall(function()
						courageInstance:Destroy()
					end)

					if not ok then
						error("Failed to clean up the previous UI instance: " .. tostring(result), 0)
					end
				end

				local v45 = v44(v43.utils.loadGuard)

				local courageInstance2 = {
					_internal = nil,
					_library = nil,
					_destroyed = false,
					Destroy = function(arg)
						if arg._destroyed then
							local library = arg._library

							if library ~= nil and library.Destroyed ~= true and type(library.Destroy) == "function" then
								library:Destroy()
							end

							return
						end

						arg._destroyed = true
						local v46 = nil

						local function fn24(arg2)
							local ok, result = pcall(arg2)

							if not ok and v46 == nil then
								v46 = result
							end
						end

						local library = arg._library

						if library ~= nil and type(library.Destroy) == "function" then
							fn24(function()
								library:Destroy()
							end)
						end

						if library == nil or library.Destroyed ~= true then
							if
								library ~= nil
								and library.Server ~= nil
								and type(library.Server.disconnect) == "function"
							then
								fn24(function()
									library.Server:disconnect()
								end)
							end

							if arg._internal ~= nil then
								fn24(function()
									arg._internal.Maid:DoCleaning()
								end)

								fn24(function()
									arg._internal.Scope:doCleanup()
								end)
							end

							if library ~= nil and library.GUI ~= nil then
								fn24(function()
									library.GUI:Destroy()
								end)

								library.GUI = nil
							end
						end

						if v46 ~= nil then
							arg._destroyed = false
							error(v46, 0)
						end

						if getgenv().__ETHOS_INSTANCE == arg then
							getgenv().__ETHOS_INSTANCE = nil
						end
					end,
				}

				getgenv().__ETHOS_INSTANCE = courageInstance2
				local courageLoader = getgenv().EthosLoader

				local function fn24(arg)
					if courageLoader and courageLoader.set_status then
						pcall(courageLoader.set_status, arg)
					end
				end

				return v45.run(courageInstance2, function()
					fn24("Downloading assets...")
					local v46 = v43
					local components = v46.components
					local packages = v46.packages
					local internal = v44(v46.Internal)
					courageInstance2._internal = internal
					local v47 = v44(packages.fusion)
					local v48 = v44(packages.states)
					local v49 = v44(v46.storage.theme)
					local saveManager = v44(v46.modules.saveManager)
					local v50 = v44(v46.utils.perf)
					local v51 = v44(v46.utils.images)
					local v52 = v44(v46.utils.controlRegistry)
					local v53 = v44(v46.utils.pendingTasks)
					local v54 = v44(packages.keybindDispatcher)
					local v55 = v44(components.window.dialog)
					local scope = internal.Scope
					local v56 = v44(v46.components.ui)
					local children = v47.Children

					local library = {
						Version = "1.0.0",
						Options = v52.getOptions(),
						Connections = {},
						Window = nil,
						Unloaded = false,
						MinimizeKey = Enum.KeyCode.LeftControl,
						GUI = nil,
						SilentMode = false,
						Destroying = false,
						Destroyed = false,
						_destroyStarted = false,
						_cleanupCompleted = {},
						_onDestroyCallbacks = {},
						SaveManager = nil,
						CommandBar = nil,
						Server = nil,
						Perf = v50,
						ImageProvider = v51:GetProvider(),
					}

					courageInstance2._library = library
					v48.Library:set(library)
					local handlers2 = {}
					handlers2.__index = handlers2

					handlers2.__namecall = function(arg, arg2, ...)
						if handlers2[arg2] then
							return handlers2[arg2](...)
						end
						error(string.format("Invalid method call: %s", arg2))
					end

					for _, v57 in ipairs(v56) do
						handlers2["Add" .. v57.__type] = function(arg, arg2, arg3)
							return v57:New(
								{ Container = arg.Container, Scope = arg.Scope, AgentContext = arg.AgentContext },
								arg2,
								arg3
							)
						end
					end

					v48.Elements:set(handlers2)

					local function getOk(arg)
						return (pcall(arg))
					end

					local function fn25(arg)
						if library._destroyStarted or library.Destroyed or library.Unloaded then
							error(("Library:%s() cannot be used after Destroy() has started"):format(arg), 3)
						end
					end

					local function fn26(instance)
						assert(type(instance) == "table", "[WINDOW] Config must be a table")
						assert(
							type(instance.Title) == "string" and instance.Title ~= "",
							"[WINDOW] Title must be a non-empty string"
						)
						assert(
							type(instance.Tag) == "string" and instance.Tag ~= "",
							"[WINDOW] Tag must be a non-empty string"
						)
						assert(typeof(instance.Size) == "UDim2", "[WINDOW] Size must be a UDim2")

						if instance.Parent ~= nil then
							assert(typeof(instance.Parent) == "Instance", "[WINDOW] Parent must be an Instance")
						end

						if instance.Debug ~= nil then
							assert(type(instance.Debug) == "boolean", "[WINDOW] Debug must be a boolean")
						end

						if instance.AnimationsEnabled ~= nil then
							assert(
								type(instance.AnimationsEnabled) == "boolean",
								"[WINDOW] AnimationsEnabled must be a boolean"
							)
						end

						if instance.PerformanceMode ~= nil then
							assert(
								type(instance.PerformanceMode) == "boolean",
								"[WINDOW] PerformanceMode must be a boolean"
							)
						end

						if instance.Theme ~= nil then
							assert(
								type(instance.Theme) == "string" and instance.Theme ~= "",
								"[WINDOW] Theme must be a non-empty string"
							)
						end

						if instance.ImageProvider ~= nil then
							assert(
								type(instance.ImageProvider) == "string" and instance.ImageProvider ~= "",
								"[WINDOW] ImageProvider must be a non-empty string"
							)
						end

						if instance.MinimizeKey ~= nil then
							assert(
								typeof(instance.MinimizeKey) == "EnumItem"
									and instance.MinimizeKey.EnumType == Enum.KeyCode,
								"[WINDOW] MinimizeKey must be an Enum.KeyCode"
							)
						end
					end

					local function fn27()
						return table.clone(library.Connections)
					end

					local getCreateGui = nil

					local function fn28(arg)
						for k, connection in pairs(library.Connections) do
							if arg[k] ~= connection then
								library.Connections[k] = nil

								getOk(function()
									connection:Disconnect()
								end)
							end
						end

						for k, v57 in pairs(arg) do
							library.Connections[k] = v57
						end
					end

					library.CreateWindow = function(arg, arg2)
						fn25("CreateWindow")

						return v50.profile("startup:createWindow", function()
							fn26(arg2)

							if library.Window then
								error("Window already exists")
							end

							local v57 = table.clone(arg2)
							local v58 = v47.peek(v48.AnimationsEnabled)
							local v59 = v47.peek(v48.Theme)
							local provider = v51:GetProvider()
							local minimizeKey = library.MinimizeKey
							local v60 = v47.peek(v48.Objects)
							local v61 = fn27()
							local scope2 = scope:innerScope()
							local v62 = false
							local flag19 = false
							local flag20 = false
							local window = nil
							local createGui = nil
							local commandBar = nil

							local ok, result = xpcall(function()
								local imageProvider = v57.ImageProvider

								if imageProvider ~= nil then
									library:SetImageProvider(imageProvider)
								end

								if v57.AnimationsEnabled ~= nil then
									v48.AnimationsEnabled:set(v57.AnimationsEnabled == true)
								elseif v57.PerformanceMode ~= nil then
									v48.AnimationsEnabled:set(not v57.PerformanceMode)
								end

								library.MinimizeKey = v57.MinimizeKey or Enum.KeyCode.LeftControl
								library:SetTheme(v57.Theme or "obsidian")
								v57.Scope = scope2
								window = v44(components.window.window)(v57)
								commandBar = v44(v43.systems.commandbar)
								local v63 = commandBar:SetupModuleSystem(scope2)
								v62 = true
								commandBar:Initialize()
								createGui = getCreateGui(v57, scope2)
								v51:RegisterRoot(createGui)
								saveManager:SetLibrary(library)
								flag19 = true
								v52.registerWindow({ title = v57.Title, tag = v57.Tag })
								flag20 = true
								library.GUI = createGui
								library.Window = window
								library.SaveManager = saveManager
								library.CommandBar = commandBar

								library.AddModule = function(arg3, arg4)
									fn25("AddModule")
									return v63(arg3, arg4)
								end

								return window
							end, debug.traceback)

							if ok then
								return result
							end
							library.GUI = nil
							library.Window = nil
							library.SaveManager = nil
							library.CommandBar = nil
							library.AddModule = nil

							if flag20 then
								getOk(v52.reset)
							end

							if flag19 then
								getOk(function()
									saveManager:cleanup()
								end)
							end

							if createGui ~= nil then
								getOk(function()
									v51:UnregisterRoot(createGui)
								end)
							end

							if v62 and commandBar ~= nil then
								getOk(function()
									commandBar:cleanup()
								end)
							end

							getOk(function()
								scope2:doCleanup()
							end)

							if createGui ~= nil then
								getOk(function()
									createGui:Destroy()
								end)
							end

							fn28(v61)
							v48.Objects:set(v60)
							v48.AnimationsEnabled:set(v58)
							v48.Theme:set(v59)

							getOk(function()
								v51:SetProvider(provider)
							end)

							library.ImageProvider = v51:GetProvider()
							library.MinimizeKey = minimizeKey
							error(result, 0)
						end)
					end

					getCreateGui = function(instance, arg)
						local parent = instance.Parent or gethui()

						local function getCreateGuiChildren()
							return v50.profile("startup:createGuiChildren", function()
								return {
									v50.profile("startup:createCommandBar", function()
										return v44(components.commandbar.bar)(arg)
									end),
									v50.profile("startup:createSuggestions", function()
										return v44(components.commandbar.suggestions)(arg)
									end),
									v50.profile("startup:createNotificationHolder", function()
										return v44(components.notification.notificationHolder)(arg)
									end),
									v50.profile("startup:createKeybindViewer", function()
										return v44(components.keybindViewer)(arg)
									end),
									arg:ForPairs(v48.Objects, function(arg2, arg3, arg4, arg5)
										return arg4, arg5
									end),
								}
							end)
						end

						return v50.profile("startup:createGui", function()
							if instance.Debug then
								return arg:New("Frame")({
									Name = "Frame",
									BackgroundColor3 = Color3.fromRGB(0, 0, 0),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromScale(1, 1),
									Parent = parent,
									[children] = getCreateGuiChildren(),
								})
							end

							return (
								arg:New("ScreenGui")({
									Parent = parent,
									IgnoreGuiInset = true,
									ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
									[children] = getCreateGuiChildren(),
								})
							)
						end)
					end

					library.SetTheme = function(arg, arg2)
						fn25("SetTheme")
						v49.SetTheme(arg2:lower())
					end

					library.SetImageProvider = function(arg, arg2)
						fn25("SetImageProvider")
						library.ImageProvider = v51:SetProvider(arg2)
						return library.ImageProvider
					end

					library.GetImageProvider = function()
						fn25("GetImageProvider")
						return v51:GetProvider()
					end

					library.GetImageProviders = function()
						fn25("GetImageProviders")
						return v51:GetProviders()
					end

					library.GetThemes = function()
						fn25("GetThemes")
						return v49.GetSupportedThemes()
					end

					library.SetSilentMode = function(arg, arg2)
						fn25("SetSilentMode")
						library.SilentMode = arg2 == true

						if library.Window and type(library.Window.SetSilentMode) == "function" then
							library.Window:SetSilentMode(library.SilentMode)
						end
					end

					library.SetAnimationsEnabled = function(arg, arg2)
						fn25("SetAnimationsEnabled")
						v48.AnimationsEnabled:set(arg2 == true)
					end

					library.SetPerfEnabled = function(arg, arg2, arg3)
						fn25("SetPerfEnabled")
						v50.setEnabled(arg2, arg3)
					end

					library.SetMicroProfilerEnabled = function(arg, arg2)
						fn25("SetMicroProfilerEnabled")
						v50.setMicroProfilerEnabled(arg2)
					end

					library.SetKeybindViewerVisible = function(arg, arg2)
						fn25("SetKeybindViewerVisible")
						v48.KeybindViewerVisible:set(arg2)
					end

					local v57 = v44(components.notification.notification)

					library.Notify = function(arg, arg2)
						fn25("Notify")

						return v57:New({
							Title = arg2.Title or "Notification",
							Description = arg2.Description or "",
							Duration = arg2.Duration or 5,
							Type = string.lower(arg2.Type or "info"),
						}, scope)
					end

					library.Destroy = function()
						if library.Destroying or library.Destroyed then
							return
						end
						library._destroyStarted = true
						library.Unloaded = true
						library.Destroying = true
						local cleanupCompleted = library._cleanupCompleted
						local v58 = nil

						local function fn29(arg, arg2)
							if cleanupCompleted[arg] then
								return true
							end
							local ok, result = pcall(arg2)
							if ok then
								cleanupCompleted[arg] = true
								return true
							end

							if v58 == nil then
								v58 = result
							end

							return false
						end

						fn29("keybindDispatcher", function()
							v54.cleanup()
						end)

						fn29("perf", function()
							v50.cleanup()
						end)

						fn29("server", function()
							if library.Server then
								library.Server:disconnect()
							end
						end)

						if not cleanupCompleted.connections then
							local tbl14 = {}

							for k, connection in pairs(library.Connections) do
								table.insert(tbl14, { index = k, connection = connection })
							end

							local v59 = nil

							for _, v60 in ipairs(tbl14) do
								local index = v60.index
								local connection = v60.connection

								local ok, result = pcall(function()
									connection:Disconnect()
								end)

								if ok then
									if library.Connections[index] == connection then
										library.Connections[index] = nil
									end
								elseif v59 == nil then
									v59 = result
								end
							end

							local connections = {}

							for _, connection in pairs(library.Connections) do
								table.insert(connections, connection)
							end

							table.clear(library.Connections)

							for _, connection in ipairs(connections) do
								table.insert(library.Connections, connection)
							end

							if v59 == nil and next(library.Connections) ~= nil then
								v59 = "connections were added or changed during teardown"
							end

							if v59 == nil then
								cleanupCompleted.connections = true
							elseif v58 == nil then
								v58 = v59
							end
						end

						fn29("pendingTasks", function()
							v53.cleanup()
						end)

						fn29("commandBar", function()
							if library.CommandBar then
								library.CommandBar:cleanup()
							end
						end)

						fn29("notifications", function()
							v57:cleanup()
						end)

						fn29("dialogs", function()
							v55:cleanup()
						end)

						fn29("images", function()
							v51:cleanup()
						end)

						fn29("saveManager", function()
							if library.SaveManager then
								library.SaveManager:cleanup()
							end
						end)

						fn29("controlRegistry", function()
							v52.reset()
						end)

						fn29("maid", function()
							internal.Maid:DoCleaning()
						end)

						if fn29("scope", function()
							internal.Scope:doCleanup()
						end) then
							fn29("fusion", function()
								v47.cleanup()
							end)
						end

						if not cleanupCompleted.gui then
							local gui = library.GUI

							if
								fn29("gui", function()
									if gui then
										gui:Destroy()
									end
								end)
							then
								library.GUI = nil
							end
						end

						if v58 ~= nil then
							library.Destroying = false
							error(v58, 0)
						end

						library.Window = nil
						library.CommandBar = nil
						library.SaveManager = nil
						library.AddModule = nil

						if getgenv().Kyanos == library then
							getgenv().Kyanos = nil
						end

						if getgenv().Ethos == library.Server then
							getgenv().Ethos = nil
							getgenv().setAuthKey = nil
						end

						if getgenv().EthosServer == library.Server then
							getgenv().EthosServer = nil
						end

						if getgenv().__ETHOS_INSTANCE == library then
							getgenv().__ETHOS_INSTANCE = nil
						end

						library.Server = nil
						library.Destroyed = true
						library.Destroying = false
						local v59 = nil

						for _, onDestroyCallback in ipairs(library._onDestroyCallbacks) do
							if onDestroyCallback.active then
								onDestroyCallback.active = false
								local ok, result = pcall(onDestroyCallback.callback)

								if not ok and v59 == nil then
									v59 = result
								end
							end
						end

						table.clear(library._onDestroyCallbacks)

						if v59 ~= nil then
							error(v59, 0)
						end
					end

					library.OnDestroy = function(arg, arg2)
						assert(type(arg2) == "function", "OnDestroy expects a callback")

						if library.Destroyed then
							arg2()

							return function()
								return false
							end
						end

						assert(not library._destroyStarted, "OnDestroy cannot subscribe after Destroy() has started")
						local tbl14 = { active = true, callback = arg2 }
						table.insert(library._onDestroyCallbacks, tbl14)

						return function()
							if not tbl14.active then
								return false
							end
							tbl14.active = false
							return true
						end
					end

					library.AddConnection = function(arg, connection)
						fn25("AddConnection")
						local disconnect

						if type(connection) == "table" then
							disconnect = connection.Disconnect
						else
							disconnect = nil
						end

						assert(
							typeof(connection) == "RBXScriptConnection" or type(disconnect) == "function",
							"AddConnection expects a disconnectable connection"
						)
						table.insert(library.Connections, connection)
						return connection
					end

					library.SetCommandBarPrefix = function(arg, arg2)
						fn25("SetCommandBarPrefix")
						v48.CommandBarPrefix:set(arg2)
					end

					library.Server = v44(v43.server)

					library.Connect = function()
						fn25("Connect")
						return library.Server:ensureConnected()
					end

					library.PublishEvent = function(arg, arg2, arg3, arg4)
						fn25("PublishEvent")
						return library.Server:publishEvent(arg2, arg3, arg4)
					end

					if courageInstance2._destroyed or getgenv().__ETHOS_INSTANCE ~= courageInstance2 then
						error("UI library bootstrap was superseded by a newer load", 0)
					end

					getgenv().Kyanos = library
					getgenv().__ETHOS_INSTANCE = library
					fn24("Library loaded")
					return library
				end, function()
					fn24("Failed to load library")
				end)
			end)()
		end,
		function()
			local v, instance, v43 = fn23(2)

			return (
				(function()
					local v44 = v43(instance.Parent.packages.fusion)
					local v45 = v43(instance.Parent.packages.maid)
					return { Scope = v44:scoped(), Maid = v45.new() }
				end)()
			)
		end,
		[5] = function()
			fn23(5)

			return (
				(function()
					return {
						ChatWarningIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(0, 0),
							ImageRectSize = Vector2.new(96, 96),
						},
						DashboardAppsActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(96, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardAppsIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(168, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(240, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(312, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(384, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(456, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(528, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(600, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						ServerCapacityIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(672, 0),
							ImageRectSize = Vector2.new(64, 64),
						},
						CloseIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(736, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						MinimizeIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(780, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceAvailableIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(824, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceLoadingIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(868, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						AgentSendIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(912, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						AgentStopIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(952, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						ChevronDownIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(912, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						FrameRateIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(952, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						MemoryIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(736, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						NetworkPingIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(672, 64),
							ImageRectSize = Vector2.new(40, 40),
						},
						PlaceIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(776, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						RegionIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(816, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusErrorIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(856, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusInfoIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(896, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusSuccessIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(936, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusWarningIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(976, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						UptimeIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(712, 84),
							ImageRectSize = Vector2.new(40, 40),
						},
						AIChatActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(752, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						AIChatIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(788, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(824, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(860, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatSendIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(752, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(788, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(824, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(860, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(896, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(932, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(968, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						AgentGuidesIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(992, 0),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentPromptsIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(992, 32),
							ImageRectSize = Vector2.new(32, 32),
						},
						KeyboardIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(96, 72),
							ImageRectSize = Vector2.new(32, 32),
						},
						SearchIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(0, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						SettingsIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(32, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentChatSessionActiveIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(64, 96),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentChatSessionIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(128, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentThinkingIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(156, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolCodeIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(184, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolGenericIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(212, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolSearchIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(240, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolWebIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(268, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						CheckIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(296, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DropdownArrowIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(324, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DownloadIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(352, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						LikeIcon = {
							Image = "rbxassetid://96354582935906",
							ImageRectOffset = Vector2.new(376, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
					}
				end)()
			)
		end,
		[6] = function()
			fn23(6)

			return (
				(function()
					return {
						DashboardAppsIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(0, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(72, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(144, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(216, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						AnthropicIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(288, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						DeepSeekIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(316, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						GeminiIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(344, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						GptIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(372, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						KimiIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(400, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						LlamaIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(428, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						MetaIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(456, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						MistralIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(484, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						NvidiaIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(512, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
						QwenIcon = {
							Image = "rbxassetid://76434172246740",
							ImageRectOffset = Vector2.new(540, 0),
							ImageRectSize = Vector2.new(28, 28),
						},
					}
				end)()
			)
		end,
		[7] = function()
			fn23(7)

			return (
				(function()
					return {
						AdminBadge = "rbxassetid://78442024543745",
						AgentAddIcon = "rbxassetid://75168668455048",
						ButtonIcon = "rbxassetid://81624121716376",
						ColorPicker = "rbxassetid://72171626148979",
						CopyIcon = "rbxassetid://116467261580362",
						Cursor = "rbxassetid://81857207543459",
						Drag = "rbxassetid://115758629709887",
						EditIcon = "rbxassetid://109558354270594",
						MediaBadge = "rbxassetid://123370242140574",
						RegenerateIcon = "rbxassetid://115040833269706",
						ScrollBottom = "rbxassetid://117616164364352",
						ScrollMiddle = "rbxassetid://116215943524454",
						ScrollTop = "rbxassetid://118471988295372",
						StaffBadge = "rbxassetid://110284516095156",
						ThumbsDownIcon = "rbxassetid://103447516002004",
						ThumbsUpIcon = "rbxassetid://136756919777087",
						VIPBadge = "rbxassetid://134513918387904",
						CommandBooleanIcon = "rbxassetid://103579038000804",
						CommandNumberIcon = "rbxassetid://117009356276298",
						CommandStringIcon = "rbxassetid://112615609542917",
						ResizeHandle = "rbxassetid://102257689032914",
						Dropshadow = "rbxassetid://73319551652130",
						Shadow = "rbxassetid://108130691619628",
					}
				end)()
			)
		end,
		[8] = function()
			fn23(8)

			return (
				(function()
					return {
						ChatWarningIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(0, 0),
							ImageRectSize = Vector2.new(96, 96),
						},
						DashboardAppsActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(96, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardAppsIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(168, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(240, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(312, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(384, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(456, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(528, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(600, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						ServerCapacityIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(672, 0),
							ImageRectSize = Vector2.new(64, 64),
						},
						CloseIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(736, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						MinimizeIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(780, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceAvailableIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(824, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceLoadingIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(868, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						AgentSendIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(912, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						AgentStopIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(952, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						ChevronDownIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(912, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						FrameRateIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(952, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						MemoryIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(736, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						NetworkPingIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(672, 64),
							ImageRectSize = Vector2.new(40, 40),
						},
						PlaceIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(776, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						RegionIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(816, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusErrorIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(856, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusInfoIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(896, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusSuccessIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(936, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusWarningIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(976, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						UptimeIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(712, 84),
							ImageRectSize = Vector2.new(40, 40),
						},
						AIChatActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(752, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						AIChatIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(788, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(824, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(860, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatSendIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(752, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(788, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(824, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(860, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(896, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(932, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(968, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						AgentGuidesIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(992, 0),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentPromptsIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(992, 32),
							ImageRectSize = Vector2.new(32, 32),
						},
						KeyboardIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(96, 72),
							ImageRectSize = Vector2.new(32, 32),
						},
						SearchIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(0, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						SettingsIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(32, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentChatSessionActiveIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(64, 96),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentChatSessionIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(128, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentThinkingIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(156, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolCodeIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(184, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolGenericIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(212, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolSearchIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(240, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolWebIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(268, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						CheckIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(296, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DropdownArrowIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(324, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						CopyIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(352, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						DownloadIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(376, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						EditIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(400, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						LikeIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(424, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						RegenerateIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(448, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						ThumbsDownIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(472, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						ThumbsUpIcon = {
							Image = "rbxassetid://124551631463729",
							ImageRectOffset = Vector2.new(496, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
					}
				end)()
			)
		end,
		[9] = function()
			fn23(9)

			return (
				(function()
					return {
						ChatWarningIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(0, 0),
							ImageRectSize = Vector2.new(96, 96),
						},
						DashboardAppsActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(96, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardAppsIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(168, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(240, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(312, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(384, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(456, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(528, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(600, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						ServerCapacityIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(672, 0),
							ImageRectSize = Vector2.new(64, 64),
						},
						CloseIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(736, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						MinimizeIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(780, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceAvailableIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(824, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceLoadingIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(868, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						AgentSendIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(912, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						AgentStopIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(952, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						ChevronDownIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(912, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						FrameRateIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(952, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						MemoryIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(736, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						NetworkPingIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(672, 64),
							ImageRectSize = Vector2.new(40, 40),
						},
						PlaceIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(776, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						RegionIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(816, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusErrorIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(856, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusInfoIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(896, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusSuccessIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(936, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusWarningIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(976, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						UptimeIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(712, 84),
							ImageRectSize = Vector2.new(40, 40),
						},
						AIChatActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(752, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						AIChatIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(788, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(824, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(860, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatSendIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(752, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(788, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(824, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(860, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(896, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(932, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(968, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						AgentGuidesIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(992, 0),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentPromptsIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(992, 32),
							ImageRectSize = Vector2.new(32, 32),
						},
						KeyboardIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(96, 72),
							ImageRectSize = Vector2.new(32, 32),
						},
						SearchIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(0, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						SettingsIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(32, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentChatSessionActiveIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(64, 96),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentChatSessionIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(128, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentThinkingIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(156, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolCodeIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(184, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolGenericIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(212, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolSearchIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(240, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolWebIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(268, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						CheckIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(296, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DropdownArrowIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(324, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DownloadIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(352, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						LikeIcon = {
							Image = "rbxassetid://82719160849997",
							ImageRectOffset = Vector2.new(376, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
					}
				end)()
			)
		end,
		[10] = function()
			fn23(10)

			return (
				(function()
					return {
						ChatWarningIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(0, 0),
							ImageRectSize = Vector2.new(96, 96),
						},
						DashboardAppsActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(96, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardAppsIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(168, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(240, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(312, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(384, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(456, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(528, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(600, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						ServerCapacityIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(672, 0),
							ImageRectSize = Vector2.new(64, 64),
						},
						CloseIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(736, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						MinimizeIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(780, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceAvailableIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(824, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceLoadingIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(868, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						AgentSendIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(912, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						AgentStopIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(952, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						ChevronDownIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(912, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						FrameRateIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(952, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						MemoryIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(736, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						NetworkPingIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(672, 64),
							ImageRectSize = Vector2.new(40, 40),
						},
						PlaceIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(776, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						RegionIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(816, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusErrorIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(856, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusInfoIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(896, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusSuccessIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(936, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusWarningIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(976, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						UptimeIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(712, 84),
							ImageRectSize = Vector2.new(40, 40),
						},
						AIChatActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(752, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						AIChatIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(788, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(824, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(860, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatSendIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(752, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(788, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(824, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(860, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(896, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(932, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(968, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						AgentGuidesIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(992, 0),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentPromptsIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(992, 32),
							ImageRectSize = Vector2.new(32, 32),
						},
						KeyboardIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(96, 72),
							ImageRectSize = Vector2.new(32, 32),
						},
						SearchIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(0, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						SettingsIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(32, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentChatSessionActiveIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(64, 96),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentChatSessionIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(128, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentThinkingIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(156, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolCodeIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(184, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolGenericIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(212, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolSearchIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(240, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolWebIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(268, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						CheckIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(296, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DropdownArrowIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(324, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DownloadIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(352, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						LikeIcon = {
							Image = "rbxassetid://84535850967485",
							ImageRectOffset = Vector2.new(376, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
					}
				end)()
			)
		end,
		[11] = function()
			fn23(11)

			return (
				(function()
					return {
						ChatWarningIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(0, 0),
							ImageRectSize = Vector2.new(96, 96),
						},
						DashboardAppsActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(96, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardAppsIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(168, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(240, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardHomeIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(312, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(384, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardOptionsIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(456, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(528, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						DashboardScriptsIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(600, 0),
							ImageRectSize = Vector2.new(72, 72),
						},
						ServerCapacityIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(672, 0),
							ImageRectSize = Vector2.new(64, 64),
						},
						CloseIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(736, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						MinimizeIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(780, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceAvailableIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(824, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						PlaceLoadingIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(868, 0),
							ImageRectSize = Vector2.new(44, 44),
						},
						AgentSendIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(912, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						AgentStopIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(952, 0),
							ImageRectSize = Vector2.new(40, 40),
						},
						ChevronDownIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(912, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						FrameRateIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(952, 40),
							ImageRectSize = Vector2.new(40, 40),
						},
						MemoryIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(736, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						NetworkPingIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(672, 64),
							ImageRectSize = Vector2.new(40, 40),
						},
						PlaceIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(776, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						RegionIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(816, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusErrorIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(856, 44),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusInfoIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(896, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusSuccessIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(936, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						StatusWarningIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(976, 80),
							ImageRectSize = Vector2.new(40, 40),
						},
						UptimeIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(712, 84),
							ImageRectSize = Vector2.new(40, 40),
						},
						AIChatActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(752, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						AIChatIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(788, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(824, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(860, 84),
							ImageRectSize = Vector2.new(36, 36),
						},
						ChatSendIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(752, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(788, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ClientControlIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(824, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(860, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						CloudConfigsIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(896, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(932, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						ModPanelIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(968, 120),
							ImageRectSize = Vector2.new(36, 36),
						},
						AgentGuidesIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(992, 0),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentPromptsIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(992, 32),
							ImageRectSize = Vector2.new(32, 32),
						},
						KeyboardIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(96, 72),
							ImageRectSize = Vector2.new(32, 32),
						},
						SearchIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(0, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						SettingsIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(32, 96),
							ImageRectSize = Vector2.new(32, 32),
						},
						AgentChatSessionActiveIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(64, 96),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentChatSessionIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(128, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentThinkingIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(156, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolCodeIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(184, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolGenericIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(212, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolSearchIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(240, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						AgentToolWebIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(268, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						CheckIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(296, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DropdownArrowIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(324, 72),
							ImageRectSize = Vector2.new(28, 28),
						},
						DownloadIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(352, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
						LikeIcon = {
							Image = "rbxassetid://128534205189537",
							ImageRectOffset = Vector2.new(376, 72),
							ImageRectSize = Vector2.new(24, 24),
						},
					}
				end)()
			)
		end,
		[13] = function()
			local v, instance, v43 = fn23(13)

			return (
				(function()
					local utils = instance.Parent.Parent.utils
					local v44 = v43(utils.animate)
					local v45 = v43(utils.color3)
					local v46 = v43(utils.images)
					local v47 = v43(utils.safecallback)
					local v48 = v43(utils.perf)
					local v49 = v43(instance.Parent.Parent.packages.fusion)
					local children = v49.Children
					local onEvent = v49.OnEvent
					local peek = v49.peek
					local scope = v43(instance.Parent.Parent.Internal).Scope
					local v50 = v43(instance.Parent.Parent.storage.theme)
					local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					return {
						new = function(arg)
							local tbl14 = arg or {}
							local v51 = (tbl14.Scope or scope):innerScope()
							local size = tbl14.Size or UDim2.fromOffset(30, 30)
							local imageSize = tbl14.ImageSize or UDim2.fromOffset(18, 18)
							local cornerRadius = tbl14.CornerRadius or UDim.new(0, 4)
							local defaultImage = tbl14.DefaultImage or ""
							local activeImage = tbl14.ActiveImage or defaultImage
							local defaultImageKey = tbl14.DefaultImageKey
							local activeImageKey = tbl14.ActiveImageKey or defaultImageKey
							local isToggled = tbl14.IsToggled or v51:Value(false)
							local hasNotification = tbl14.HasNotification or v51:Value(false)
							local notificationColor = tbl14.NotificationColor or v50.AccentDestructive
							local notificationSize = tbl14.NotificationSize or UDim2.fromOffset(8, 8)
							local str7

							if tbl14.Name == "Dashboard" then
								str7 = "ui:dashboardToggleClick"
							else
								str7 = "ui:actionButtonClick"
							end

							local v52 = v51:Value(false)
							local v53 = v51:Value(false)
							local v54 = str7
							local tbl15 = {
								Root = nil,
								IsToggled = isToggled,
								HasNotification = hasNotification,
								Type = "ActionButton",
							}

							local function fn24()
								v48.mark(v54)

								v48.profile(v54, function()
									if tbl14.ToggleOnClick ~= false then
										isToggled:set(not peek(isToggled))
									end

									if tbl14.OnClick then
										v47(function()
											tbl14.OnClick(peek(isToggled))
										end)
									end
								end)
							end

							local function fn25(arg2, arg3, arg4)
								local v55 = v51:Tween(
									v51:Computed(function(arg5)
										return arg5(arg4) and 1 or 0
									end),
									tweenInfo
								)

								local v56 = v51:New("ImageLabel")({
									Name = "ImageLabel",
									BackgroundTransparency = 1,
									Image = arg2,
									ImageTransparency = v51:Computed(function(arg5)
										return 1 - math.clamp(arg5(v55), 0, 1)
									end),
									Visible = v51:Computed(function(arg5)
										return arg5(v55) > 0.01
									end),
									ImageColor3 = v44(function(arg5)
										if arg5(isToggled) then
											return arg5(v50.AccentPrimary)
										end
										return arg5(v50.FgTertiary)
									end, 35, 1, v51),
									Size = v44(function(arg5)
										local imageSize2 = imageSize
										if arg5(v53) then
											return UDim2.new(
												imageSize2.X.Scale,
												imageSize2.X.Offset * 0.9,
												imageSize2.Y.Scale,
												imageSize2.Y.Offset * 0.90000000000000002
											)
										end

										if arg5(isToggled) then
											return UDim2.new(
												imageSize2.X.Scale,
												imageSize2.X.Offset * 1.1,
												imageSize2.Y.Scale,
												imageSize2.Y.Offset * 1.1
											)
										end
										return imageSize
									end, 50, 1, v51),
									Rotation = v44(function(arg5)
										if arg5(v53) then
											return -5
										end
										return 0
									end, 70, 1, v51),
									Position = UDim2.fromScale(0.5, 0.5),
									AnchorPoint = Vector2.new(0.5, 0.5),
									[children] = {
										v51:New("UIScale")({
											Scale = v51:Computed(function(arg5)
												return 0.75 + 0.25 * math.clamp(arg5(v55), 0, 1)
											end),
										}),
									},
								})

								if arg3 then
									return v46:Track(arg3, v56)
								end
								return v56
							end

							local tbl16

							if defaultImageKey then
								local v55 = v51:Computed(function(arg2)
									return not arg2(isToggled)
								end)

								local v56 = v51:Computed(function(arg2)
									return arg2(isToggled)
								end)

								tbl16 = {}
								local v57 = fn25(v46[defaultImageKey] or defaultImage, defaultImageKey, v55)
								local activeImage2 = v46[activeImageKey] or activeImage
								local v58 = table.pack(fn25(activeImage2, activeImageKey, v56))
								tbl16[1] = v57

								do
									local values = table.pack(table.unpack(v58, 1, v58.n))
									table.move(values, 1, values.n, 2, tbl16)
								end
							else
								tbl16 = fn25(
									v51:Computed(function(arg2)
										if arg2(isToggled) then
											return activeImage
										end
										return defaultImage
									end),
									nil,
									v51:Value(true)
								)
							end

							local v55 = v44(function(arg2)
								return arg2(hasNotification) and not arg2(isToggled) and 1 or 0
							end, 32, 0.65, v51)

							local Frame = v51:New("Frame")
							local childrens = {
								Name = "ActionButtonContainer",
								BackgroundTransparency = 1,
								Size = size,
								LayoutOrder = tbl14.LayoutOrder or 0,
							}
							local children2 = children
							local tbl17 = {}
							local ImageButton = v51:New("ImageButton")

							local childrens2 = {
								Name = tbl14.Name or "ActionButton",
								BackgroundColor3 = v44(function(arg2)
									if arg2(v53) then
										return v45.lightenRGB(arg2(v50.BgPrimary), 2)
									end

									if arg2(v52) then
										return v45.lightenRGB(arg2(v50.BgPrimary), 10)
									end
									return arg2(v50.BgPrimary)
								end, 45, 1, v51),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = v44(function(arg2)
									if arg2(v53) then
										return UDim2.fromScale(0.92, 0.92)
									end

									if arg2(v52) then
										return UDim2.fromScale(1.05, 1.05)
									end
									return UDim2.fromScale(1, 1)
								end, 60, 1, v51),
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
								ZIndex = 2,
							}

							childrens2[children] = {
								v51:New("UICorner")({ Name = "UICorner", CornerRadius = cornerRadius }),
								v51:New("UIStroke")({
									Name = "UIStroke",
									Color = v44(function(arg2)
										if arg2(v53) then
											return v45.lightenRGB(tbl14.StrokeColor or arg2(v50.BgTertiary), 15)
										end

										if arg2(v52) then
											return v45.lightenRGB(tbl14.StrokeColor or arg2(v50.BgTertiary), 25)
										end
										return tbl14.StrokeColor or arg2(v50.BgTertiary)
									end, 50, 1, v51),
									Thickness = v44(function(arg2)
										if arg2(v53) then
											return 1.5
										end

										if arg2(v52) then
											do
												return 1.2
											end

											while true do
											end

											return
										end

										return 1
									end, 40, 1, v51),
									Transparency = 0,
									Enabled = true,
								}),
								tbl16,
							}

							childrens2[onEvent("MouseEnter")] = function()
								v52:set(true)

								if tbl14.OnMouseEnter then
									tbl14.OnMouseEnter()
								end
							end

							childrens2[onEvent("MouseLeave")] = function()
								v52:set(false)

								if tbl14.OnMouseLeave then
									tbl14.OnMouseLeave()
								end
							end

							childrens2[onEvent("MouseButton1Down")] = function()
								v53:set(true)

								if tbl14.OnMouseDown then
									tbl14.OnMouseDown()
								end
							end

							childrens2[onEvent("MouseButton1Up")] = function()
								v53:set(false)

								if tbl14.OnMouseUp then
									tbl14.OnMouseUp()
								end
							end

							childrens2[onEvent("Activated")] = function()
								fn24()
							end

							childrens2[onEvent("InputBegan")] = function(input)
								if
									input.UserInputType == Enum.UserInputType.MouseButton1
									or input.UserInputType == Enum.UserInputType.Touch
								then
									v53:set(true)
								end
							end

							childrens2[onEvent("InputEnded")] = function(input)
								if
									input.UserInputType == Enum.UserInputType.MouseButton1
									or input.UserInputType == Enum.UserInputType.Touch
								then
									v53:set(false)

									if tbl14.OnInputEnded then
										tbl14.OnInputEnded(input)
									end
								end
							end

							local v56 = ImageButton(childrens2)

							local v57 = table.pack(v51:Computed(function()
								if tbl14.ShowNotification then
									return v51:New("Frame")({
										Name = "NotificationIndicator",
										AnchorPoint = Vector2.new(1, 0),
										BackgroundColor3 = notificationColor,
										BorderSizePixel = 0,
										Position = UDim2.new(1, 2, 0, -2),
										BackgroundTransparency = v51:Computed(function(arg2)
											return 1 - math.clamp(arg2(v55), 0, 1)
										end),
										Size = v51:Computed(function(arg2)
											local n = math.max(arg2(v55), 0)
											return UDim2.new(
												notificationSize.X.Scale * n,
												notificationSize.X.Offset * n,
												notificationSize.Y.Scale * n,
												notificationSize.Y.Offset * n
											)
										end),
										Visible = v51:Computed(function(arg2)
											return arg2(v55) > 0.01
										end),
										ZIndex = 5,
										[children] = {
											v51:New("UICorner")({ CornerRadius = UDim.new(1, 0) }),
											v51:New("UIStroke")({
												Color = Color3.fromRGB(40, 40, 40),
												Thickness = 1,
												Transparency = v51:Computed(function(arg2)
													return 1 - 0.5 * math.clamp(arg2(v55), 0, 1)
												end),
											}),
										},
									})
								end

								return nil
							end))

							tbl17[1] = v56

							do
								local values = table.pack(table.unpack(v57, 1, v57.n))
								table.move(values, 1, values.n, 2, tbl17)
							end

							childrens[children2] = tbl17
							local root = Frame(childrens)
							tbl15.Root = root
							local flag19 = false

							tbl15.Destroy = function()
								if flag19 then
									return
								end
								v51:doCleanup()
							end

							v51:insert(function()
								flag19 = true
							end)

							v51:insert(root.Destroying:Connect(function()
								tbl15:Destroy()
							end))

							tbl15.Click = function()
								if not flag19 then
									fn24()
								end
							end

							return tbl15
						end,
					}
				end)()
			)
		end,
		[14] = function()
			local v, instance, v43 = fn23(14)

			return (
				(function()
					local utils = instance.Parent.Parent.utils
					local v44 = v43(utils.images)
					local v45 = v43(utils.animate)
					local v46 = v43(utils.color3)
					local v47 = v43(utils.safecallback)
					local v48 = v43(instance.Parent.Parent.packages.fusion)
					local peek = v48.peek
					local scope = v43(instance.Parent.Parent.Internal).Scope
					local children = v48.Children
					local onEvent = v48.OnEvent
					local v49 = v43(instance.Parent.Parent.storage.theme)

					return {
						new = function(arg)
							local tbl14 = arg or {}
							local v50 = (tbl14.Scope or scope):innerScope()
							local automaticSizeX = tbl14.AutomaticSizeX or false
							local size = tbl14.Size

							if not size then
								if automaticSizeX then
									size = UDim2.new(0, 0, 0, tbl14.Height or 28)
								else
									size = UDim2.new(1, 0, 0, tbl14.Height or 28)
								end
							end

							local tbl15 = {
								Callback = tbl14.Callback or function() end,
							}

							tbl15.Style = string.lower(tbl14.Type or "default")
							tbl15.HoverStyle = tbl14.HoverType and string.lower(tbl14.HoverType) or nil
							tbl15.Type = "Button"
							tbl15.TooltipText = tbl14.Tooltip or nil
							tbl15.Root = nil

							local v51 = v50:Value(false)
							local v52 = v50:Value(false)
							local enabled2

							if tbl14.Enabled == nil then
								enabled2 = true
							else
								enabled2 = tbl14.Enabled
							end

							local function fn24(arg2)
								if tbl15.HoverStyle and (arg2(v51) or arg2(v52)) then
									return tbl15.HoverStyle
								end
								return tbl15.Style
							end

							tbl15.Render = function(arg2, arg3)
								local v53

								if tbl14.Tooltip then
									v53 = v43(instance.Parent.window.tooltip)({ Text = tbl14.Tooltip, Scope = arg3 })
								else
									v53 = nil
								end

								local v54 = v45(function(arg4)
									if not arg4(enabled2) then
										return arg4(v49.FgQuaternary)
									end
									local v54 = fn24(arg4)

									if v54 == "default" then
										if arg4(v52) then
											return v46.darkenRGB(arg4(v49.FgTertiary), 12)
										end

										if arg4(v51) then
											return v46.lightenRGB(arg4(v49.FgTertiary), 35)
										end
										return arg4(v49.FgTertiary)
									end

									if v54 == "secondary" then
										if arg4(v52) then
											return arg4(v49.FgTertiary)
										end

										if arg4(v51) then
											return arg4(v49.FgPrimary)
										end
										return arg4(v49.FgSecondary)
									end

									if arg4(v52) then
										return v46.darkenRGB(Color3.fromRGB(255, 255, 255), 8)
									end

									if arg4(v51) then
										return Color3.fromRGB(255, 255, 255)
									end
									return v46.lightenRGB(arg4(v49.FgPrimary), 10)
								end, 25, 1, arg3)

								local icon = tbl14.Icon
								local flag19 = false

								if type(icon) == "string" then
									local icon2 = v44:GetIcon(icon)

									if icon2 then
										icon = icon2
										flag19 = true
									end
								end

								local iconSize = tbl14.IconSize or 14
								local TextButton = arg3:New("TextButton")

								local childrens = {
									Name = "TextButton",
									Text = "",
									Active = arg3:Computed(function(arg4)
										return arg4(enabled2)
									end),
									AutoButtonColor = false,
									BackgroundColor3 = v45(function(arg4)
										if not arg4(enabled2) then
											return arg4(v49.BgPrimaryHighlight)
										end
										local v55 = fn24(arg4)
										local v56

										if v55 == "primary" then
											v56 = arg4(v49.AccentPrimary)
										elseif v55 == "danger" then
											v56 = arg4(v49.AccentDestructive)
										elseif v55 == "warning" then
											v56 = arg4(v49.AccentCaution)
										else
											v56 = arg4(v49.BgPrimaryHighlight)
										end

										if arg4(v52) then
											return v46.darkenRGB(v56, 12)
										end

										if arg4(v51) then
											return v46.lightenRGB(v56, 18)
										end
										return v56
									end, 25, 1, arg3),
									BackgroundTransparency = v45(function(arg4)
										local n

										if arg4(enabled2) then
											n = 0
										else
											n = 0.65000000000000002
										end

										return n
									end, 25, 1, arg3),
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = v45(function(arg4)
										if arg4(v52) then
											return UDim2.new(1, -3, 1, -2)
										end
										return UDim2.fromScale(1, 1)
									end, 25, 1, arg3),
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(0.5, 0.5),
									ZIndex = 1,
									ClipsDescendants = false,
								}

								local children2 = children
								local tbl16 = {}
								local v55 =
									arg3:New("UICorner")({ Name = "ButtonCorner", CornerRadius = UDim.new(0, 4) })

								local v56 = arg3:Computed(function(arg4, arg5)
									if fn24(arg4) == "default" then
										return
									end

									return arg5:New("ImageLabel")({
										Name = "ButtonHighlight",
										Image = v44.ButtonIcon,
										Size = UDim2.fromScale(1, 1),
										BackgroundTransparency = 1,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										ImageColor3 = v45(function(arg6)
											if fn24(arg6) == "secondary" and arg6(v52) then
												return arg6(v49.FgTertiary)
											end
											return Color3.fromRGB(255, 255, 255)
										end, 25, 1, arg5),
										ImageTransparency = v45(function(arg6)
											if arg6(v51) then
												return 0.68000000000000005
											end
											return 0.82
										end, 25, 1, arg5),
										ScaleType = Enum.ScaleType.Slice,
										SliceScale = 0.5,
										SliceCenter = Rect.new(25, 25, 25, 25),
										Active = false,
										ZIndex = 2,
										[children] = {
											arg5:New("UIGradient")({
												Name = "HighlightGradient",
												Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
												Transparency = NumberSequence.new({
													NumberSequenceKeypoint.new(0, 0),
													NumberSequenceKeypoint.new(0.17999999999999999, 0.22),
													NumberSequenceKeypoint.new(0.42, 0.78),
													NumberSequenceKeypoint.new(1, 1),
												}),
												Rotation = 90,
											}),
										},
									})
								end)

								local Frame = arg3:New("Frame")

								local childrens2 = {
									Name = "ContentContainer",
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(1, 1),
									ZIndex = 3,
								}

								local children3 = children
								local tbl17 = {}

								local v57 = arg3:New("UIListLayout")({
									Name = "ContentLayout",
									FillDirection = Enum.FillDirection.Horizontal,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									SortOrder = Enum.SortOrder.LayoutOrder,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = UDim.new(0, 5),
								})

								local v58 = arg3:Computed(function(arg4, arg5)
									if not icon or icon == "" or icon == "rbxassetid://0" then
										return
									end

									local v58 = arg5:New("ImageLabel")({
										Name = "ButtonIcon",
										Image = icon,
										ImageColor3 = v54,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.fromOffset(iconSize, iconSize),
									})

									if flag19 then
										v44:Track(tbl14.Icon, v58)
									end

									return v58
								end)

								local v59 = arg3:New("TextLabel")({
									Name = "ButtonText",
									FontFace = Font.new(
										"rbxassetid://12187365364",
										tbl14.FontWeight or Enum.FontWeight.Medium,
										tbl14.FontStyle or Enum.FontStyle.Normal
									),
									Text = tbl14.Title or "",
									TextColor3 = v54,
									TextSize = 14,
									TextXAlignment = Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									BackgroundTransparency = 1,
									AutomaticSize = Enum.AutomaticSize.XY,
								})

								local v60 = arg3:New("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 4) })
								local v61

								if tbl14.Stroke == false then
									v61 = nil
								else
									v61 = arg3:New("UIStroke")({
										Name = "UIStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = v45(function(arg4)
											local strokeColor

											if not arg4(enabled2) then
												strokeColor = arg4(v49.BgTertiary)
											elseif tbl14.StrokeColor then
												strokeColor = tbl14.StrokeColor
											else
												local v62 = fn24(arg4)

												if v62 == "primary" then
													strokeColor = arg4(v49.AccentPrimary)
												elseif v62 == "danger" then
													strokeColor = arg4(v49.AccentDestructive)
												elseif v62 == "warning" then
													strokeColor = arg4(v49.AccentCaution)
												elseif v62 == "secondary" then
													strokeColor = arg4(v49.BgTertiary)
												else
													strokeColor = arg4(v49.BgPrimaryHighlight)
												end
											end

											if arg4(v52) then
												return v46.lightenRGB(strokeColor, 30)
											end

											if arg4(v51) then
												return v46.lightenRGB(strokeColor, 55)
											end
											return v46.lightenRGB(strokeColor, 38)
										end, 25, 1, arg3),
										Transparency = v45(function(arg4)
											if not arg4(enabled2) then
												return 0.65
											end

											if arg4(v51) then
												return 0.1
											end
											return 0.22
										end, 25, 1, arg3),
										Thickness = 1.5,
									})
								end

								local v62 = table.pack(arg3:Computed(function(arg4, arg5)
									if tbl14.Padding then
										local tbl18 = {}

										if typeof(tbl14.Padding) == "table" then
											tbl18.PaddingLeft = tbl14.Padding.Left
											tbl18.PaddingRight = tbl14.Padding.Right
											tbl18.PaddingTop = tbl14.Padding.Top
											tbl18.PaddingBottom = tbl14.Padding.Bottom
										else
											tbl18.PaddingLeft = tbl14.Padding
											tbl18.PaddingRight = tbl14.Padding
										end

										return arg5:New("UIPadding")({
											Name = "ButtonPadding",
											PaddingLeft = tbl18.PaddingLeft,
											PaddingRight = tbl18.PaddingRight,
											PaddingTop = tbl18.PaddingTop,
											PaddingBottom = tbl18.PaddingBottom,
										})
									end
								end))

								tbl17[1] = v57
								tbl17[2] = v58
								tbl17[3] = v59
								tbl17[4] = v60
								tbl17[5] = v61

								do
									local values = table.pack(table.unpack(v62, 1, v62.n))
									table.move(values, 1, values.n, 6, tbl17)
								end

								childrens2[children3] = tbl17
								local v63 = table.pack(Frame(childrens2))
								tbl16[1] = v55
								tbl16[2] = v56

								do
									local values = table.pack(table.unpack(v63, 1, v63.n))
									table.move(values, 1, values.n, 3, tbl16)
								end

								childrens[children2] = tbl16

								childrens[onEvent("Activated")] = function()
									if peek(enabled2) then
										v47(function()
											tbl15.Callback()
										end)
									end
								end

								childrens[onEvent("MouseButton1Down")] = function()
									v52:set(true)
								end

								childrens[onEvent("MouseButton1Up")] = function()
									v52:set(false)
								end

								childrens[onEvent("InputEnded")] = function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										v52:set(false)
									end
								end

								childrens[onEvent("InputBegan")] = function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										v52:set(true)
									end
								end

								childrens[onEvent("MouseEnter")] = function()
									if not peek(enabled2) then
										return
									end
									v51:set(true)

									if v53 then
										v53.set_visible(true)
									end
								end

								childrens[onEvent("MouseLeave")] = function()
									v51:set(false)
									v52:set(false)

									if v53 then
										v53.set_visible(false)
									end
								end

								local v64 = TextButton(childrens)
								local Frame2 = arg3:New("Frame")

								local childrens3 = {
									Name = "ButtonContainer",
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									AutomaticSize = automaticSizeX and Enum.AutomaticSize.X or Enum.AutomaticSize.None,
									LayoutOrder = tbl14.LayoutOrder,
									Size = size,
									AnchorPoint = Vector2.new(0.5, 0),
									Position = UDim2.new(0.5, 0, 0, 0),
									ClipsDescendants = false,
									ZIndex = 1,
								}

								childrens3[children] = { v64 }
								local root = Frame2(childrens3)
								tbl15.Root = root
								return root
							end

							return tbl15
						end,
					}
				end)()
			)
		end,
		[16] = function()
			local v, instance, v43 = fn23(16)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.utils.animate)
					local packages = instance.Parent.Parent.Parent.packages
					local v45 = v43(packages.fusion)
					local v46 = v43(packages.states)
					local v47 = v43(packages.audio)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local peek = v45.peek
					local v48 = v43(instance.Parent.Parent.Parent.storage.theme)
					local v49 = v43(instance.Parent.Parent.Parent.utils.images)
					local children = v45.Children
					local onEvent = v45.OnEvent
					local onChange = v45.OnChange
					local v50 = 0.999

					return function(arg)
						local scope2 = arg or scope
						local v51 = scope2:Value(UDim2.new(0.5, 0, 0, 100))
						local v52 = scope2:Value()
						local v53 = scope2:Value()
						local v54 = scope2:Value(1)

						local v55 = v44(function(arg2)
							return arg2(v46.CommandBarOpened) and 0 or 1
						end, 30, 1.2, scope2)

						scope2:Observer(v46.CommandBarOpened):onChange(function()
							if peek(v46.CommandBarOpened) then
								v54:set(1)
								v51:set(UDim2.new(0.5, 0, 0, 130))
								peek(v52):CaptureFocus()
							else
								peek(v52):ReleaseFocus()
							end
						end)

						local v56 = v49
						local track = v56.Track

						return (
							v53:set(scope2:New("CanvasGroup")({
								Name = "Command Bar",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = v48.BgPrimary,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Position = v44(function(arg2)
									return arg2(v51)
								end, 30, 1.2, scope2),
								Size = UDim2.new(1, -24, 0, 80),
								GroupTransparency = v55,
								Visible = scope2:Computed(function(arg2)
									if arg2(v46.CommandBarOpened) then
										return true
									end

									if not arg2(v46.AnimationsEnabled) then
										return false
									end
									return arg2(v55) < v50
								end),
								[children] = {
									scope2:New("UISizeConstraint")({ MaxSize = Vector2.new(517, 80) }),
									scope2:New("UIScale")({ Name = "UIScale", Scale = v54 }),
									scope2:New("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 10) }),
									scope2:New("UIStroke")({
										Name = "UIStroke",
										Color = v48.BgTertiary,
										Thickness = 2.5,
										Transparency = v44(function(arg2)
											return arg2(v46.CommandBarOpened) and 0.6 or 1
										end, 30, 1.2, scope2),
									}),
									scope2:New("Frame")({
										Name = "Top",
										BackgroundColor3 = v48.BgPrimaryHighlight,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Size = UDim2.new(1, 0, 0, 40),
										[children] = {
											scope2:New("Frame")({
												Name = "Seperator",
												AnchorPoint = Vector2.new(0, 1),
												BackgroundColor3 = v48.BgTertiary,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.fromScale(0, 1),
												Size = UDim2.new(1, 0, 0, 1),
											}),
											scope2:New("TextLabel")({
												Name = "Title",
												FontFace = Font.new(
													"rbxassetid://12187365364",
													Enum.FontWeight.Bold,
													Enum.FontStyle.Normal
												),
												Text = "Command Bar",
												TextColor3 = v48.FgPrimary,
												TextSize = 15,
												TextXAlignment = Enum.TextXAlignment.Left,
												AutomaticSize = Enum.AutomaticSize.X,
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.fromOffset(15, 0),
												Size = UDim2.fromScale(0, 1),
											}),
											scope2:New("TextLabel")({
												Name = "TextLabel",
												FontFace = Font.new(
													"rbxassetid://12187365364",
													Enum.FontWeight.Medium,
													Enum.FontStyle.Normal
												),
												Text = "Kyanos - v.1.0.0",
												TextColor3 = v48.FgSecondary,
												TextSize = 15,
												TextXAlignment = Enum.TextXAlignment.Right,
												AnchorPoint = Vector2.new(1, 0),
												AutomaticSize = Enum.AutomaticSize.X,
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.new(1, -15, 0, 0),
												Size = UDim2.fromScale(0, 1),
											}),
										},
									}),
									v52:set(scope2:New("TextBox")({
										Name = "TextBox",
										FontFace = Font.new(
											"rbxassetid://12187365364",
											Enum.FontWeight.Medium,
											Enum.FontStyle.Normal
										),
										PlaceholderColor3 = v48.FgTertiary,
										PlaceholderText = "Type a command or search...",
										Text = "",
										TextColor3 = v48.FgSecondary,
										TextSize = 14,
										TextXAlignment = Enum.TextXAlignment.Left,
										AnchorPoint = Vector2.new(0, 1),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Position = UDim2.fromScale(0, 1),
										Size = UDim2.new(1, 0, 1, -40),
										[children] = {
											scope2:New("UIPadding")({
												Name = "UIPadding",
												PaddingBottom = UDim.new(0, 1),
												PaddingLeft = UDim.new(0, 40),
											}),
										},
										[onChange("Text")] = function()
											local v57 = peek(v52)
											local text = v57.Text
											local v58 = peek(v46.CommandBarText)

											if #v58 < #text then
												v47:Play("Key")
											elseif #text < #v58 then
												task.wait()

												if v57:IsFocused() then
													v47:Play("Backspace")
												end
											end

											v46.CommandBarText:set(text)
										end,
										[onEvent("FocusLost")] = function()
											v47:Play("Enter")
											v46.ToExecute:set(peek(v52).Text)
											peek(v52).Text = ""
											v46.CommandBarOpened:set(false)
											v51:set(UDim2.new(0.5, 0, 0, 160))
											task.wait(0.2)
											v54:set(0)
											v51:set(UDim2.new(0.5, 0, 0, 100))
										end,
									})),
									track(
										v56,
										"SearchIcon",
										scope2:New("ImageLabel")({
											Name = "ImageLabel",
											Image = v49.SearchIcon,
											ImageColor3 = v48.AccentPrimary,
											AnchorPoint = Vector2.new(0, 0.5),
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Position = UDim2.new(0, 15, 0.75, 0),
											Size = UDim2.fromOffset(16, 16),
										})
									),
								},
							}))
						)
					end
				end)()
			)
		end,
		[17] = function()
			local v, instance, v43 = fn23(17)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local v45 = v43(instance.Parent.Parent.Parent.storage.theme)
					local children = v44.Children

					local tbl14 = {
						string = { color = v45.AccentPrimary, icon = "CommandStringIcon" },
						boolean = { color = v45.AccentCaution, icon = "CommandBooleanIcon" },
						number = { color = v45.Success, icon = "CommandNumberIcon" },
					}

					return function(arg)
						local v46 = (arg.Scope or scope):innerScope()
						local forPairs = v46.ForPairs
						local types = arg.types

						local v47 = v46:New("Frame")({
							Name = "Suggestion",
							BackgroundColor3 = v45.BgPrimaryHighlight,
							BorderColor3 = Color3.fromRGB(37, 40, 44),
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 55),
							BackgroundTransparency = v46:Computed(function()
								return arg.top and 0 or 0.7
							end),
							[children] = {
								v46:New("UIStroke")({ Name = "UIStroke", Color = Color3.fromRGB(48, 52, 56) }),
								v46:New("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 6) }),
								v46:New("Frame")({
									Name = "TextHolder",
									AutomaticSize = Enum.AutomaticSize.X,
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = UDim2.fromScale(0, 1),
									[children] = {
										v46:New("UIListLayout")({
											Name = "UIListLayout",
											Padding = UDim.new(0, 1),
											SortOrder = Enum.SortOrder.LayoutOrder,
											VerticalAlignment = Enum.VerticalAlignment.Center,
										}),
										v46:New("TextLabel")({
											Name = "TextLabel",
											FontFace = Font.new(
												"rbxassetid://12187365364",
												Enum.FontWeight.SemiBold,
												Enum.FontStyle.Normal
											),
											Text = arg.name,
											TextColor3 = v45.FgSecondary,
											TextSize = 16,
											AutomaticSize = Enum.AutomaticSize.XY,
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
										}),
										v46:New("TextLabel")({
											Name = "TextLabel",
											FontFace = Font.new(
												"rbxassetid://12187365364",
												Enum.FontWeight.Medium,
												Enum.FontStyle.Normal
											),
											Text = arg.description,
											TextColor3 = v45.FgTertiary,
											TextSize = 14,
											AutomaticSize = Enum.AutomaticSize.XY,
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
										}),
										v46:New("UIPadding")({ Name = "UIPadding", PaddingLeft = UDim.new(0, 10) }),
									},
								}),
								v46:New("Frame")({
									Name = "Types",
									AnchorPoint = Vector2.new(1, 0),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.new(1, -10, 0, 0),
									Size = UDim2.fromScale(0, 1),
									[children] = {
										v46:New("UIListLayout")({
											Name = "UIListLayout",
											Padding = UDim.new(0, 7),
											FillDirection = Enum.FillDirection.Horizontal,
											HorizontalAlignment = Enum.HorizontalAlignment.Right,
											SortOrder = Enum.SortOrder.LayoutOrder,
											VerticalAlignment = Enum.VerticalAlignment.Center,
										}),
										forPairs(v46, types, function(arg2, arg3, arg4, arg5)
											return arg4,
												arg3:New("Frame")({
													Name = "TYPE",
													AutomaticSize = Enum.AutomaticSize.XY,
													BackgroundColor3 = tbl14[arg5.type].color,
													BackgroundTransparency = 0.9,
													BorderSizePixel = 0,
													Size = UDim2.fromOffset(0, 0),
													[children] = {
														arg3:New("TextLabel")({
															Name = "TypeText",
															FontFace = Font.new(
																"rbxassetid://12187365364",
																Enum.FontWeight.Bold,
																Enum.FontStyle.Normal
															),
															Text = string.upper(arg5.name),
															TextColor3 = tbl14[arg5.type].color,
															TextSize = 13,
															AutomaticSize = Enum.AutomaticSize.XY,
															BackgroundTransparency = 1,
															Size = UDim2.fromScale(0, 0),
															TextXAlignment = Enum.TextXAlignment.Center,
														}),
														arg3:New("UICorner")({ CornerRadius = UDim.new(0, 4) }),
														arg3:New("UIPadding")({
															PaddingBottom = UDim.new(0, 6),
															PaddingLeft = UDim.new(0, 10),
															PaddingRight = UDim.new(0, 10),
															PaddingTop = UDim.new(0, 6),
														}),
														arg3:New("UIStroke")({
															Color = tbl14[arg5.type].color,
															Transparency = 0.2,
															Thickness = 1.5,
														}),
													},
												})
										end),
									},
								}),
							},
						})

						local flag19 = false

						local function onDestroying()
							if flag19 then
								return
							end
							v46:doCleanup()
						end

						v46:insert(function()
							flag19 = true
						end)

						v46:insert(v47.Destroying:Connect(onDestroying))
						return v47
					end
				end)()
			)
		end,
		[18] = function()
			local v, instance, v43 = fn23(18)

			return (
				(function()
					local packages = instance.Parent.Parent.Parent.packages
					local v44 = v43(packages.fusion)
					local v45 = v43(packages.states)
					local v46 = v43(instance.Parent.Parent.Parent.utils.animate)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local v47 = v43(instance.Parent.suggestion)
					local v48 = v43(instance.Parent.Parent.Parent.storage.theme)
					local children = v44.Children
					local n = 0.999

					return function(arg)
						local v49 = (arg or scope):innerScope()

						local v50 = v49:Computed(function(arg2)
							return #arg2(v45.Suggestions) > 0
								and arg2(v45.CommandBarOpened)
								and #arg2(v45.CommandBarText) > 1
						end)

						local v51 = v49:Computed(function(arg2)
							return #arg2(v45.Suggestions) > 0
						end)

						local v52 = v49:Computed(function(arg2)
							if not arg2(v51) then
								return UDim2.new(0.5, 0, 0, 200)
							end

							if arg2(v50) then
								return UDim2.new(0.5, 0, 0, 180)
							end
							return UDim2.new(0.5, 0, 0, 200)
						end)

						local v53 = v46(function(arg2)
							return arg2(v50) and 0.02 or 1
						end, 45, 1.2, v49)

						local tbl14 = {
							Name = "UIStroke",
							Color = v48.BgTertiary,
							Thickness = 2.5,
							Transparency = v46(function(arg2)
								return arg2(v50) and 0.6 or 1
							end, 45, 1.2, v49),
						}

						return (
							v49:New("CanvasGroup")({
								Name = "Suggestions",
								AnchorPoint = Vector2.new(0.5, 0),
								BackgroundColor3 = v48.BgPrimary,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Position = v52,
								Size = UDim2.new(1, -24, 1, -190),
								GroupTransparency = v53,
								Visible = v49:Computed(function(arg2)
									if arg2(v50) then
										return true
									end

									if not arg2(v45.AnimationsEnabled) then
										return false
									end
									return arg2(v53) < n
								end),
								[children] = {
									v49:New("UISizeConstraint")({ MaxSize = Vector2.new(517, 300) }),
									v49:New("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 10) }),
									v49:New("UIStroke")(tbl14),
									v49:New("ScrollingFrame")({
										Name = "ScrollingFrame",
										Active = v50,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Size = UDim2.fromScale(1, 1),
										AutomaticCanvasSize = Enum.AutomaticSize.Y,
										CanvasSize = UDim2.fromScale(0, 0),
										ScrollBarThickness = 6,
										[children] = {
											v49:New("Frame")({
												Name = "Sizing",
												AutomaticSize = Enum.AutomaticSize.Y,
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Size = UDim2.fromScale(1, 0),
												[children] = {
													v49:New("UIListLayout")({
														Name = "UIListLayout",
														Padding = UDim.new(0, 8),
														SortOrder = Enum.SortOrder.LayoutOrder,
													}),
													v49:New("UIPadding")({
														Name = "UIPadding",
														PaddingBottom = UDim.new(0, 8),
														PaddingLeft = UDim.new(0, 8),
														PaddingRight = UDim.new(0, 8),
														PaddingTop = UDim.new(0, 8),
													}),
													v49:ForPairs(v45.Suggestions, function(arg2, arg3, arg4, arg5)
														return arg4,
															v47({
																Scope = arg3,
																name = arg5.name,
																description = arg5.description,
																types = arg5.types,
																top = arg5.top,
															})
													end),
												},
											}),
										},
									}),
								},
							})
						)
					end
				end)()
			)
		end,
		[19] = function()
			local v, instance, v43 = fn23(19)

			return (
				(function()
					local packages = instance.Parent.Parent.packages
					local v44 = v43(packages.fusion)
					local v45 = v43(packages.states)
					local v46 = v43(instance.Parent.Parent.utils.animate)
					local v47 = v43(instance.Parent.Parent.Internal)
					local v48 = v43(instance.Parent.Parent.storage.theme)
					local scope = v47.Scope
					local children = v44.Children
					local n = 0.999

					return function(arg)
						local v49 = (arg or scope):innerScope()

						local v50 = v49:Computed(function(arg2)
							local v50 = arg2(v45.Keybinds)
							local tbl14 = {}

							for k, v51 in pairs(v50) do
								if v51.key and v51.key ~= "None" and v51.key ~= ". . ." then
									table.insert(tbl14, { id = k, key = v51.key, feature = v51.feature or "Unknown" })
								end
							end

							table.sort(tbl14, function(arg3, arg4)
								return arg3.feature < arg4.feature
							end)

							return tbl14
						end)

						local v51 = v49:Computed(function(arg2)
							return #arg2(v50) > 0
						end)

						local function fn24(arg2)
							local v52 = v49:Computed(function(arg3)
								return arg3(v45.ActiveKeybinds)[arg2.id] == true
							end)

							local v53 = v49:Computed(function(arg3)
								return arg3(v52) and arg3(v48.AccentPrimary) or arg3(v48.FgPrimary)
							end)

							return v49:New("Frame")({
								Size = UDim2.new(1, 0, 0, 16),
								BackgroundTransparency = 1,
								[children] = {
									v49:New("TextLabel")({
										Size = UDim2.new(1, -30, 1, 0),
										Position = UDim2.new(0, 0, 0, 0),
										BackgroundTransparency = 1,
										Text = arg2.feature,
										TextColor3 = v53,
										TextSize = 11,
										Font = Enum.Font.GothamMedium,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextTruncate = Enum.TextTruncate.AtEnd,
									}),
									v49:New("TextLabel")({
										Size = UDim2.new(0, 28, 1, 0),
										Position = UDim2.new(1, 0, 0, 0),
										AnchorPoint = Vector2.new(1, 0),
										BackgroundTransparency = 1,
										Text = v49:Computed(function()
											return "[" .. arg2.key .. "]"
										end),
										TextColor3 = v53,
										TextSize = 11,
										Font = Enum.Font.GothamMedium,
										TextXAlignment = Enum.TextXAlignment.Right,
									}),
								},
							})
						end

						local v52 = v49:Computed(function(arg2)
							return arg2(v51) and arg2(v45.KeybindViewerVisible)
						end)

						local v53 = v46(function(arg2)
							return arg2(v52) and 0 or 1
						end, 25, 1, v49)

						local v54 = v46(function(arg2)
							return arg2(v52) and UDim2.new(1, -16, 0.5, 0) or UDim2.new(1, 200, 0.5, 0)
						end, 15, 0.80000000000000004, v49)

						local forValues = v49.ForValues

						return (
							v49:New("CanvasGroup")({
								Name = "KeybindViewer",
								Size = UDim2.new(0, 180, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								Position = v54,
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundColor3 = v48.BgPrimary,
								GroupTransparency = v53,
								Visible = v49:Computed(function(arg2)
									if arg2(v52) then
										return true
									end

									if not arg2(v45.AnimationsEnabled) then
										return false
									end
									return arg2(v53) < n
								end),
								[children] = {
									v49:New("UICorner")({ CornerRadius = UDim.new(0, 4) }),
									v49:New("UIStroke")({ Color = v48.BgTertiary, Thickness = 1 }),
									v49:New("UIPadding")({
										PaddingTop = UDim.new(0, 3),
										PaddingBottom = UDim.new(0, 3),
										PaddingLeft = UDim.new(0, 3),
										PaddingRight = UDim.new(0, 3),
									}),
									v49:New("Frame")({
										Size = UDim2.new(1, 0, 0, 0),
										AutomaticSize = Enum.AutomaticSize.Y,
										BackgroundColor3 = v48.BgPrimaryHighlight,
										[children] = {
											v49:New("UICorner")({ CornerRadius = UDim.new(0, 4) }),
											v49:New("UIStroke")({ Color = v48.BgTertiary, Thickness = 1 }),
											v49:New("UIPadding")({
												PaddingTop = UDim.new(0, 4),
												PaddingBottom = UDim.new(0, 4),
												PaddingLeft = UDim.new(0, 6),
												PaddingRight = UDim.new(0, 6),
											}),
											v49:New("UIListLayout")({
												SortOrder = Enum.SortOrder.LayoutOrder,
												Padding = UDim.new(0, 1),
											}),
											forValues(v49, v50, function(arg2, arg3, arg4)
												return fn24(arg4)
											end),
										},
									}),
								},
							})
						)
					end
				end)()
			)
		end,
		[21] = function()
			local v, instance, v43 = fn23(21)

			return (
				(function()
					local utils = instance.Parent.Parent.Parent.utils
					local v44 = v43(utils.insertitem)
					local v45 = v43(utils.removeitem)
					local v46 = v43(utils.animate)
					local v47 = v43(utils.color3)
					local v48 = v43(utils.images)
					local v49 = v43(utils.pendingTasks)
					local packages = instance.Parent.Parent.Parent.packages
					local v50 = v43(packages.fusion)
					local v51 = v43(packages.states)
					local peek = v50.peek
					local out = v50.Out
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local children = v50.Children
					local v52 = v43(instance.Parent.Parent.Parent.storage.theme)

					local tbl14 = {
						success = "StatusSuccessIcon",
						error = "StatusErrorIcon",
						danger = "StatusErrorIcon",
						warning = "StatusWarningIcon",
						info = "StatusInfoIcon",
					}

					local tbl15 = {}

					return {
						New = function(arg, arg2, arg3)
							local v53 = (arg3 or scope):innerScope()
							tbl15[v53] = true
							arg2.Duration = arg2.Duration or 5
							local str7 = tbl14[arg2.Type] or "StatusInfoIcon"
							local v54 = v53:Value(UDim2.fromOffset(0, 16))
							local v55 = v53:Value(UDim2.new(0, 0, 0, 0))
							local v56 = v53:Value(UDim2.new(1, 15, 0, 3))
							local v57 = v53:Value(Vector2.zero)
							local v58 = v53:Value(0)
							local v59 =
								v53:Tween(v58, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
							local v60 = v53:Value()
							local flag19 = false
							local flag20 = false

							local function fn24()
								return math.max(30, peek(v57).Y) + 30
							end

							local function fn25()
								if flag19 and not flag20 then
									v55:set(UDim2.new(1, 0, 0, fn24()))
								end
							end

							v53:Observer(v57):onChange(fn25)
							local v61 = v48
							local track = v61.Track

							local v62 = v53:New("Frame")({
								Name = "Notification",
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = v46(function(arg4)
									return arg4(v55)
								end, 20, 1.2, v53),
								[children] = {
									v60:set(v53:New("CanvasGroup")({
										Name = "Object",
										BackgroundColor3 = v52.BgPrimaryHighlight,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										GroupTransparency = v53:Computed(function(arg4)
											return 1 - math.clamp(arg4(v59), 0, 1)
										end),
										Size = v53:Computed(function(arg4)
											return UDim2.new(1, -2, 0, math.max(30, arg4(v57).Y) + 30)
										end),
										Position = v46(function(arg4)
											return arg4(v54)
										end, 30, 1.2, v53),
										[children] = {
											v53:New("UIScale")({
												Scale = v53:Computed(function(arg4)
													return 0.97 + 0.029999999999999999 * math.clamp(arg4(v59), 0, 1)
												end),
											}),
											v53:New("UICorner")({ Name = "UICorner" }),
											v53:New("Frame")({
												Name = "Holder",
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.fromOffset(55, 0),
												Size = UDim2.new(1, -60, 1, 0),
												[children] = {
													v53:New("UIListLayout")({
														Name = "UIListLayout",
														Padding = UDim.new(0, 3),
														SortOrder = Enum.SortOrder.LayoutOrder,
														[out("AbsoluteContentSize")] = v57,
													}),
													v53:New("TextLabel")({
														Name = "Title",
														FontFace = Font.new(
															"rbxassetid://12187365364",
															Enum.FontWeight.Bold,
															Enum.FontStyle.Normal
														),
														RichText = true,
														Text = arg2.Title,
														TextColor3 = v52.FgPrimary,
														TextSize = 16,
														TextXAlignment = Enum.TextXAlignment.Left,
														AutomaticSize = Enum.AutomaticSize.Y,
														BackgroundColor3 = Color3.fromRGB(255, 255, 255),
														BackgroundTransparency = 1,
														BorderColor3 = Color3.fromRGB(0, 0, 0),
														BorderSizePixel = 0,
														Size = UDim2.fromScale(1, 0),
														ZIndex = 3,
													}),
													v53:New("TextLabel")({
														Name = "Description",
														FontFace = Font.new(
															"rbxassetid://12187365364",
															Enum.FontWeight.Medium,
															Enum.FontStyle.Normal
														),
														RichText = true,
														Text = arg2.Description,
														TextColor3 = v52.FgSecondary,
														TextSize = 15,
														TextWrapped = true,
														TextXAlignment = Enum.TextXAlignment.Left,
														AutomaticSize = Enum.AutomaticSize.Y,
														BackgroundColor3 = Color3.fromRGB(255, 255, 255),
														BackgroundTransparency = 1,
														BorderColor3 = Color3.fromRGB(0, 0, 0),
														BorderSizePixel = 0,
														Size = UDim2.fromScale(1, 0),
														ZIndex = 3,
													}),
												},
											}),
											v53:New("Frame")({
												Name = "Circle",
												AnchorPoint = Vector2.new(0, 0.5),
												BackgroundColor3 = v53:Computed(function(arg4)
													return v47.lightenRGB(arg4(v52.BgPrimaryHighlight), 8)
												end),
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.new(0, 15, 0.5, 0),
												Size = UDim2.fromOffset(30, 30),
												[children] = {
													v53:New("UICorner")({
														Name = "UICorner",
														CornerRadius = UDim.new(1, 0),
													}),
													track(
														v61,
														str7,
														v53:New("ImageLabel")({
															Name = "Icon",
															Image = v48[str7],
															ImageColor3 = v53:Computed(function(arg4)
																local type_ = arg2.Type
																local v62

																if type_ == "info" then
																	v62 = arg4(v52.AccentPrimary)
																elseif type_ == "error" then
																	v62 = arg4(v52.AccentDestructive)
																elseif type_ == "warning" then
																	v62 = arg4(v52.AccentCaution)
																else
																	v62 = nil

																	if type_ == "success" then
																		v62 = arg4(v52.Success)
																	end
																end

																return v62
															end),
															AnchorPoint = Vector2.new(0.5, 0.5),
															BackgroundColor3 = Color3.fromRGB(255, 255, 255),
															BackgroundTransparency = 1,
															BorderColor3 = Color3.fromRGB(0, 0, 0),
															BorderSizePixel = 0,
															Position = UDim2.fromScale(0.5, 0.5),
															Size = UDim2.fromOffset(20, 20),
															[children] = {
																v53:New("UICorner")({
																	Name = "UICorner",
																	CornerRadius = UDim.new(1, 0),
																}),
															},
														})
													),
												},
											}),
											v53:New("UIPadding")({
												Name = "UIPadding",
												PaddingBottom = UDim.new(0, 15),
												PaddingRight = UDim.new(0, 15),
												PaddingTop = UDim.new(0, 15),
											}),
											v53:New("Frame")({
												Name = "Frame",
												AnchorPoint = Vector2.new(0, 1),
												BackgroundColor3 = v53:Computed(function(arg4)
													local type_ = arg2.Type
													local v62

													if type_ == "info" then
														v62 = arg4(v52.AccentPrimary)
													elseif type_ == "error" then
														v62 = arg4(v52.AccentDestructive)
													elseif type_ == "warning" then
														v62 = arg4(v52.AccentCaution)
													else
														v62 = nil

														if type_ == "success" then
															v62 = arg4(v52.Success)
														end
													end

													return v62
												end),
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.new(0, 0, 1, 15),
												Size = v53:Tween(
													v53:Computed(function(arg4)
														return arg4(v56)
													end),
													TweenInfo.new(arg2.Duration, Enum.EasingStyle.Linear)
												),
											}),
											v53:New("UIStroke")({
												Name = "UIStroke",
												Color = Color3.fromRGB(50, 50, 50),
												Thickness = 2.5,
												Transparency = v53:Computed(function(arg4)
													return 1 - 0.4 * math.clamp(arg4(v59), 0, 1)
												end),
											}),
										},
									})),
								},
							})

							local flag21 = false
							local delay = nil
							local v63 = nil

							local function fn26()
								if flag21 then
									return
								end
								flag21 = true
								v53:doCleanup()
							end

							if not peek(v51.Library).SilentMode then
								v44(v51.Notifications, v62)
							end

							v53:insert(function()
								flag21 = true
								tbl15[v53] = nil
								v45(v51.Notifications, v62)

								if delay ~= nil and coroutine.running() ~= delay then
									v49.cancel(delay)
								end

								delay = nil

								if v63 ~= nil and coroutine.running() ~= v63 then
									v49.cancel(v63)
								end

								v63 = nil
							end)

							v53:insert(v62.Destroying:Connect(function()
								if v63 == nil then
									v63 = v49.defer(function()
										v63 = nil
										fn26()
									end)
								end
							end))

							local function fn27()
								if peek(v51.Library).Unloaded then
									fn26()
									return
								end
								local instance2 = peek(v60)
								if not instance2 or not instance2.Parent then
									fn26()
									return
								end
								flag19 = true
								fn25()
								task.wait(0.20000000000000001)
								if flag21 or peek(v51.Library).Unloaded then
									fn26()
									return
								end
								v54:set(UDim2.fromScale(0, 0))
								v58:set(1)
								v56:set(UDim2.fromOffset(0, 3))
								task.wait(arg2.Duration)
								if flag21 or peek(v51.Library).Unloaded then
									fn26()
									return
								end
								flag20 = true
								v58:set(0)
								v54:set(UDim2.fromOffset(0, 8))
								task.wait(0.25)
								if flag21 or peek(v51.Library).Unloaded then
									fn26()
									return
								end
								v55:set(UDim2.new(1, 0, 0, -12))
								task.wait(0.35)
								fn26()
							end

							delay = v49.delay
							delay = delay(0.10000000000000001, fn27)
							return v62
						end,
						cleanup = function()
							for k in pairs(tbl15) do
								k:doCleanup()
							end

							tbl15 = {}
						end,
					}
				end)()
			)
		end,
		[22] = function()
			local v, instance, v43 = fn23(22)

			return (
				(function()
					local packages = instance.Parent.Parent.Parent.packages
					local v44 = v43(packages.fusion)
					local v45 = v43(packages.states)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local children = v44.Children

					return function(arg)
						local scope2 = arg or scope

						return scope2:New("Frame")({
							Name = "NotificationHolder",
							AnchorPoint = Vector2.new(1, 1),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(1, 1),
							Size = UDim2.new(1, -20, 1, 0),
							ZIndex = 100,
							[children] = {
								scope2:New("UISizeConstraint")({ MaxSize = Vector2.new(300, 100000) }),
								scope2:New("UIListLayout")({
									Name = "UIListLayout",
									Padding = UDim.new(0, 7),
									HorizontalAlignment = Enum.HorizontalAlignment.Right,
									SortOrder = Enum.SortOrder.LayoutOrder,
									VerticalAlignment = Enum.VerticalAlignment.Bottom,
								}),
								scope2:New("UIPadding")({
									Name = "UIPadding",
									PaddingBottom = UDim.new(0, 10),
									PaddingRight = UDim.new(0, 10),
								}),
								scope2:ForPairs(v45.Notifications, function(arg2, arg3, arg4, arg5)
									return arg4, arg5
								end),
							},
						})
					end
				end)()
			)
		end,
		[23] = function()
			local v, v43, v44 = fn23(23)

			return (
				(function()
					return {
						v44(v43.accordion),
						v44(v43.button),
						v44(v43.colorpicker),
						v44(v43.dropdown),
						v44(v43.input),
						v44(v43.keybind),
						v44(v43.separator),
						v44(v43.slider),
						v44(v43.table),
						v44(v43.text),
						v44(v43.toggle),
					}
				end)()
			)
		end,
		[24] = function()
			local v, instance, v43 = fn23(24)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent
					local utils = parent.utils
					local v44 = v43(utils.insertitem)
					local v45 = v43(utils.safecallback)
					local v46 = v43(parent.packages.fusion)
					local v47 = v43(parent.Internal)
					local v48 = v43(parent.utils.controlRegistry)
					local scope = v47.Scope
					local peek = v46.peek
					local v49 = v43(instance.constants)
					local v50 = v43(instance.model)
					local v51 = v43(instance.view)
					local v52 = v43(instance.interactions)

					local index = {}
					index.__index = index
					index.__type = "Accordion"

					index.New = function(arg, arg2, arg3, arg4)
						local tbl14 = arg4 or {}
						local v53 = (arg2.Scope or scope):innerScope()

						local tbl15 = {
							AllowMultiple = tbl14.AllowMultiple == true,
							Indent = tbl14.Indent or v49.Defaults.Indent,
							_onChange = nil,
							_nodesById = {},
							_flatOrder = {},
						}

						tbl15.ItemsState = v53:Value(table.freeze({}))
						tbl15.Root = nil

						local function fn24(arg5, arg6)
							if tbl15._onChange then
								v45(function()
									tbl15._onChange(arg5, arg6)
								end)
							end
						end

						local function fn25(arg5)
							local state, nodesById, flatOrder = v50.buildState(v53, arg5)
							v50.freezeItems(state)
							tbl15._nodesById = nodesById
							tbl15._flatOrder = flatOrder
							tbl15.ItemsState:set(state)
						end

						local v54 = v52.create({
							allowMultiple = function()
								return tbl15.AllowMultiple
							end,
							getNodesById = function()
								return tbl15._nodesById
							end,
							getFlatOrder = function()
								return tbl15._flatOrder
							end,
							emitChange = fn24,
						})

						tbl15.SetItems = function(arg5, arg6)
							fn25(arg6)
						end

						tbl15.AddSection = function(arg5, arg6)
							local v55 = table.clone(peek(arg5.ItemsState))
							table.insert(v55, v50.normalizeItem(arg6))
							fn25(v55)
						end

						tbl15.RemoveSection = function(arg5, arg6)
							local v55 = table.clone(peek(arg5.ItemsState))
							local tbl16 = {}

							for _, v56 in ipairs(v55) do
								if tostring(v56.id) ~= tostring(arg6) then
									table.insert(tbl16, v56)
								end
							end

							fn25(tbl16)
						end

						tbl15.Toggle = function(arg5, arg6, arg7)
							v54.toggle(arg6, arg7)
						end

						tbl15.Open = function(arg5, arg6)
							arg5:Toggle(arg6, true)
						end

						tbl15.Close = function(arg5, arg6)
							arg5:Toggle(arg6, false)
						end

						tbl15.OpenAll = function(arg5, arg6)
							v54.openAll(arg6)
						end

						tbl15.CloseAll = function(arg5, arg6)
							v54.closeAll(arg6)
						end

						tbl15.OnChange = function(arg5, onChange)
							arg5._onChange = onChange
						end

						tbl15.Render = function(arg5, arg6)
							local root = v51.build({
								scope = arg6,
								itemsState = tbl15.ItemsState,
								indent = tbl15.Indent,
								getNodeState = function(arg7)
									return tbl15._nodesById[tostring(arg7)]
								end,
								getNodesById = function()
									return tbl15._nodesById
								end,
								toggle = v54.toggle,
							})

							tbl15.Root = root
							return root
						end

						fn25(tbl14.Items or {})
						v44(arg2.Container, tbl15)

						v48.registerControl({
							optionKey = arg3,
							element = tbl15,
							type = "Accordion",
							title = tbl14.Title,
							description = tbl14.Description,
							context = arg2.AgentContext,
						})

						return tbl15
					end

					return index
				end)()
			)
		end,
		[25] = function()
			fn23(25)

			return (function()
				local freeze = table.freeze

				return table.freeze({
					Sizes = table.freeze({ HeaderHeight = 32, Chevron = Vector2.new(20, 20) }),
					Padding = freeze({
						Header = table.freeze({ Left = 12, Right = 8 }),
						Content = table.freeze({ Left = 12, Right = 8, Top = 6, Bottom = 8 }),
					}),
					Spacing = table.freeze({ Root = 6, Items = 4, Body = 8 }),
					Animation = table.freeze({ BodySpeed = 30, BodyDamping = 1, ChevronSpeed = 25, ChevronDamping = 1 }),
					Defaults = table.freeze({ Indent = 10 }),
				})
			end)()
		end,
		[26] = function()
			local v, instance, v43 = fn23(26)

			return (
				(function()
					local peek = v43(instance.Parent.Parent.Parent.Parent.packages.fusion).peek

					return {
						create = function(arg)
							local function fn24(level, arg2)
								local nodesById = arg.getNodesById()
								local v44 = ipairs
								local tbl14 = arg.getFlatOrder()[level] or {}

								for _, v45 in v44(tbl14) do
									if tostring(v45.id) ~= tostring(arg2) then
										local v46 = nodesById[tostring(v45.id)]

										if v46 then
											v46.isOpen:set(false)
										end
									end
								end
							end

							return {
								toggle = function(arg2, arg3)
									local v44 = arg.getNodesById()[tostring(arg2)]
									if not v44 then
										return false
									end

									if arg3 == nil then
										arg3 = not peek(v44.isOpen)
									end

									if arg3 and not arg.allowMultiple() then
										fn24(v44.level or 0, arg2)
									end

									v44.isOpen:set(arg3)
									arg.emitChange(arg2, arg3)
									return true
								end,
								openAll = function(arg2)
									local nodesById = arg.getNodesById()

									if arg2 == nil then
										for _, v44 in pairs(nodesById) do
											v44.isOpen:set(true)
										end

										return
									end

									local v44 = ipairs
									local tbl14 = arg.getFlatOrder()[arg2] or {}

									for _, v45 in v44(tbl14) do
										local v46 = nodesById[tostring(v45.id)]

										if v46 then
											v46.isOpen:set(true)
										end
									end
								end,
								closeAll = function(arg2)
									local nodesById = arg.getNodesById()

									if arg2 == nil then
										for _, v44 in pairs(nodesById) do
											v44.isOpen:set(false)
										end

										return
									end

									local v44 = ipairs
									local tbl14 = arg.getFlatOrder()[arg2] or {}

									for _, v45 in v44(tbl14) do
										local v46 = nodesById[tostring(v45.id)]

										if v46 then
											v46.isOpen:set(false)
										end
									end
								end,
							}
						end,
					}
				end)()
			)
		end,
		[27] = function()
			fn23(27)

			return (
				(function()
					local function fn24(arg)
						local tbl14 = {
							id = tostring(arg.id or arg.title or "acc-" .. tostring(math.random(1, 1e9))),
							title = arg.title or "Untitled",
							open = arg.open == true,
							content = arg.content,
							collapsibles = {},
						}

						local v = ipairs
						local collapsibles = arg.collapsibles or {}

						for _, collapsible in v(collapsibles) do
							table.insert(tbl14.collapsibles, fn24(collapsible))
						end

						return tbl14
					end

					local tbl14 = {
						normalizeItem = fn24,
						normalizeItems = function(arg)
							local tbl14 = {}
							local v = ipairs
							local tbl15 = arg or {}

							for _, v43 in v(tbl15) do
								table.insert(tbl14, fn24(v43))
							end

							return tbl14
						end,
					}

					local function fn25(arg, levels, arg2, level, arg3)
						levels[level] = levels[level] or {}

						for _, v in ipairs(arg2) do
							local str7 = tostring(v.id)
							local v43 = arg[str7]

							if not v43 then
								arg[str7] = { isOpen = arg3:Value(v.open == true), parent = nil, level = level }
							else
								v43.level = level
							end

							arg[str7].level = level
							table.insert(levels[level], v)

							if v.collapsibles and #v.collapsibles > 0 then
								fn25(arg, levels, v.collapsibles, level + 1, arg3)
							end
						end
					end

					tbl14.buildState = function(arg, arg2)
						local v = tbl14.normalizeItems(arg2)
						local tbl15 = {}
						local tbl16 = {}
						fn25(tbl15, tbl16, v, 0, arg)
						return v, tbl15, tbl16
					end

					tbl14.freezeItems = function(arg)
						local function fn26(arg2)
							for _, v in ipairs(arg2) do
								if v.collapsibles and #v.collapsibles > 0 then
									fn26(v.collapsibles)
								end

								table.freeze(v)
							end

							table.freeze(arg2)
						end

						fn26(arg)
						return arg
					end

					return tbl14
				end)()
			)
		end,
		[28] = function()
			local v, instance, v43 = fn23(28)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.utils.animate)
					local v46 = v43(parent.storage.theme)
					local v47 = v43(parent.utils.images)
					local track = v43(instance.Parent.constants)
					local v48 = v43(instance.Parent.Parent.shared)
					local children = v44.Children
					local onEvent = v44.OnEvent
					local onChange = v44.OnChange

					local function fn24(arg, arg2, arg3, arg4)
						return v45(arg2, arg3, arg4, arg)
					end

					local function fn25(arg, arg2, nodesById)
						local content = arg2.content
						if type(content) == "function" then
							return content(arg:innerScope(), arg2, nodesById)
						end

						if type(content) == "string" then
							return arg:New("TextLabel")({
								Name = "ContentText",
								FontFace = v48.Fonts.Body,
								RichText = true,
								Text = content,
								TextColor3 = v46.FgSecondary,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
							})
						end

						return content
					end

					local function fn26(arg, arg2, arg3, arg4)
						local nodeState = arg.getNodeState(arg2.id)
						if not nodeState then
							return nil
						end
						local v49 = arg4:Value(0)

						local v50 = arg4:Computed(function(arg5)
							return arg5(nodeState.isOpen) and arg5(v49) or 0
						end)

						local v51 = fn24(arg4, function(arg5)
							return UDim2.new(1, 0, 0, arg5(v50))
						end, track.Animation.BodySpeed, track.Animation.BodyDamping)

						local v52 = fn24(arg4, function(arg5)
							return arg5(nodeState.isOpen) and 180 or 0
						end, track.Animation.ChevronSpeed, track.Animation.ChevronDamping)

						local v53 = v47
						local track2 = v53.Track

						local v54 = arg4:New("TextButton")({
							Name = "Header",
							FontFace = v48.Fonts.Title,
							Text = "",
							TextXAlignment = Enum.TextXAlignment.Left,
							TextColor3 = v46.FgSecondary,
							AutoButtonColor = false,
							BackgroundColor3 = v46.BgPrimary,
							BackgroundTransparency = 0,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, track.Sizes.HeaderHeight),
							LayoutOrder = 1,
							[children] = {
								arg4:New("UIPadding")({
									PaddingLeft = UDim.new(0, track.Padding.Header.Left),
									PaddingRight = UDim.new(0, track.Padding.Header.Right),
								}),
								arg4:New("Frame")({
									Name = "Row",
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Size = UDim2.new(1, -28, 1, 0),
									[children] = {
										arg4:New("UIListLayout")({
											FillDirection = Enum.FillDirection.Horizontal,
											SortOrder = Enum.SortOrder.LayoutOrder,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											Padding = UDim.new(0, 8),
										}),
										arg4:New("TextLabel")({
											Name = "Title",
											FontFace = v48.Fonts.Title,
											Text = arg2.title,
											TextColor3 = v46.FgSecondary,
											TextXAlignment = Enum.TextXAlignment.Left,
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											AutomaticSize = Enum.AutomaticSize.Y,
											Size = UDim2.fromScale(1, 1),
										}),
									},
								}),
								track2(
									v53,
									"ChevronDownIcon",
									arg4:New("ImageLabel")({
										Name = "Chevron",
										Image = v47.ChevronDownIcon,
										ImageColor3 = v46.FgTertiary,
										AnchorPoint = Vector2.new(1, 0.5),
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Position = UDim2.new(1, -2, 0.5, 0),
										Size = UDim2.fromOffset(track.Sizes.Chevron.X, track.Sizes.Chevron.Y),
										Rotation = v52,
										LayoutOrder = 999,
									})
								),
							},
							[onEvent("Activated")] = function()
								arg.toggle(arg2.id)
							end,
						})

						local tbl14 = {}
						local v55 = fn25(arg4, arg2, arg.getNodesById())

						if v55 then
							table.insert(tbl14, v55)
						end

						if arg2.collapsibles and #arg2.collapsibles > 0 then
							local v56 = arg4:ForValues(arg2.collapsibles, function(arg5, arg6, arg7)
								return fn26(arg, arg7, arg3 + 1, arg6)
							end)

							table.insert(tbl14, v56)
						end

						local v56 = arg4:New("Frame")({
							Name = "Body",
							AutomaticSize = Enum.AutomaticSize.None,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ClipsDescendants = true,
							Size = v51,
							LayoutOrder = 3,
							[children] = {
								arg4:New("Frame")({
									Name = "Content",
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Size = UDim2.fromScale(1, 0),
									[children] = {
										arg4:New("UIPadding")({
											PaddingLeft = UDim.new(0, track.Padding.Content.Left),
											PaddingRight = UDim.new(0, track.Padding.Content.Right),
											PaddingTop = UDim.new(0, track.Padding.Content.Top),
											PaddingBottom = UDim.new(0, track.Padding.Content.Bottom),
										}),
										arg4:New("UIListLayout")({
											SortOrder = Enum.SortOrder.LayoutOrder,
											Padding = UDim.new(0, track.Spacing.Body),
										}),
										tbl14,
									},
									[onChange("AbsoluteSize")] = function(arg5)
										v49:set(arg5.Y)
									end,
								}),
							},
						})

						return arg4:New("Frame")({
							Name = "Item_" .. arg2.id,
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundColor3 = v46.BgPrimaryHighlight,
							BackgroundTransparency = 0,
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 0),
							[children] = {
								arg4:New("UIListLayout")({ SortOrder = Enum.SortOrder.LayoutOrder }),
								arg4:New("UIStroke")({
									Color = v46.BgTertiary,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								}),
								v54,
								arg4:New("Frame")({
									Name = "Divider",
									BackgroundColor3 = v46.BgTertiary,
									BackgroundTransparency = 0.2,
									BorderSizePixel = 0,
									LayoutOrder = 2,
									Position = UDim2.fromOffset(12, 0),
									Size = UDim2.new(1, 0, 0, 1),
									Visible = arg4:Computed(function(arg5)
										return arg5(nodeState.isOpen)
									end),
								}),
								v56,
							},
						})
					end

					return {
						build = function(arg)
							local scope = arg.scope
							local forValues = scope.ForValues
							local itemsState = arg.itemsState

							return scope:New("Frame")({
								Name = "Accordion",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
								[children] = {
									scope:New("UIListLayout")({
										SortOrder = Enum.SortOrder.LayoutOrder,
										Padding = UDim.new(0, track.Spacing.Root),
									}),
									scope:New("Frame")({
										Name = "Items",
										AutomaticSize = Enum.AutomaticSize.Y,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.fromScale(1, 0),
										[children] = {
											scope:New("UIListLayout")({
												SortOrder = Enum.SortOrder.LayoutOrder,
												Padding = UDim.new(0, track.Spacing.Items),
											}),
											forValues(scope, itemsState, function(arg2, arg3, arg4)
												return fn26(arg, arg4, 0, arg3)
											end),
										},
									}),
								},
							})
						end,
					}
				end)()
			)
		end,
		[29] = function()
			local v, instance, v43 = fn23(29)

			return (function()
				local parent = instance.Parent.Parent.Parent
				local v44 = v43(parent.packages.fusion)
				local children = v44.Children
				local computed = v44.Computed
				local observer = v44.Observer
				local onEvent = v44.OnEvent
				local peek = v44.peek
				local spring = v44.Spring
				local value = v44.Value
				local fusionUtils = parent.utils.fusionUtils
				local constructorComponent = v43(fusionUtils.component).ConstructorComponent
				local v45 = v43(fusionUtils.combineProps)
				local extract = v43(parent.utils.tableUtils).Extract
				local str7 = "CourageHighlightGradient"
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromHex
				local colorSequence = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHex("#F8FAFC")),
					new(1, color("#09090b")),
				})
				local MouseEnter = onEvent("MouseEnter")
				local MouseMoved = onEvent("MouseMoved")
				local MouseLeave = onEvent("MouseLeave")

				local function fn24(arg, arg2)
					return arg + math.round((arg2 - arg) / 360) * 360
				end

				local function fn25(arg)
					return (arg + 180) % 360 - 180
				end

				local function fn26(guiObject, arg, arg2)
					local absoluteSize = guiObject.AbsoluteSize / 2
					if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
						return nil, nil
					end
					local vector = guiObject.AbsolutePosition + absoluteSize
					local vector2 = Vector2.new((arg - vector.X) / absoluteSize.X, (arg2 - vector.Y) / absoluteSize.Y)
					local magnitude = vector2.Magnitude
					if magnitude < 0.0001 then
						return nil, magnitude
					end
					local vector3 = vector2 * (1 / math.max(math.abs(vector2.X), math.abs(vector2.Y)))
					return math.deg(math.atan2(vector3.Y, vector3.X)) + 180, magnitude
				end

				return constructorComponent(function(arg, arg2, arg3)
					local v46, v47 = extract(arg3, "Enabled", true)
					local v48, v49 = extract(v46, "GradientColor")
					local gradientTransparency, v50 = extract(v48, "GradientTransparency", 0.78)
					local gradientProperty, v51 = extract(gradientTransparency, "GradientProperty", children)
					local defaultRotation, v52 = extract(gradientProperty, "DefaultRotation", 90)
					local centerLockRadius, v53 = extract(defaultRotation, "CenterLockRadius", 0.3)
					local centerReleaseRadius, v54 = extract(centerLockRadius, "CenterReleaseRadius", 0.45)
					local v55, v56 = extract(centerReleaseRadius, "FollowSpringSpeed", 18)
					local returnSpringSpeed, v57 = extract(v55, "ReturnSpringSpeed", 10)
					local springDamping, v58 = extract(returnSpringSpeed, "SpringDamping", 1)
					local rotationResponse, v59 = extract(springDamping, "RotationResponse", 1)
					local v60, v61 = extract(rotationResponse, MouseEnter)
					local v62, v63 = extract(v60, MouseMoved)
					local v64, v65 = extract(v62, MouseLeave)

					local v66 = computed(arg, function(arg4)
						return arg4(v47)
					end)

					local v67 = value(arg, false)
					local v68 = value(arg, peek(v52))
					local v69 = v61
					local v70 = v63
					local v71 = v65

					local rotation = spring(
						arg,
						v68,
						computed(arg, function(arg4)
							local v72

							if arg4(v67) then
								v72 = arg4(v56)
							else
								v72 = arg4(v57)
							end

							return v72
						end),
						v58
					)

					local UIGradient = arg:New("UIGradient")
					local tbl14 = { Name = str7, Type = Enum.GradientType.Linear, Offset = Vector2.zero }
					local colorSequence2

					if v49 == nil then
						colorSequence2 = colorSequence
					else
						colorSequence2 = computed(arg, function(arg4)
							return arg4(v49) or colorSequence
						end)
					end

					tbl14.Color = colorSequence2
					tbl14.Rotation = rotation

					tbl14.Transparency = computed(arg, function(arg4)
						return NumberSequence.new(arg4(v50))
					end)

					local v72 = UIGradient(tbl14)
					local v73 = peek(v52)
					local n = 1
					local v74 = nil
					local v75 = nil
					local v76 = nil

					local function fn27()
						v75 = nil
						v76 = nil
						n = 1
						v67:set(false)
						local v77 = fn24(peek(v52), peek(rotation))
						v73 = v77
						v68:set(v77)
					end

					local function fn28(arg4, arg5)
						if not peek(v66) then
							return
						end
						local v77 = v74
						if not v77 then
							return
						end
						local v78, v79 = fn26(v77, arg4, arg5)
						if not v78 or not v79 then
							return
						end
						local n27 = math.max(v53, 0)
						local n28 = math.max(v54, n27)

						if v79 <= n27 and not v76 then
							v76 = n
						elseif n28 <= v79 then
							v76 = nil
						end

						local v80 = v75
						local flag19 = v75

						if v80 then
							flag19 = not v76
						end

						if flag19 then
							local v81 = fn25(v78 - v80)

							if math.abs(v81) > 0.5 then
								n = math.sign(v81)
							end
						end

						v75 = v78
						local n29 = fn25(v78 - v73) * peek(v59)

						if v76 and math.abs(n29) > 90 then
							n29 = math.abs(n29) * v76
						end

						v73 += n29
						v67:set(true)
						v68:set(v73)
					end

					observer(arg, v66):onChange(function()
						if peek(v66) then
							return
						end
						fn27()
					end)

					local v77 = v64[MouseEnter]
					local v78 = v64[MouseMoved]
					local v79 = v64[MouseLeave]

					local v80 = v45(v64, {
						[v51] = v72,
						[MouseEnter] = function(arg4, arg5)
							fn28(arg4, arg5)

							if v69 then
								v69(arg4, arg5)
							end

							if v77 then
								v77(arg4, arg5)
							end
						end,
						[MouseMoved] = function(arg4, arg5)
							fn28(arg4, arg5)

							if v70 then
								v70(arg4, arg5)
							end

							if v78 then
								v78(arg4, arg5)
							end
						end,
						[MouseLeave] = function(arg4, arg5)
							fn27()

							if v71 then
								v71(arg4, arg5)
							end

							if v79 then
								v79(arg4, arg5)
							end
						end,
					})

					local v81 = arg2(arg, v80)
					v74 = v81
					return v81
				end)
			end)()
		end,
		[30] = function()
			local v, instance, v43 = fn23(30)

			return (
				(function()
					local utils = instance.Parent.Parent.Parent.utils
					local v44 = v43(utils.insertitem)
					local v45 = v43(utils.safecallback)
					local v46 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local v47 = v43(instance.Parent.Parent.Parent.utils.controlRegistry)
					local v48 = v43(instance.Parent.Parent.Parent.components.button)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local children = v46.Children

					local index = {}
					index.__index = index
					index.__type = "Button"

					index.New = function(arg, arg2, arg3, arg4)
						local v49

						if type(arg3) == "table" and arg4 == nil then
							v49 = nil
						else
							v49 = arg3
							arg3 = arg4
						end

						arg3 = arg3 or {}

						local v50 = v48.new({
							Callback = arg3.Callback,
							Type = arg3.Type,
							Title = arg3.Title,
							Tooltip = arg3.Tooltip,
							Scope = (arg2.Scope or scope):innerScope(),
						})

						local tbl14

						tbl14 = {
							Button = v50,
							Root = nil,
							Render = function(arg5, arg6)
								local root = arg6:New("Frame")({
									Name = "Button",
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = UDim2.fromScale(1, 0),
									[children] = { v50:Render(arg6) },
								})

								tbl14.Root = root
								return root
							end,
						}

						v44(arg2.Container, tbl14)

						v47.registerControl({
							optionKey = v49,
							element = v50,
							type = "Button",
							title = arg3.Title,
							description = arg3.Description,
							context = arg2.AgentContext,
							style = arg3.Type,
							risk = "execution",
							trigger = function()
								v45(function()
									v50.Callback()
								end)
							end,
						})

						return v50
					end

					return index
				end)()
			)
		end,
		[31] = function()
			local v, instance, v43 = fn23(31)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent
					local utils = parent.utils
					local v44 = v43(utils.insertitem)
					local v45 = v43(utils.safecallback)
					local v46 = v43(utils.pendingTasks)
					local packages = parent.packages
					local v47 = v43(packages.fusion)
					local v48 = v43(parent.Internal)
					local v49 = v43(packages.states)
					local v50 = v43(parent.utils.controlRegistry)
					local v51 = v43(instance.interactions)
					local v52 = v43(instance.view)
					local v53 = v43(instance.utils)
					local userInputService = v43(parent.utils.services).UserInputService
					local scope = v48.Scope
					local peek = v47.peek
					local doCleanup = v47.doCleanup

					local index = {}
					index.__index = index
					index.__type = "Colorpicker"

					index.New = function(arg, arg2, arg3, arg4)
						local tbl14 = arg4 or {}
						local renderMode = tbl14.RenderMode or "standalone"
						local flag19 = renderMode == "addon"
						local v54 = (arg2.Scope or scope):innerScope()
						local default = tbl14.Default or Color3.fromRGB(255, 255, 255)
						local hue, saturation, value = Color3.toHSV(default)
						local v55 = v54:Value(default)
						local v56 = v54:Value(false)
						local v57 = v54:Value(hue)
						local v58 = v54:Value(saturation)
						local v59 = v54:Value(value)
						local v60 = v54:Value(false)
						local v61 = v54:Value(false)
						local v62 = v54:Value(false)
						local v63 = v54:Value(0)
						local v64 = v54:Value(0)
						local v65 = v54:Value(false)
						local v66 = v54:Value(false)
						local v67 = v54:Value(false)
						local tbl15 =
							{ activeSessionScope = nil, pickerCreated = false, interactions = nil, viewScope = nil }

						local tbl16 = {
							Root = nil,
							ColorpickerFrame = nil,
							Holder = nil,
							HSV = nil,
							HSVDrag = nil,
							Slider = nil,
							SliderDrag = nil,
							HexRGBContainer = nil,
							Hex = nil,
							RGB = nil,
							Submit = nil,
							Visualize = nil,
							HoverStroke = nil,
						}

						local tbl17 = {
							Title = v54:Value(tbl14.Title),
							Description = v54:Value(tbl14.Description),
							Value = default,
							Type = "Colorpicker",
							RenderMode = renderMode,
							Callback = tbl14.Callback or function() end,
							Changed = function() end,
							Opened = v56,
							H = hue,
							S = saturation,
							V = value,
							Refs = tbl16,
							Destroy = function()
								if tbl15.activeSessionScope then
									doCleanup(tbl15.activeSessionScope)
									tbl15.activeSessionScope = nil
								end

								doCleanup(v54)
							end,
						}

						local function fn24(h, s, v68)
							local v69 = tbl17
							local v70 = tbl17
							tbl17.H = h
							v69.S = s
							v70.V = v68
							v57:set(h)
							v58:set(s)
							v59:set(v68)
						end

						tbl17.SetHSVFromRGB = function(arg5, arg6)
							local hue2, saturation2, value2 = Color3.toHSV(arg6)
							fn24(hue2, saturation2, value2)
							return hue2, saturation2, value2
						end

						local function fn25()
							if not tbl16.Hex and not tbl16.RGB then
								return
							end
							local hex = tbl16.Hex and peek(tbl16.Hex) or nil
							local rgb = tbl16.RGB and peek(tbl16.RGB) or nil
							if not hex and not rgb then
								return
							end
							local v68 = peek(v57)
							local v69 = peek(v58)
							local v70 = peek(v59)
							local color = Color3.fromHSV(v68, v69, v70)

							if hex and not peek(v66) then
								hex.Text = v53.color3ToHex(color)
							end

							if rgb and not peek(v67) then
								rgb.Text = v53.color3ToRgbString(color)
							end
						end

						tbl17.Display = function()
							local h = peek(v57)
							local s = peek(v58)
							local v68 = peek(v59)
							local color = Color3.fromHSV(h, s, v68)
							local value2 = tbl17.Value
							tbl17.Value = color
							local v69 = tbl17
							local v70 = tbl17
							tbl17.H = h
							v69.S = s
							v70.V = v68
							v55:set(color)

							v45(function()
								tbl17.Changed(color)
								tbl17.Callback(color)
							end)

							if color ~= value2 then
								v50.notifyControlChanged(arg3)
							end
						end

						local v68 = v54:Computed(function(arg5)
							return Color3.fromHSV(arg5(v57), arg5(v58), arg5(v59))
						end)

						local v69 = v54:Computed(function(arg5)
							return Color3.fromHSV(arg5(v57), 1, 1)
						end)

						local v70 = v54:Computed(function(arg5)
							return arg5(v55)
						end)

						local v71 = v54:Computed(function(arg5)
							if arg5(v62) then
								return arg5(v56) and 0.15 or 0.5
							end
							return 1
						end)

						local v72 = v54:Computed(function(arg5)
							return arg5(v55)
						end)

						local v73 = v54:Computed(function(arg5)
							return UDim2.fromScale(arg5(v57), 0.5)
						end)

						local v74 = v54:Computed(function(arg5)
							local v74 = 1
							return UDim2.fromScale(arg5(v58), v74 - arg5(v59))
						end)

						v54:Observer(v68):onChange(function()
							if peek(v56) then
								fn25()
							end
						end)

						tbl17.Render = function(arg5, arg6)
							local viewScope = arg6:innerScope()
							tbl15.viewScope = viewScope
							local v75 = viewScope:Value(false)

							tbl16 = {
								Root = viewScope:Value(nil),
								ColorpickerFrame = viewScope:Value(nil),
								Holder = viewScope:Value(nil),
								HSV = viewScope:Value(nil),
								HSVDrag = viewScope:Value(nil),
								Slider = viewScope:Value(nil),
								SliderDrag = viewScope:Value(nil),
								HexRGBContainer = viewScope:Value(nil),
								Hex = viewScope:Value(nil),
								RGB = viewScope:Value(nil),
								Submit = viewScope:Value(nil),
								Visualize = viewScope:Value(nil),
								HoverStroke = viewScope:Value(nil),
							}

							tbl15.interactions = v51.create({
								refs = tbl16,
								isOpenState = v56,
								hState = v57,
								sState = v58,
								vState = v59,
								sliderDraggingState = v60,
								hsvDraggingState = v61,
								isHoveringState = v62,
								pickerPosX = v63,
								pickerPosY = v64,
								submitPressed = v65,
								hexFocused = v66,
								rgbFocused = v67,
								setHSV = fn24,
								display = function()
									tbl17:Display()
								end,
								getSessionScope = function()
									return tbl15.activeSessionScope
								end,
							})

							local function fn26()
								if tbl15.pickerCreated then
									return
								end
								local v76 = peek(v49.Library)
								if not v76 or not v76.GUI then
									return
								end
								tbl15.pickerCreated = true

								tbl17.Picker = v52.buildPopup({
									scope = viewScope,
									refs = tbl16,
									isOpenState = v75,
									pickerPosX = v63,
									pickerPosY = v64,
									hsvColor = v69,
									hsvDragPos = v74,
									sliderDragPos = v73,
									rawSubmitColor = v68,
									submitPressed = v65,
									hexFocused = v66,
									rgbFocused = v67,
									popupParent = v76.GUI,
									onHSVDragInput = tbl15.interactions.handleHSVDragInput,
									onSliderDragInput = tbl15.interactions.handleSliderDragInput,
									onHexFocused = tbl15.interactions.onHexFocused,
									onHexFocusLost = tbl15.interactions.onHexFocusLost,
									onRgbFocused = tbl15.interactions.onRgbFocused,
									onRgbFocusLost = tbl15.interactions.onRgbFocusLost,
									onSubmitInputBegan = tbl15.interactions.onSubmitInputBegan,
									onSubmitInputEnded = tbl15.interactions.onSubmitInputEnded,
								})
							end

							local tbl18 = {
								scope = viewScope,
								refs = tbl16,
								titleState = tbl17.Title,
								descriptionState = tbl17.Description,
								visualizeBgColor = v70,
								hoverStrokeColor = v72,
								hoverStrokeTransparency = v71,
								onMouseEnter = tbl15.interactions.mouseEnter,
								onMouseLeave = tbl15.interactions.mouseLeave,
								onToggleOpen = tbl15.interactions.toggleOpen,
								layoutOrder = tbl14.LayoutOrder,
							}

							local addonRoot

							if flag19 then
								addonRoot = v52.buildAddonRoot(tbl18)
							else
								addonRoot = v52.buildRoot(tbl18)
							end

							tbl17.Root = addonRoot

							local function fn27()
								if peek(v56) then
									if tbl15.activeSessionScope then
										doCleanup(tbl15.activeSessionScope)
									end

									tbl15.activeSessionScope = viewScope:innerScope()
									fn26()
									v75:set(true)
									tbl15.interactions.recalculatePickerPosition()

									tbl15.activeSessionScope:insert(userInputService.InputBegan:Connect(function(input)
										if input.KeyCode == Enum.KeyCode.Escape then
											v56:set(false)
										end
									end))

									local instance2 = peek(tbl16.Visualize)

									if instance2 then
										tbl15.activeSessionScope:insert(
											instance2:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
												tbl15.interactions.recalculatePickerPosition()
											end)
										)
									end

									tbl17:SetHSVFromRGB(tbl17.Value or default)
									fn25()
								else
									v75:set(false)

									if tbl15.activeSessionScope then
										doCleanup(tbl15.activeSessionScope)
										tbl15.activeSessionScope = nil
									end
								end
							end

							viewScope:Observer(v56):onChange(fn27)
							fn27()

							viewScope:insert(function()
								tbl15.activeSessionScope = nil
								tbl15.pickerCreated = false
								tbl15.interactions = nil
								tbl15.viewScope = nil
							end)

							v46.defer(function()
								if tbl15.interactions then
									tbl15.interactions.recalculatePickerPosition()
								end
							end)

							return addonRoot
						end

						tbl17.SetTitle = function(arg5, arg6)
							if tbl17.Title then
								tbl17.Title:set(arg6)
							end
						end

						tbl17.SetDescription = function(arg5, arg6)
							if tbl17.Description then
								tbl17.Description:set(arg6)
							end
						end

						tbl17.SetValueRGB = function(arg5, arg6)
							if not arg6 then
								return
							end
							tbl17:SetHSVFromRGB(arg6)
							tbl17:Display()
						end

						if not flag19 then
							v44(arg2.Container, tbl17)
						end

						fn25()
						tbl17:Display()

						v50.registerControl({
							optionKey = arg3,
							element = tbl17,
							type = tbl17.Type,
							title = tbl14.Title,
							description = tbl14.Description,
							context = arg2.AgentContext,
							defaultValue = default,
							risk = "write",
							getValue = function()
								return tbl17.Value
							end,
							setValue = function(arg5)
								tbl17:SetValueRGB(arg5)
							end,
						})

						return tbl17
					end

					index.createAddon = function(arg, arg2, arg3)
						local tbl14

						if arg3 then
							tbl14 = table.clone(arg3)
						else
							tbl14 = {}
						end

						tbl14.RenderMode = "addon"
						return index:New({ Scope = arg.Scope, AgentContext = arg.AgentContext }, arg2, tbl14)
					end

					return index
				end)()
			)
		end,
		[32] = function()
			fn23(32)

			return (function()
				local v = table.freeze({
					PopupWidth = 241,
					PopupHeight = 255,
					PopupMinWidth = 240,
					PopupOffsetY = 5,
					HSVHeight = 140,
					SliderHeight = 18,
					DragSize = Vector2.new(20, 20),
					Visualizer = Vector2.new(40, 20),
					AddonContainer = Vector2.new(44, 24),
				})

				local v43 = table.freeze({ Popup = 9999, Shadow = -1 })
				local v44 =
					table.freeze({ PopupPadding = 10, PopupInnerPadding = 10, HexRgbPadding = 6, StrokeThickness = 2 })

				local v45 = table.freeze({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(0.0557, Color3.fromRGB(255, 85, 0)),
					ColorSequenceKeypoint.new(0.111, Color3.fromRGB(255, 170, 0)),
					ColorSequenceKeypoint.new(0.167, Color3.fromRGB(254, 255, 0)),
					ColorSequenceKeypoint.new(0.223, Color3.fromRGB(169, 255, 0)),
					ColorSequenceKeypoint.new(0.279, Color3.fromRGB(84, 255, 0)),
					ColorSequenceKeypoint.new(0.334, Color3.fromRGB(0, 255, 1)),
					ColorSequenceKeypoint.new(0.39, Color3.fromRGB(0, 255, 87)),
					ColorSequenceKeypoint.new(0.44600000000000001, Color3.fromRGB(0, 255, 172)),
					ColorSequenceKeypoint.new(0.501, Color3.fromRGB(0, 253, 255)),
					ColorSequenceKeypoint.new(0.557, Color3.fromRGB(0, 168, 255)),
					ColorSequenceKeypoint.new(0.613, Color3.fromRGB(0, 82, 255)),
					ColorSequenceKeypoint.new(0.669, Color3.fromRGB(3, 0, 255)),
					ColorSequenceKeypoint.new(0.72399999999999998, Color3.fromRGB(88, 0, 255)),
					ColorSequenceKeypoint.new(0.78000000000000003, Color3.fromRGB(173, 0, 255)),
					ColorSequenceKeypoint.new(0.836, Color3.fromRGB(255, 0, 251)),
					ColorSequenceKeypoint.new(0.89100000000000001, Color3.fromRGB(255, 0, 166)),
					ColorSequenceKeypoint.new(0.94699999999999995, Color3.fromRGB(255, 0, 81)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
				})

				return table.freeze({ Sizes = v, ZIndex = v43, Layout = v44, SliderGradient = ColorSequence.new(v45) })
			end)()
		end,
		[33] = function()
			local v, instance, v43 = fn23(33)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(instance.Parent.constants)
					local v46 = v43(parent.utils.services)
					local userInputService = v46.UserInputService
					local guiService = v46.GuiService
					local peek = v44.peek

					local function fn24(input)
						return input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
					end

					return {
						create = function(arg)
							local guiInset = guiService:GetGuiInset()

							local function fn25(connection)
								local sessionScope = arg.getSessionScope()

								if sessionScope then
									sessionScope:insert(connection)
								end
							end

							return {
								recalculatePickerPosition = function()
									local guiObject = peek(arg.refs.Visualize)
									if not guiObject then
										return
									end
									local absolutePosition = guiObject.AbsolutePosition
									local absoluteSize = guiObject.AbsoluteSize
									arg.pickerPosX:set(absolutePosition.X)
									arg.pickerPosY:set(
										absolutePosition.Y + absoluteSize.Y + v45.Sizes.PopupOffsetY + guiInset.Y
									)
									local guiObject2 = peek(arg.refs.ColorpickerFrame)
									if not guiObject2 then
										return
									end
									local screenGui = guiObject2:FindFirstAncestorOfClass("ScreenGui")
									local insetArea

									if screenGui then
										insetArea = guiService:GetInsetArea(screenGui.ScreenInsets)
									else
										insetArea = guiService:GetInsetArea(Enum.ScreenInsets.None)
									end

									local vector2 = Vector2.new(v45.Sizes.PopupWidth, v45.Sizes.PopupHeight)
									local n = absolutePosition.Y + absoluteSize.Y + v45.Sizes.PopupOffsetY
									local n27 = absolutePosition.Y - v45.Sizes.PopupOffsetY - vector2.Y
									local n28 = math.max(insetArea.Min.X, insetArea.Max.X - vector2.X)
									local n29 = math.max(insetArea.Min.Y, insetArea.Max.Y - vector2.Y)
									local x = math.clamp(absolutePosition.X, insetArea.Min.X, n28)

									if not (n <= n29) then
										if insetArea.Min.Y <= n27 then
											n = n27
										else
											n = math.clamp(n, insetArea.Min.Y, n29)
										end
									end

									local absolutePosition2 = guiObject2.AbsolutePosition
									arg.pickerPosX:set(peek(arg.pickerPosX) + x - absolutePosition2.X)
									arg.pickerPosY:set(peek(arg.pickerPosY) + n - absolutePosition2.Y)
								end,
								toggleOpen = function(arg2)
									if arg2 and not fn24(arg2) then
										return
									end
									arg.isOpenState:set(not peek(arg.isOpenState))
								end,
								mouseEnter = function()
									arg.isHoveringState:set(true)
								end,
								mouseLeave = function()
									arg.isHoveringState:set(false)
								end,
								handleHSVDragInput = function(arg2)
									if not fn24(arg2) then
										return
									end
									arg.hsvDraggingState:set(true)
									local guiObject = peek(arg.refs.HSV)
									if not guiObject then
										return
									end
									local absolutePosition = guiObject.AbsolutePosition
									local absoluteSize = guiObject.AbsoluteSize

									local function fn26(position)
										local n = math.clamp((position.X - absolutePosition.X) / absoluteSize.X, 0, 1)
										local n27 = math.clamp((position.Y - absolutePosition.Y) / absoluteSize.Y, 0, 1)
										arg.sState:set(n)
										arg.vState:set(1 - n27)
									end

									fn26(arg2.Position)

									local connection = userInputService.InputChanged:Connect(function(input)
										if
											peek(arg.hsvDraggingState)
											and (
												input.UserInputType == Enum.UserInputType.MouseMovement
												or input.UserInputType == Enum.UserInputType.Touch
											)
										then
											fn26(input.Position)
										end
									end)

									local connection2 = userInputService.InputEnded:Connect(function(input)
										if
											peek(arg.hsvDraggingState)
											and (
												input.UserInputType == Enum.UserInputType.MouseButton1
												or input.UserInputType == Enum.UserInputType.Touch
											)
										then
											connection:Disconnect()
											arg.hsvDraggingState:set(false)
										end
									end)

									fn25(connection)
									fn25(connection2)
								end,
								handleSliderDragInput = function(arg2)
									if not fn24(arg2) then
										return
									end
									arg.sliderDraggingState:set(true)
									local guiObject = peek(arg.refs.Slider)
									if not guiObject then
										return
									end
									local absolutePosition = guiObject.AbsolutePosition
									local absoluteSize = guiObject.AbsoluteSize

									local function fn26(position)
										local n = math.clamp((position.X - absolutePosition.X) / absoluteSize.X, 0, 1)
										arg.hState:set(n)
									end

									fn26(arg2.Position)

									local connection = userInputService.InputChanged:Connect(function(input)
										if
											peek(arg.sliderDraggingState)
											and (
												input.UserInputType == Enum.UserInputType.MouseMovement
												or input.UserInputType == Enum.UserInputType.Touch
											)
										then
											fn26(input.Position)
										end
									end)

									local connection2 = userInputService.InputEnded:Connect(function(input)
										if
											peek(arg.sliderDraggingState)
											and (
												input.UserInputType == Enum.UserInputType.MouseButton1
												or input.UserInputType == Enum.UserInputType.Touch
											)
										then
											connection:Disconnect()
											arg.sliderDraggingState:set(false)
										end
									end)

									fn25(connection)
									fn25(connection2)
								end,
								onHexFocused = function()
									arg.hexFocused:set(true)
								end,
								onHexFocusLost = function()
									arg.hexFocused:set(false)
									local v47 = peek(arg.refs.Hex)
									if not v47 then
										return
									end
									local text = v47.Text

									if string.match(text, "^%x%x%x%x%x%x$") then
										local hue, saturation, value = Color3.fromHex(text):ToHSV()
										arg.setHSV(hue, saturation, value)
									end
								end,
								onRgbFocused = function()
									arg.rgbFocused:set(true)
								end,
								onRgbFocusLost = function()
									arg.rgbFocused:set(false)
									local v47 = peek(arg.refs.RGB)
									if not v47 then
										return
									end
									local text = v47.Text

									if string.match(text, "^%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*$") then
										local v48, v49, v50 =
											string.match(text, "^%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*$")
										local r = math.clamp(tonumber(v48) or 0, 0, 255)
										local g = math.clamp(tonumber(v49) or 0, 0, 255)
										local b = math.clamp(tonumber(v50) or 0, 0, 255)
										local hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()
										arg.setHSV(hue, saturation, value)
									end
								end,
								onSubmitInputBegan = function(arg2)
									if fn24(arg2) then
										arg.submitPressed:set(true)
									end
								end,
								onSubmitInputEnded = function(arg2)
									if fn24(arg2) then
										arg.display()
										arg.isOpenState:set(false)
										arg.submitPressed:set(false)
									end
								end,
							}
						end,
					}
				end)()
			)
		end,
		[34] = function()
			fn23(34)

			return (function()
				return table.freeze({
					color3ToHex = function(color)
						return color:ToHex()
					end,
					color3ToRgbString = function(arg)
						local r = math.floor(arg.R * 255)
						local n = math.floor(arg.G * 255)
						local b = math.floor(arg.B * 255)
						return string.format("%d, %d, %d", r, n, b)
					end,
				})
			end)()
		end,
		[35] = function()
			local v, instance, v43 = fn23(35)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.storage.theme)
					local v46 = v43(parent.utils.images)
					local guiObject = v43(instance.Parent.constants)
					local v47 = v43(instance.Parent.Parent.shared)
					local children = v44.Children
					local onEvent = v44.OnEvent

					local function fn24(arg, scope)
						local Frame = scope:New("Frame")

						local childrens = {
							Name = "Checkbox",
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							LayoutOrder = arg.layoutOrder or 0,
							Size = UDim2.fromOffset(guiObject.Sizes.AddonContainer.X, guiObject.Sizes.AddonContainer.Y),
						}

						local visualize = arg.refs.Visualize
						local set = visualize.set

						childrens[children] = {
							scope:New("UICorner")({ CornerRadius = UDim.new(0, 3) }),
							arg.refs.HoverStroke:set(scope:New("UIStroke")({
								Color = arg.hoverStrokeColor,
								Thickness = guiObject.Layout.StrokeThickness,
								Transparency = arg.hoverStrokeTransparency,
							})),
							set(
								visualize,
								scope:New("Frame")({
									Name = "Visualize",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = arg.visualizeBgColor,
									BorderSizePixel = 0,
									LayoutOrder = 1,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromOffset(guiObject.Sizes.Visualizer.X, guiObject.Sizes.Visualizer.Y),
									[children] = { scope:New("UICorner")({ CornerRadius = UDim.new(0, 3) }) },
									[onEvent("MouseEnter")] = arg.onMouseEnter,
									[onEvent("MouseLeave")] = arg.onMouseLeave,
									[onEvent("InputEnded")] = arg.onToggleOpen,
								})
							),
						}

						return Frame(childrens)
					end

					return {
						buildRoot = function(arg)
							local scope = arg.scope

							return arg.refs.Root:set(scope:New("Frame")({
								Name = "Text",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
								[children] = {
									scope:New("Frame")({
										Name = "Addons",
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Position = UDim2.fromScale(1, 0),
										Size = UDim2.fromScale(0, 1),
										[children] = {
											fn24(arg, scope),
											scope:New("UIListLayout")({
												Padding = UDim.new(0, v47.Layout.AddonPadding),
												FillDirection = Enum.FillDirection.Horizontal,
												HorizontalAlignment = Enum.HorizontalAlignment.Right,
												SortOrder = Enum.SortOrder.LayoutOrder,
												VerticalAlignment = Enum.VerticalAlignment.Center,
											}),
										},
									}),
									scope:New("Frame")({
										Name = "TextHolder",
										AutomaticSize = Enum.AutomaticSize.Y,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.new(1, -80, 1, 0),
										[children] = {
											scope:New("TextLabel")({
												Name = "Title",
												FontFace = v47.Fonts.Title,
												Text = scope:Computed(function(arg2)
													return arg2(arg.titleState) or ""
												end),
												TextColor3 = v45.FgSecondary,
												TextSize = 15,
												TextXAlignment = Enum.TextXAlignment.Left,
												AutomaticSize = Enum.AutomaticSize.Y,
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
												Position = UDim2.fromOffset(0, 10),
												Size = UDim2.fromScale(1, 0),
											}),
											scope:New("UIListLayout")({
												Padding = UDim.new(0, v47.Layout.TextPadding),
												VerticalAlignment = Enum.VerticalAlignment.Center,
												SortOrder = Enum.SortOrder.LayoutOrder,
											}),
											scope:Computed(function(arg2, arg3)
												local v48 = arg2(arg.descriptionState)

												if v48 and v48 ~= "" then
													return arg3:New("TextLabel")({
														Name = "Description",
														FontFace = v47.Fonts.Body,
														RichText = true,
														Text = v48,
														TextColor3 = v45.FgTertiary,
														TextSize = 15,
														TextWrapped = true,
														TextXAlignment = Enum.TextXAlignment.Left,
														AutomaticSize = Enum.AutomaticSize.Y,
														BackgroundTransparency = 1,
														BorderSizePixel = 0,
														Position = UDim2.fromOffset(0, 10),
														Size = UDim2.fromScale(1, 0),
														Visible = true,
													})
												end

												return nil
											end),
										},
										[onEvent("MouseEnter")] = arg.onMouseEnter,
										[onEvent("MouseLeave")] = arg.onMouseLeave,
										[onEvent("InputEnded")] = arg.onToggleOpen,
									}),
								},
							}))
						end,
						buildAddonRoot = function(arg)
							return arg.refs.Root:set(fn24(arg, arg.scope))
						end,
						buildPopup = function(arg)
							local scope = arg.scope

							local v48 = scope:Tween(
								scope:Computed(function(arg2)
									return arg2(arg.isOpenState) and 1 or 0
								end),
								TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							)

							local v49 = scope:Computed(function(arg2)
								return 1 - math.clamp(arg2(v48), 0, 1)
							end)

							local v50 = scope:Computed(function(arg2)
								return UDim2.fromOffset(
									guiObject.Sizes.PopupWidth,
									guiObject.Sizes.PopupHeight * math.clamp(arg2(v48), 0, 1)
								)
							end)

							local colorpickerFrame = arg.refs.ColorpickerFrame
							local set = colorpickerFrame.set
							local TextButton = scope:New("TextButton")

							local childrens = {
								Name = "Colorpicker",
								BackgroundColor3 = v45.BgPrimary,
								BackgroundTransparency = v49,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								Size = v50,
								Position = scope:Computed(function(arg2)
									return UDim2.fromOffset(arg2(arg.pickerPosX), arg2(arg.pickerPosY))
								end),
								ZIndex = guiObject.ZIndex.Popup,
								Visible = true,
								Active = arg.isOpenState,
								Interactable = arg.isOpenState,
								Parent = arg.popupParent,
							}

							local tbl14 = {
								Color = v45.BgTertiary,
								Transparency = v49,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							}
							local holder = arg.refs.Holder
							local set2 = holder.set
							local tbl15 = { Color = v45.BgTertiary, Transparency = v49 }
							local sliderDrag = arg.refs.SliderDrag
							local set3 = sliderDrag.set
							local hexRGBContainer = arg.refs.HexRGBContainer
							local set4 = hexRGBContainer.set
							local rgb = arg.refs.RGB
							local submit = arg.refs.Submit
							local set5 = submit.set

							childrens[children] = {
								scope:New("UICorner")({ CornerRadius = UDim.new(0, 4) }),
								scope:New("UIStroke")(tbl14),
								set2(
									holder,
									scope:New("Frame")({
										Name = "Holder",
										AutomaticSize = Enum.AutomaticSize.Y,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.fromScale(1, 1),
										ZIndex = guiObject.ZIndex.Popup,
										[children] = {
											arg.refs.HSV:set(scope:New("ImageLabel")({
												Name = "HSV",
												Image = v46.ColorPicker,
												BackgroundColor3 = arg.hsvColor,
												BackgroundTransparency = v49,
												BorderSizePixel = 0,
												Position = UDim2.fromScale(0.092799999999999994, 0.0357),
												Size = UDim2.new(1, 0, 0, guiObject.Sizes.HSVHeight),
												ZIndex = guiObject.ZIndex.Popup,
												ImageTransparency = v49,
												[children] = {
													arg.refs.HSVDrag:set(scope:New("ImageButton")({
														Name = "Drag",
														Image = v46.Drag,
														AnchorPoint = Vector2.new(0.5, 0.5),
														BackgroundTransparency = 1,
														BorderSizePixel = 0,
														Position = arg.hsvDragPos,
														Size = UDim2.fromOffset(
															guiObject.Sizes.DragSize.X,
															guiObject.Sizes.DragSize.Y
														),
														ZIndex = guiObject.ZIndex.Popup,
														ImageTransparency = v49,
														[onEvent("InputBegan")] = arg.onHSVDragInput,
													})),
													scope:New("UICorner")({ CornerRadius = UDim.new(0, 4) }),
													scope:New("UIStroke")(tbl15),
												},
											})),
											scope:New("UIListLayout")({
												Padding = UDim.new(0, guiObject.Layout.PopupInnerPadding),
												HorizontalAlignment = Enum.HorizontalAlignment.Center,
												SortOrder = Enum.SortOrder.LayoutOrder,
											}),
											scope:New("UIPadding")({
												PaddingLeft = UDim.new(0, guiObject.Layout.PopupPadding),
												PaddingRight = UDim.new(0, guiObject.Layout.PopupPadding),
												PaddingTop = UDim.new(0, guiObject.Layout.PopupPadding),
											}),
											arg.refs.Slider:set(scope:New("Frame")({
												Name = "Slider",
												BackgroundTransparency = v49,
												BorderSizePixel = 0,
												Position = UDim2.fromScale(0.0253, 0.74399999999999999),
												Size = UDim2.new(1, 0, 0, guiObject.Sizes.SliderHeight),
												ZIndex = guiObject.ZIndex.Popup,
												[children] = {
													scope:New("UIGradient")({ Color = guiObject.SliderGradient }),
													scope:New("UICorner")({ CornerRadius = UDim.new(0, 4) }),
													set3(
														sliderDrag,
														scope:New("ImageButton")({
															Name = "Drag",
															Image = v46.Drag,
															AnchorPoint = Vector2.new(0.5, 0.5),
															BackgroundTransparency = 1,
															BorderSizePixel = 0,
															Position = arg.sliderDragPos,
															Size = UDim2.fromOffset(
																guiObject.Sizes.DragSize.X,
																guiObject.Sizes.DragSize.Y
															),
															ZIndex = guiObject.ZIndex.Popup,
															ImageTransparency = v49,
															[onEvent("InputBegan")] = arg.onSliderDragInput,
														})
													),
												},
											})),
											set4(
												hexRGBContainer,
												scope:New("Frame")({
													Name = "HEXRGB",
													AutomaticSize = Enum.AutomaticSize.Y,
													BackgroundTransparency = 1,
													BorderSizePixel = 0,
													Size = UDim2.fromScale(1, 0),
													ZIndex = guiObject.ZIndex.Popup,
													Position = UDim2.fromOffset(0, 0),
													[children] = {
														scope:New("UIListLayout")({
															Padding = UDim.new(0, guiObject.Layout.HexRgbPadding),
															FillDirection = Enum.FillDirection.Horizontal,
															SortOrder = Enum.SortOrder.LayoutOrder,
														}),
														arg.refs.Hex:set(scope:New("TextBox")({
															Name = "HEX",
															CursorPosition = -1,
															FontFace = v47.Fonts.Title,
															PlaceholderColor3 = v45.FgTertiary,
															PlaceholderText = "HEX",
															Text = "",
															TextColor3 = v45.FgSecondary,
															TextTransparency = v49,
															TextSize = 14,
															BackgroundTransparency = 1,
															BorderSizePixel = 0,
															Size = UDim2.new(0.5, -3, 0, 25),
															ZIndex = guiObject.ZIndex.Popup,
															[children] = {
																scope:New("UIStroke")({
																	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
																	Color = scope:Computed(function(arg2)
																		return arg2(arg.hexFocused)
																				and arg2(v45.AccentPrimary)
																			or arg2(v45.BgTertiary)
																	end),
																	Transparency = v49,
																}),
																scope:New("UICorner")({ CornerRadius = UDim.new(0, 2) }),
															},
															[onEvent("Focused")] = arg.onHexFocused,
															[onEvent("FocusLost")] = arg.onHexFocusLost,
														})),
														rgb:set(scope:New("TextBox")({
															Name = "RGB",
															FontFace = v47.Fonts.Title,
															PlaceholderColor3 = v45.FgTertiary,
															PlaceholderText = "RGB",
															Text = "",
															TextColor3 = v45.FgSecondary,
															TextTransparency = v49,
															TextSize = 14,
															BackgroundTransparency = 1,
															BorderSizePixel = 0,
															Size = UDim2.new(0.5, -3, 0, 25),
															ZIndex = guiObject.ZIndex.Popup,
															[children] = {
																scope:New("UIStroke")({
																	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
																	Color = scope:Computed(function(arg2)
																		return arg2(arg.rgbFocused)
																				and arg2(v45.AccentPrimary)
																			or arg2(v45.BgTertiary)
																	end),
																	Transparency = v49,
																}),
																scope:New("UICorner")({ CornerRadius = UDim.new(0, 2) }),
															},
															[onEvent("Focused")] = arg.onRgbFocused,
															[onEvent("FocusLost")] = arg.onRgbFocusLost,
														})),
													},
												})
											),
											set5(
												submit,
												scope:New("TextButton")({
													Name = "TextButton",
													FontFace = v47.Fonts.Title,
													Text = "Submit",
													TextColor3 = v45.FgPrimary,
													TextTransparency = v49,
													TextSize = 14,
													BackgroundColor3 = arg.rawSubmitColor,
													BackgroundTransparency = v49,
													Size = UDim2.new(1, 0, 0, 25),
													ZIndex = guiObject.ZIndex.Popup,
													Position = UDim2.fromOffset(0, 0),
													[children] = {
														scope:New("UICorner")({ CornerRadius = UDim.new(0, 2) }),
														scope:New("UIStroke")({
															ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
															Color = scope:Computed(function(arg2)
																return arg2(arg.submitPressed)
																		and arg2(v45.AccentPrimary)
																	or arg2(v45.BgTertiary)
															end),
															Transparency = v49,
														}),
													},
													[onEvent("InputBegan")] = arg.onSubmitInputBegan,
													[onEvent("InputEnded")] = arg.onSubmitInputEnded,
												})
											),
										},
									})
								),
								scope:New("UISizeConstraint")({
									MinSize = Vector2.new(guiObject.Sizes.PopupMinWidth, 0),
								}),
								scope:New("ImageLabel")({
									Name = "EShadow",
									Image = v46.Dropshadow,
									ImageColor3 = v45.BgPrimary,
									ImageTransparency = scope:Computed(function(arg2)
										return 0.5 + 0.5 * arg2(v49)
									end),
									ScaleType = Enum.ScaleType.Slice,
									SliceCenter = Rect.new(45, 45, 45, 45),
									SliceScale = 1.2,
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									ClipsDescendants = true,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.new(1, 75, 1, 75),
									ZIndex = guiObject.ZIndex.Shadow,
								}),
							}

							return set(colorpickerFrame, TextButton(childrens))
						end,
					}
				end)()
			)
		end,
		[37] = function()
			local v, instance, v43 = fn23(37)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.utils.animate)
					local v45 = v43(parent.packages.fusion)
					local scope = v43(parent.Internal).Scope
					local v46 = v43(parent.storage.theme)
					local v47 = v43(parent.utils.images)
					local children = v45.Children
					local onEvent = v45.OnEvent
					local peek = v45.peek
					local vector2 = Vector2.new(0.5, 0.5)
					local udim = UDim.new(0, 2)

					local function fn24(input)
						return input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
					end

					local function fn25(...)
						local v48 = table.pack(...)
						local tbl14 = {}

						for i = 1, select("#", ...) do
							local value = select(i, table.unpack(v48, 1, v48.n))

							if value then
								for k, v49 in pairs(value) do
									tbl14[k] = v49
								end
							end
						end

						return tbl14
					end

					local function fn26(arg, udim2)
						return arg:New("UICorner")({ CornerRadius = udim2 or udim })
					end

					return {
						new = function(arg)
							local tbl14 = arg or {}
							local v48 = (tbl14.Scope or scope):innerScope()
							local flag19 = tbl14.State ~= nil
							local state = tbl14.State or v48:Value(tbl14.Checked == true)
							local v49 = v48:Value(false)

							local v50 = v44(function(arg2)
								if arg2(v49) or arg2(state) then
									return arg2(state) and 0.15 or 1
								end
								return 1
							end, 40, 1, v48)

							local v51 = v44(function(arg2)
								return arg2(state) and arg2(v46.AccentPrimary) or arg2(v46.FgTertiary)
							end, 40, 1, v48)

							local v52 = v44(function(arg2)
								return arg2(state) and arg2(v46.AccentPrimary) or arg2(v46.BgPrimary)
							end, 40, 1, v48)

							local v53 = v48:Computed(function(arg2)
								return not arg2(state)
							end)

							local v54 = v44(function(arg2)
								return arg2(state) and 0 or 1
							end, 15, 1, v48)

							local function fn27(arg2)
								if not fn24(arg2) then
									return
								end
								local flag20 = not peek(state)

								if not flag19 then
									state:set(flag20)
								end

								if tbl14.OnToggle then
									tbl14.OnToggle(flag20)
								end
							end

							local Frame = v48:New("Frame")

							local childrens = {
								Name = "Checkbox",
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								AnchorPoint = tbl14.AnchorPoint or Vector2.new(1, 0.5),
								Position = tbl14.Position or UDim2.fromScale(1, 0.5),
								Size = tbl14.Size or UDim2.fromOffset(24, 24),
								LayoutOrder = tbl14.LayoutOrder or 1,
							}

							local v55 = v47
							local track = v55.Track
							local v56 = "CheckIcon"

							childrens[children] = {
								fn26(v48, udim),
								v48:New("UIStroke")({ Color = v51, Thickness = 2, Transparency = v50 }),
								v48:New("ImageButton")({
									Name = "Main",
									AnchorPoint = vector2,
									BackgroundColor3 = v52,
									BorderSizePixel = 0,
									LayoutOrder = 1,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromOffset(20, 20),
									[children] = {
										fn26(v48, udim),
										v48:New("UIStroke")({ Color = v46.BgTertiary, Enabled = v53 }),
										track(
											v55,
											v56,
											v48:New("ImageLabel")({
												BackgroundTransparency = 1,
												Image = v47.CheckIcon,
												ImageColor3 = Color3.new(0, 0, 0),
												ImageTransparency = v54,
												AnchorPoint = vector2,
												Position = UDim2.fromScale(0.5, 0.5),
												Size = UDim2.fromOffset(14, 14),
											})
										),
									},
									[onEvent("MouseEnter")] = function()
										v49:set(true)
									end,
									[onEvent("MouseLeave")] = function()
										v49:set(false)
									end,
									[onEvent("InputEnded")] = fn27,
								}),
							}

							return Frame(fn25(childrens, tbl14.Extend))
						end,
					}
				end)()
			)
		end,
		[38] = function()
			local v, instance, v43 = fn23(38)

			return (function()
				local parent = instance.Parent.Parent.Parent
				local v44 = v43(parent.packages.fusion)
				local children = v44.Children
				local new = v44.New
				local fusionUtils = parent.utils.fusionUtils
				local component = v43(fusionUtils.component).Component
				local v45 = v43(fusionUtils.combineProps)
				local v46 = v43(fusionUtils.composeTransparency)
				local extract = v43(parent.utils.tableUtils).Extract
				local v47 = v43(parent.storage.theme)

				return component(function(arg, arg2)
					local color, bgPrimary = extract(arg2, "Color")
					local strokeColor, bgTertiary = extract(color, "StrokeColor")
					local cornerRadius, v48 = extract(strokeColor, "CornerRadius", 4)
					local cornerRadiusOffset, v49 = extract(cornerRadius, "CornerRadiusOffset", 0)
					local v50, v51 = extract(cornerRadiusOffset, "AutomaticSize", Enum.AutomaticSize.None)
					local contentZIndex, v52 = extract(v50, "ContentZIndex", 2)
					local v53, v54 = extract(contentZIndex, "Transparency", 0)
					local backgroundTransparency, v55 = extract(v53, "BackgroundTransparency", 0)
					local strokeTransparency, v56 = extract(backgroundTransparency, "StrokeTransparency", 0)
					local v57, v58 = extract(strokeTransparency, children)
					local rootChildren, v59 = extract(v57, "RootChildren")

					if bgPrimary == nil then
						bgPrimary = v47.BgPrimary
					end

					if bgTertiary == nil then
						bgTertiary = v47.BgTertiary
					end

					if typeof(v48) == "number" then
						v48 += v49
					end

					local v60 = v46(arg, v55, v54)
					local v61 = v46(arg, v56, v54)
					local flag19 = v51 == Enum.AutomaticSize.Y or v51 == Enum.AutomaticSize.XY
					local v62 = nil

					if flag19 then
						v62 = new(arg, "Frame")({
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = v51,
							BackgroundTransparency = 1,
							ZIndex = v52,
							Name = "ContainerContent",
							[children] = v58,
						})

						v58 = nil
					end

					local frame = new(arg, "Frame")

					local childrens = {
						Name = "Container",
						BackgroundColor3 = bgPrimary,
						BackgroundTransparency = v60,
						Size = UDim2.fromScale(1, 1),
						AutomaticSize = v51,
					}

					local children2 = children
					local tbl14 = {}
					local uiCorner = new(arg, "UICorner")
					local tbl15 = {}
					local udim

					if typeof(v48) == "number" then
						udim = UDim.new(0, v48)
					else
						udim = v48
					end

					tbl15.CornerRadius = udim
					local v63 = uiCorner(tbl15)
					local v64 = new(arg, "UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = bgTertiary,
						Thickness = 1,
						Transparency = v61,
					})
					tbl14[1] = v63
					tbl14[2] = v64
					tbl14[3] = v59
					tbl14[4] = v62
					tbl14[5] = v58
					childrens[children2] = tbl14
					return frame(v45(childrens, rootChildren))
				end)
			end)()
		end,
		[39] = function()
			local v, instance, v43 = fn23(39)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent
					local utils = parent.utils
					local v44 = v43(utils.insertitem)
					local v45 = v43(utils.safecallback)
					local packages = parent.packages
					local v46 = v43(packages.fusion)
					local v47 = v43(packages.states)
					local v48 = v43(parent.Internal)
					local v49 = v43(parent.utils.controlRegistry)
					local v50 = v43(instance.controller)
					local v51 = v43(instance.view)
					local scope = v48.Scope
					local peek = v46.peek

					local index = {}
					index.__index = index
					index.__type = "Dropdown"

					local function fn24(arg, arg2)
						local tbl14 = {
							Values = arg.Values,
							Value = arg.Value,
							Multi = arg.Multi,
							Buttons = arg.Buttons,
							Opened = arg.Opened,
							Callback = arg.Callback,
							Type = "Dropdown",
							Changed = arg.Changed,
							AllowNull = arg.AllowNull,
							SearchEnabled = arg.SearchEnabled,
							SearchQuery = arg.SearchQuery,
							Scope = arg.scope,
							_controller = arg,
						}

						local callback = arg.Callback

						arg.Callback = function(value)
							tbl14.Value = value
							callback(value)
						end

						tbl14.Callback = arg.Callback

						tbl14.SetValues = function(arg3, arg4)
							arg:SetValues(arg4)
							tbl14.Values = arg.Values
						end

						tbl14.OnChanged = function(arg3, arg4)
							arg:OnChanged(arg4)
						end

						tbl14.SetValue = function(arg3, arg4)
							arg:SetValue(arg4)
						end

						tbl14.GetActiveValues = function()
							return arg:GetActiveValues()
						end

						tbl14.Display = function()
							arg:Display()
						end

						tbl14.BuildDropdownList = function()
							arg:BuildDropdownList()
						end

						tbl14.Toggle = function(arg3, arg4)
							arg:toggleOpen(arg4)
						end

						tbl14.Destroy = function()
							arg:Destroy()

							if arg2 then
								arg2()
							end
						end

						return tbl14
					end

					index.New = function(arg, arg2, arg3, arg4)
						local tbl14 = arg4 or {}

						local v52 = v50.create({
							scope = arg2.Scope,
							values = tbl14.Values,
							default = tbl14.Default,
							multi = tbl14.Multi,
							allowNull = tbl14.AllowNull,
							callback = tbl14.Callback,
							description = tbl14.Description,
							cornerRadius = tbl14.CornerRadius,
							optionStyle = tbl14.OptionStyle,
							search = tbl14.Search,
							searchPlaceholder = tbl14.SearchPlaceholder,
							thinkingLevels = tbl14.ThinkingLevels,
							thinkingValues = tbl14.ThinkingValues,
							onThinkingSelect = tbl14.OnThinkingSelect,
						})

						local v53 = fn24(v52, function()
							v49.unregisterControl(arg3)
						end)

						local callback = v52.Callback

						v52.Callback = function(arg5)
							callback(arg5)
							v49.notifyControlChanged(arg3)
						end

						v53.Callback = v52.Callback

						v53.Render = function(arg5, arg6)
							local v54 = peek(v47.Library)
							local gui = nil

							if v54 then
								gui = v54.GUI or nil
							end

							local root = v52:render({
								renderScope = arg6,
								popupParent = gui,
								buildTrigger = function(arg7)
									return v51.buildRoot({
										scope = arg7.scope,
										refs = arg7.refs,
										isOpenState = arg7.isOpenState,
										isHoveringState = arg7.isHoveringState,
										titleText = tbl14.Title or "",
										descriptionState = arg7.descriptionState,
										displayTextState = arg7.displayTextState,
										onToggleOpen = arg7.onToggleOpen,
										onHoverChanged = arg7.onHoverChanged,
									})
								end,
							})

							v53.Holder = v52.Holder
							v53.Root = root
							return root
						end

						v44(arg2.Container, v53)

						v49.registerControl({
							optionKey = arg3,
							element = v53,
							type = v53.Type,
							title = tbl14.Title,
							description = tbl14.Description,
							context = arg2.AgentContext,
							multi = v53.Multi,
							defaultValue = tbl14.Default,
							risk = "write",
							getValue = function()
								return v52.Value
							end,
							setValue = function(arg5)
								v53:SetValue(arg5)
							end,
							getChoices = function()
								return v52.Values
							end,
						})

						v45(function()
							v53.Callback(v52.Value)
						end)

						return v53
					end

					index.Create = function(arg)
						local tbl14 = arg or {}
						tbl14.scope = tbl14.scope or scope

						local v52 = v50.create({
							scope = tbl14.scope,
							values = tbl14.Values,
							default = tbl14.Default,
							multi = tbl14.Multi,
							allowNull = tbl14.AllowNull,
							callback = tbl14.Callback,
							description = tbl14.Description,
							cornerRadius = tbl14.CornerRadius,
							optionStyle = tbl14.OptionStyle,
							search = tbl14.Search,
							searchPlaceholder = tbl14.SearchPlaceholder,
							thinkingLevels = tbl14.ThinkingLevels,
							thinkingValues = tbl14.ThinkingValues,
							onThinkingSelect = tbl14.OnThinkingSelect,
						})

						local v53 = fn24(v52, nil)
						local popupParent = tbl14.PopupParent

						if not popupParent then
							popupParent = peek(v47.Library)
							popupParent = popupParent and popupParent.GUI or nil
						end

						v52:render({
							renderScope = tbl14.scope,
							popupParent = popupParent,
							anchor = tbl14.Anchor,
							fixedWidth = tbl14.FixedWidth,
							fixedHeight = tbl14.FixedHeight,
							buildTrigger = tbl14.TriggerBuilder,
							onOpenChange = tbl14.OnOpenChange,
						})

						v53.Holder = v52.Holder
						v53.Root = v52.Root

						v45(function()
							v53.Callback(v52.Value)
						end)

						return v53
					end

					return index
				end)()
			)
		end,
		[40] = function()
			fn23(40)

			return (function()
				return table.freeze({
					Sizes = table.freeze({
						InteractWidth = 200,
						InteractHeight = 30,
						HolderWidth = 200,
						HolderMaxHeight = 310,
						HolderMinWidth = 200,
						OptionHeight = 25,
						ExpansionHeight = 14,
						HeaderHeight = 20,
						Icon = Vector2.new(14, 14),
						HolderOffset = 5,
					}),
					Layout = table.freeze({ HolderPadding = 5, OptionPadding = 5, CornerRadius = 6 }),
					ZIndex = table.freeze({ Holder = 1000, Interact = 1001 }),
					Animation = table.freeze({
						OpenSizeSpeed = 35,
						OpenSizeDamping = 1,
						IconSpeed = 25,
						IconDamping = 1,
						TitleSpeed = 40,
						TitleDamping = 1,
						OptionSpeed = 45,
						OptionDamping = 1,
					}),
				})
			end)()
		end,
		[41] = function()
			local v, instance, v43 = fn23(41)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.Internal)
					local v46 = v43(parent.utils.safecallback)
					local v47 = v43(parent.utils.pendingTasks)
					local v48 = v43(instance.Parent.interactions)
					local v49 = v43(instance.Parent.view)
					local v50 = v43(instance.Parent.model)
					local scope = v45.Scope
					local peek = v44.peek
					local doCleanup = v44.doCleanup

					local function fn24(arg)
						if arg == nil then
							return table.freeze({})
						end
						return table.freeze(table.clone(arg))
					end

					local function fn25(arg, arg2)
						for k, v51 in next, arg do
							if arg2[k] ~= v51 then
								return false
							end
						end

						for k, v51 in next, arg2 do
							if arg[k] ~= v51 then
								return false
							end
						end

						return true
					end

					local index = {}
					index.__index = index

					index.create = function(arg)
						local tbl14 = arg or {}
						local v51 = (tbl14.scope or scope):innerScope()

						local tbl15 = {
							scope = v51,
							Values = fn24(tbl14.values),
							Value = nil,
							Multi = tbl14.multi,
							AllowNull = tbl14.allowNull or false,
						}

						tbl15.Opened = v51:Value(false)

						tbl15.Callback = tbl14.callback or function() end

						tbl15.Changed = function() end

						tbl15.Buttons = {}
						tbl15.Holder = nil
						tbl15.Root = nil
						tbl15.CornerRadius = tbl14.cornerRadius
						tbl15.OptionStyle = tbl14.optionStyle or {}
						tbl15.SearchEnabled = tbl14.search == true
						tbl15.SearchPlaceholder = tbl14.searchPlaceholder or "Search..."
						tbl15.SearchQuery = v51:Value("")
						tbl15.ThinkingLevels = tbl14.thinkingLevels
						tbl15.ThinkingValues = tbl14.thinkingValues

						tbl15.OnThinkingSelect = tbl14.onThinkingSelect or function() end

						tbl15.viewState = {
							refs = nil,
							interactions = nil,
							viewScope = nil,
							listScope = nil,
							listRows = nil,
							renderRow = nil,
							activeSessionScope = nil,
						}

						tbl15.displayTextState = v51:Value("--")
						tbl15.hoveringState = v51:Value(false)
						tbl15.descriptionState = v51:Value(tbl14.description)
						setmetatable(tbl15, index)

						local function fn26()
							v46(function()
								tbl15.Callback(tbl15.Value)
								tbl15.Changed(tbl15.Value)
							end)
						end

						local function displayText()
							local values = tbl15.Values
							local str7

							if tbl15.Multi then
								local labels = {}

								for _, value in ipairs(values) do
									local label = v50.getLabel(value)

									if tbl15.Value and tbl15.Value[label] then
										table.insert(labels, label)
									end
								end

								str7 = table.concat(labels, ", ")
							else
								str7 = tbl15.Value or ""
							end

							if str7 == "" then
								str7 = "--"
							end

							tbl15.displayTextState:set(str7)
						end

						local function setValue(value, arg2)
							local flag19

							if tbl15.Multi then
								local value2 = {}

								if value then
									for k in next, value do
										if v50.indexOfLabel(tbl15.Values, k) then
											value2[k] = true
										end
									end
								end

								flag19 = not fn25(value2, tbl15.Value or {})
								tbl15.Value = value2
							elseif value == nil then
								flag19 = tbl15.Value ~= nil
								tbl15.Value = nil
							else
								if not v50.indexOfLabel(tbl15.Values, value) then
									return false
								end
								flag19 = tbl15.Value ~= value
								tbl15.Value = value
							end

							displayText()

							if arg2 and flag19 then
								fn26()
							end

							return flag19
						end

						local function fn27(arg2, arg3, input)
							if
								input.UserInputType ~= Enum.UserInputType.MouseButton1
								and input.UserInputType ~= Enum.UserInputType.Touch
							then
								return
							end
							local flag19 = not peek(arg2.Selected)
							if tbl15:GetActiveValues() == 1 and not flag19 and not tbl15.AllowNull then
								return
							end

							if tbl15.Multi then
								tbl15.Value = tbl15.Value or {}

								if flag19 then
									tbl15.Value[arg3] = true
								else
									tbl15.Value[arg3] = nil
								end
							else
								tbl15.Value = flag19 and arg3 or nil

								for _, button in ipairs(tbl15.Buttons) do
									button:UpdateSelected()
								end
							end

							arg2:UpdateSelected()
							displayText()
							fn26()
						end

						tbl15.rebuildList = function()
							v50.rebuildList({
								viewState = tbl15.viewState,
								dropdown = tbl15,
								onSelectValue = fn27,
								thinkingLevels = tbl15.ThinkingLevels,
								thinkingValues = tbl15.ThinkingValues,
								onThinkingSelect = tbl15.OnThinkingSelect,
							})
						end

						tbl15.setValue = setValue
						tbl15.displayText = displayText
						tbl15.Value = v50.parseDefault(tbl14.default, tbl15.Values, tbl15.Multi)
						displayText()
						return tbl15
					end

					index.SetValues = function(arg, arg2)
						arg.Values = fn24(arg2)
						arg:rebuildList()
						arg:displayText()
					end

					index.OnChanged = function(arg, changed)
						arg.Changed = changed
						changed(arg.Value)
					end

					index.SetValue = function(arg, arg2)
						arg.setValue(arg2, true)
						arg:rebuildList()
					end

					index.GetActiveValues = function(arg)
						if arg.Multi then
							local tbl14 = {}
							local v51 = next
							local tbl15 = arg.Value or {}

							for k in v51, tbl15 do
								table.insert(tbl14, k)
							end

							return tbl14
						end

						return arg.Value and 1 or 0
					end

					index.Display = function(arg)
						arg:displayText()
					end

					index.BuildDropdownList = function(arg)
						arg:rebuildList()
					end

					index.toggleOpen = function(arg, arg2)
						if arg.viewState.interactions then
							arg.viewState.interactions.toggleOpen(arg2)
						end
					end

					index.Destroy = function(arg)
						if arg.viewState.activeSessionScope then
							doCleanup(arg.viewState.activeSessionScope)
							arg.viewState.activeSessionScope = nil
						end

						if arg.viewState.viewScope then
							doCleanup(arg.viewState.viewScope)
							arg.viewState.viewScope = nil
						end

						arg.viewState.refs = nil
						arg.viewState.listScope = nil
						arg.viewState.listRows = nil
						arg.viewState.renderRow = nil
						arg.viewState.interactions = nil
						doCleanup(arg.scope)
					end

					index.render = function(arg, arg2)
						local tbl14 = arg2 or {}
						local viewState = arg.viewState

						if viewState.viewScope then
							doCleanup(viewState.viewScope)
							viewState.viewScope = nil
							viewState.refs = nil
							viewState.listScope = nil
							viewState.listRows = nil
							viewState.renderRow = nil
							viewState.interactions = nil
							viewState.activeSessionScope = nil
						end

						local viewScope = tbl14.renderScope:innerScope()
						viewState.viewScope = viewScope

						viewState.refs = {
							DropdownInner = viewScope:Value(nil),
							DropdownHolder = viewScope:Value(nil),
							DropdownList = viewScope:Value(nil),
							DropdownDisplay = viewScope:Value(nil),
							DropdownSearch = viewScope:Value(nil),
						}

						viewState.listScope = viewScope:innerScope()
						viewState.listRows = viewScope:Value({})
						viewState.interactions = v48.create({
							refs = viewState.refs,
							isOpenState = arg.Opened,
							isHoveringState = arg.hoveringState,
							viewState = viewState,
						})

						if tbl14.anchor then
							viewState.refs.DropdownInner:set(tbl14.anchor)
						end

						arg.Holder = v49.buildHolder({
							scope = viewScope,
							refs = viewState.refs,
							viewState = viewState,
							rowCountState = viewState.listRows,
							isOpenState = arg.Opened,
							popupParent = tbl14.popupParent,
							fixedWidth = tbl14.fixedWidth,
							fixedHeight = tbl14.fixedHeight,
							cornerRadius = arg.CornerRadius,
							optionStyle = arg.OptionStyle,
							searchEnabled = arg.SearchEnabled,
							searchPlaceholder = arg.SearchPlaceholder,
							searchQueryState = arg.SearchQuery,
						})

						local trigger = nil

						if tbl14.buildTrigger then
							trigger = tbl14.buildTrigger({
								scope = viewScope,
								refs = viewState.refs,
								isOpenState = arg.Opened,
								isHoveringState = arg.hoveringState,
								descriptionState = arg.descriptionState,
								displayTextState = arg.displayTextState,
								onToggleOpen = viewState.interactions.toggleOpen,
								onHoverChanged = viewState.interactions.setHovering,
							})
						end

						arg.Root = trigger or arg.Holder

						if arg.SearchEnabled then
							viewScope:Observer(arg.SearchQuery):onChange(function()
								arg:rebuildList()

								if viewState.interactions then
									viewState.interactions.updateGeometry()
								end
							end)
						end

						viewScope:Observer(arg.Opened):onChange(function()
							viewState.interactions.updateGeometry()

							if viewState.activeSessionScope then
								doCleanup(viewState.activeSessionScope)
								viewState.activeSessionScope = nil
							end

							if peek(arg.Opened) then
								viewState.activeSessionScope = viewScope:innerScope()
								viewState.interactions.connectOpenSession(viewState.activeSessionScope)

								if arg.SearchEnabled then
									v47.defer(function()
										if not peek(arg.Opened) or not viewState.refs then
											return
										end
										local v51 = peek(viewState.refs.DropdownSearch)

										if v51 then
											v51:CaptureFocus()
										end
									end)
								end
							elseif arg.SearchEnabled and peek(arg.SearchQuery) ~= "" then
								arg.SearchQuery:set("")
							end

							if not peek(arg.Opened) then
								viewState.openSessionX = nil
							end

							if tbl14.onOpenChange then
								v46(function()
									tbl14.onOpenChange(peek(arg.Opened))
								end)
							end
						end)

						if peek(arg.Opened) then
							viewState.activeSessionScope = viewScope:innerScope()
							viewState.interactions.connectOpenSession(viewState.activeSessionScope)
						end

						viewScope:insert(function()
							viewState.refs = nil
							viewState.interactions = nil
							viewState.viewScope = nil
							viewState.listScope = nil
							viewState.listRows = nil
							viewState.renderRow = nil
						end)

						arg:rebuildList()
						arg:displayText()

						if viewState.interactions then
							viewState.interactions.updateGeometry()
						end

						return arg.Root
					end

					return index
				end)()
			)
		end,
		[42] = function()
			local v, instance, v43 = fn23(42)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(instance.Parent.constants)
					local v46 = v43(parent.utils.services)
					local guiService = v46.GuiService
					local userInputService = v46.UserInputService
					local v47 = v43(parent.utils.pendingTasks)
					local peek = v44.peek

					local function fn24(input)
						return input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
					end

					local function fn25(input)
						local vector2

						if input.UserInputType == Enum.UserInputType.Touch then
							vector2 = Vector2.new(input.Position.X, input.Position.Y)
						else
							vector2 = userInputService:GetMouseLocation()
						end

						return vector2 - guiService:GetGuiInset()
					end

					local function fn26(guiObject, arg)
						if not guiObject or not guiObject.Visible then
							return false
						end
						local absolutePosition = guiObject.AbsolutePosition
						local absoluteSize = guiObject.AbsoluteSize
						return arg.X >= absolutePosition.X
							and arg.X <= absolutePosition.X + absoluteSize.X
							and arg.Y >= absolutePosition.Y
							and arg.Y <= absolutePosition.Y + absoluteSize.Y
					end

					local function getInsetArea(instance2)
						local screenGui = instance2:FindFirstAncestorOfClass("ScreenGui")
						if screenGui then
							return guiService:GetInsetArea(screenGui.ScreenInsets)
						end
						return guiService:GetInsetArea(Enum.ScreenInsets.None)
					end

					return {
						create = function(arg)
							local function fn27()
								local guiObject = peek(arg.refs.DropdownInner)
								local guiObject2 = peek(arg.refs.DropdownHolder)
								if not (guiObject and guiObject2) then
									return
								end
								local insetArea = getInsetArea(guiObject2)
								local offset = insetArea.Max - insetArea.Min
								local maxPopupSizeState = arg.viewState and arg.viewState.maxPopupSizeState

								if maxPopupSizeState then
									maxPopupSizeState:set(Vector2.new(math.max(0, offset.X), math.max(0, offset.Y)))
								end

								local absoluteSize = guiObject2.AbsoluteSize
								local holderTargetSizeState = arg.viewState and arg.viewState.holderTargetSizeState

								if holderTargetSizeState then
									local v48 = peek(holderTargetSizeState)
									absoluteSize = Vector2.new(
										v48.X.Scale * offset.X + v48.X.Offset,
										v48.Y.Scale * offset.Y + v48.Y.Offset
									)
								end

								local absolutePosition = guiObject.AbsolutePosition
								local n = absolutePosition.Y + guiObject.AbsoluteSize.Y + v45.Sizes.HolderOffset
								local n27 = absolutePosition.Y - v45.Sizes.HolderOffset - absoluteSize.Y
								local n28 = insetArea.Max.X - absoluteSize.X
								local n29 = insetArea.Max.Y - absoluteSize.Y
								local openSessionX = arg.viewState.openSessionX

								if openSessionX == nil then
									openSessionX =
										math.clamp(absolutePosition.X, insetArea.Min.X, math.max(insetArea.Min.X, n28))
									arg.viewState.openSessionX = openSessionX
								end

								local flag19

								if n <= n29 then
									flag19 = false
								elseif insetArea.Min.Y <= n27 then
									flag19 = true
									n = n27
								else
									flag19 = false
									n = math.clamp(n, insetArea.Min.Y, math.max(insetArea.Min.Y, n29))
								end

								local vector2

								if flag19 then
									vector2 = Vector2.new(0, 1)
								else
									vector2 = Vector2.new(0, 0)
								end

								if guiObject2.AnchorPoint ~= vector2 then
									guiObject2.AnchorPoint = vector2
								end

								local absolutePosition2 = guiObject2.AbsolutePosition

								if flag19 then
									n = absolutePosition.Y - v45.Sizes.HolderOffset - guiObject2.AbsoluteSize.Y
								end

								local x = openSessionX - absolutePosition2.X
								local y = n - absolutePosition2.Y

								if math.abs(x) > 0.01 or math.abs(y) > 0.01 then
									guiObject2.Position += UDim2.fromOffset(x, y)
								end
							end

							local function onInputBegan(input)
								if not peek(arg.isOpenState) then
									return
								end

								if not fn24(input) then
									return
								end
								local v48 = fn25(input)
								local v49 = peek(arg.refs.DropdownInner)
								local v50 = peek(arg.refs.DropdownHolder)
								local v51 = fn26(v49, v48)
								local v52 = fn26(v50, v48)

								if not v51 and not v52 then
									arg.isOpenState:set(false)
								end
							end

							return {
								updateGeometry = fn27,
								toggleOpen = function(arg2)
									if arg2 and not fn24(arg2) then
										return
									end
									local flag19 = not peek(arg.isOpenState)

									if flag19 then
										arg.viewState.openSessionX = nil
										fn27()
									else
										arg.viewState.openSessionX = nil
									end

									arg.isOpenState:set(flag19)
								end,
								setHovering = function(arg2)
									arg.isHoveringState:set(arg2)
								end,
								connectOpenSession = function(arg2)
									if arg.viewState.openSessionX == nil then
										fn27()
									end

									local instance2 = peek(arg.refs.DropdownInner)

									if instance2 then
										arg2:insert(
											instance2:GetPropertyChangedSignal("AbsolutePosition"):Connect(fn27)
										)
										arg2:insert(instance2:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn27))
									end

									local instance3 = peek(arg.refs.DropdownHolder)

									if instance3 then
										arg2:insert(instance3:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn27))
										local screenGui = instance3:FindFirstAncestorOfClass("ScreenGui")

										if screenGui then
											arg2:insert(
												screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn27)
											)
											arg2:insert(
												screenGui:GetPropertyChangedSignal("ScreenInsets"):Connect(fn27)
											)
										end
									end

									arg2:insert(guiService:GetPropertyChangedSignal("TopbarInset"):Connect(fn27))
									v47.defer(fn27)

									v47.defer(function()
										if peek(arg.isOpenState) then
											arg2:insert(userInputService.InputBegan:Connect(onInputBegan))
										end
									end)
								end,
								handleGlobalInput = onInputBegan,
							}
						end,
					}
				end)()
			)
		end,
		[43] = function()
			local v, instance, v43 = fn23(43)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.Parent.packages.fusion)
					local v45 = v43(instance.Parent.view)
					local v46 = v43(instance.Parent.constants)
					local peek = v44.peek
					local tbl14

					tbl14 = {
						getLabel = function(arg)
							if type(arg) == "table" then
								return arg.Label or ""
							end
							return arg
						end,
						getIcon = function(arg)
							if type(arg) ~= "table" then
								return nil
							end

							do
								return arg.Icon
							end

							while true do
							end
						end,
						getDescription = function(arg)
							if type(arg) == "table" then
								return arg.Description
							end
							return nil
						end,
						getSubtext = function(arg)
							if type(arg) == "table" then
								return arg.Subtext
							end
							return nil
						end,
						getCategory = function(arg)
							if type(arg) == "table" then
								return arg.Category
							end
							return nil
						end,
						indexOfLabel = function(arg, arg2)
							for i, v47 in ipairs(arg) do
								if tbl14.getLabel(v47) == arg2 then
									return i
								end
							end

							return nil
						end,
					}

					local function fn24(arg, match)
						if match == nil or match == "" then
							return true
						end

						local function fn25(arg2)
							return arg2 ~= nil and string.find(string.lower(tostring(arg2)), match, 1, true) ~= nil
						end

						return fn25(tbl14.getLabel(arg))
							or fn25(tbl14.getDescription(arg))
							or fn25(tbl14.getCategory(arg))
							or fn25(tbl14.getSubtext(arg))
					end

					tbl14.parseDefault = function(arg, arg2, arg3)
						if not arg then
							arg3 = arg3 and {} or nil
							return arg3
						end
						local tbl15 = {}

						if type(arg) == "string" then
							local v47 = tbl14.indexOfLabel(arg2, arg)

							if v47 then
								table.insert(tbl15, v47)
							end
						elseif type(arg) == "table" then
							for _, v47 in next, arg do
								local v48 = tbl14.indexOfLabel(arg2, v47)

								if v48 then
									table.insert(tbl15, v48)
								end
							end
						elseif type(arg) == "number" and arg2[arg] ~= nil then
							table.insert(tbl15, arg)
						end

						if not next(tbl15) then
							arg3 = arg3 and {} or nil
							return arg3
						end
						local label = arg3 and {} or nil

						for i = 1, #tbl15 do
							local v47 = tbl15[i]
							if not arg3 then
								label = tbl14.getLabel(arg2[v47])
								break
							end
							label[tbl14.getLabel(arg2[v47])] = true
						end

						return label
					end

					tbl14.rebuildList = function(arg)
						local viewState = arg.viewState
						local dropdown = arg.dropdown
						local onSelectValue = arg.onSelectValue
						local optionStyle = dropdown.OptionStyle or {}
						if not viewState.listScope or not viewState.listRows then
							return
						end
						viewState.listScope:doCleanup()
						viewState.listScope = viewState.viewScope:innerScope()
						dropdown.Buttons = {}

						local function fn25()
							local tbl15 = {}
							local searchQuery = dropdown.SearchEnabled and dropdown.SearchQuery
							local match = ""

							if searchQuery then
								match = string.lower(peek(dropdown.SearchQuery) or ""):match("^%s*(.-)%s*$") or ""
							end

							if optionStyle.ListTopPadding and optionStyle.ListTopPadding > 0 then
								table.insert(tbl15, { Type = "Spacer", Height = optionStyle.ListTopPadding })
							end

							local tbl16 = {}

							for i, value in ipairs(dropdown.Values) do
								if fn24(value, match) then
									table.insert(tbl16, { Index = i, Value = value })
								end
							end

							local category2 = nil

							for i, v47 in ipairs(tbl16) do
								local index = v47.Index
								local value = v47.Value
								local label = tbl14.getLabel(value)
								local category = tbl14.getCategory(value)
								local description = tbl14.getDescription(value)
								local rowHeight = optionStyle.RowHeight
									or description and v46.Sizes.OptionHeight + 25
									or v46.Sizes.OptionHeight

								if category and category ~= category2 then
									if category2 ~= nil and optionStyle.CategorySeparators then
										table.insert(tbl15, {
											Type = "CategorySeparator",
											Height = optionStyle.CategorySeparatorHeight or 7,
										})
									end

									table.insert(
										tbl15,
										{ Type = "Header", Text = category, Height = v46.Sizes.HeaderHeight }
									)
									category2 = category
								end

								local button = dropdown.Buttons[index]
								table.insert(tbl15, {
									Type = "Option",
									Entry = button,
									Value = label,
									ValueEntry = value,
									Height = rowHeight,
								})

								if button.Expanded and peek(button.Expanded) then
									table.insert(tbl15, {
										Type = "Expansion",
										Entry = button,
										Value = label,
										Height = v46.Sizes.ExpansionHeight,
									})
								end

								if optionStyle.Separators and i < #tbl16 then
									table.insert(tbl15, { Type = "Separator", Height = 1 })
								end
							end

							if optionStyle.ListBottomPadding and optionStyle.ListBottomPadding > 0 then
								table.insert(tbl15, { Type = "Spacer", Height = optionStyle.ListBottomPadding })
							end

							viewState.listRows:set(tbl15)
						end

						viewState.renderRow = function(arg2, arg3, arg4)
							local v47 = arg2(viewState.listRows)[arg4]
							if not v47 then
								return nil
							end

							if v47.Type == "Spacer" then
								return arg3:New("Frame")({
									Name = "Spacer",
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Size = UDim2.fromScale(1, 1),
								})
							end

							if v47.Type == "Header" then
								return v45.createCategoryHeader({
									scope = arg3,
									text = v47.Text,
									contentFade = viewState.contentFadeState,
								})
							end

							if v47.Type == "CategorySeparator" then
								return v45.createOptionSeparator({
									scope = arg3,
									contentFade = viewState.contentFadeState,
									inset = 0,
								})
							end

							if v47.Type == "Separator" then
								local separatorInset = optionStyle.SeparatorInset

								if separatorInset == nil then
									separatorInset = optionStyle.PaddingX or v46.Layout.OptionPadding
								end

								return v45.createOptionSeparator({
									scope = arg3,
									contentFade = viewState.contentFadeState,
									inset = separatorInset,
								})
							end

							local entry = v47.Entry

							if v47.Type == "Expansion" then
								return v45.createExpansionRow({
									scope = arg3,
									valueText = v47.Value,
									levels = arg.thinkingLevels and arg.thinkingLevels[v47.Value] or {},
									thinkingValues = arg.thinkingValues,
									onThinkingSelect = arg.onThinkingSelect,
									contentFade = viewState.contentFadeState,
									optionStyle = optionStyle,
								})
							end

							return v45.createOptionButton({
								scope = arg3,
								valueText = v47.Value,
								icon = tbl14.getIcon(v47.ValueEntry),
								description = tbl14.getDescription(v47.ValueEntry),
								subtext = tbl14.getSubtext(v47.ValueEntry),
								optionStyle = optionStyle,
								selectedState = entry.Selected,
								isHoveredState = entry.Hovered,
								isOpenState = dropdown.Opened,
								contentFade = viewState.contentFadeState,
								onHover = function(arg5)
									entry.Hovered:set(arg5)
								end,
								onSelect = function(input)
									local flag19 = input
										and (
											input.UserInputType == Enum.UserInputType.MouseButton1
											or input.UserInputType == Enum.UserInputType.Touch
										)
									local v48 = peek(entry.Selected)
									onSelectValue(entry, v47.Value, input)

									if flag19 then
										local flag20 = false

										for _, button in ipairs(dropdown.Buttons) do
											if
												button.Expanded
												and peek(button.Expanded)
												and (button ~= entry or not v48)
											then
												button.Expanded:set(false)
												flag20 = true
											end
										end

										if entry.Expanded and v48 then
											entry.Expanded:set(not peek(entry.Expanded))
											flag20 = true
										end

										if flag20 then
											fn25()
										end
									end
								end,
							})
						end

						for i, value in ipairs(dropdown.Values) do
							local label = tbl14.getLabel(value)
							local v47 = viewState.listScope:Value(false)
							local v48 = viewState.listScope:Value(false)
							local thinkingLevel = arg.thinkingLevels and arg.thinkingLevels[label]

							local tbl15 = {
								Value = label,
								Selected = v47,
								Hovered = v48,
								Expanded = thinkingLevel and #thinkingLevel > 0 and viewState.listScope:Value(false)
									or nil,
								UpdateSelected = function()
									if dropdown.Multi then
										v47:set(dropdown.Value and dropdown.Value[label] or false)
									else
										v47:set(dropdown.Value == label)
									end
								end,
							}

							tbl15:UpdateSelected()
							dropdown.Buttons[i] = tbl15
						end

						fn25()

						if viewState.interactions then
							viewState.interactions.updateGeometry()
						end
					end

					return tbl14
				end)()
			)
		end,
		[44] = function()
			local v, instance, v43 = fn23(44)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.utils.animate)
					local v45 = v43(parent.packages.fusion)
					local v46 = v43(parent.storage.theme)
					local v47 = v43(parent.utils.images)
					local track = v43(instance.Parent.constants)
					local v48 = v43(instance.Parent.Parent.shared)
					local v49 = v43(instance.Parent.Parent.container)
					local children = v45.Children
					local onEvent = v45.OnEvent
					local out = v45.Out
					local holderPadding = track.Layout.HolderPadding
					local holderPadding2 = holderPadding + 26 + 1
					local v50 = 3

					local function fn24(arg, rowSpacing)
						local n = 0

						for _, v51 in ipairs(arg) do
							n += v51.Height or track.Sizes.OptionHeight
						end

						if #arg > 1 then
							n += (#arg - 1) * rowSpacing
						end

						return n
					end

					return {
						buildHolder = function(arg)
							local scope = arg.scope
							local fixedWidth = arg.fixedWidth or track.Sizes.HolderWidth
							local optionStyle = arg.optionStyle or {}
							local rowSpacing = optionStyle.RowSpacing or 0
							local paddingX = optionStyle.PaddingX or track.Layout.OptionPadding
							local listPaddingX = optionStyle.ListPaddingX

							if listPaddingX == nil then
								listPaddingX = track.Layout.HolderPadding
							end

							local holderPadding3

							if arg.searchEnabled then
								holderPadding3 = holderPadding2 + v50
							else
								holderPadding3 = track.Layout.HolderPadding
							end

							local n = holderPadding3 + track.Layout.HolderPadding

							local holderTargetSizeState = scope:Computed(function(arg2)
								if arg.fixedHeight then
									return UDim2.fromOffset(fixedWidth, arg.fixedHeight)
								end
								return UDim2.fromOffset(
									fixedWidth,
									math.min(fn24(arg2(arg.rowCountState), rowSpacing) + n, track.Sizes.HolderMaxHeight)
								)
							end)

							local v51 = v44(function(arg2)
								if not arg2(arg.isOpenState) then
									return UDim2.fromOffset(fixedWidth, 0)
								end
								return arg2(holderTargetSizeState)
							end, track.Animation.OpenSizeSpeed, track.Animation.OpenSizeDamping, scope)

							local contentFadeState = scope:Computed(function(arg2)
								local offset = arg2(holderTargetSizeState).Y.Offset
								if offset <= 0 then
									return 1
								end
								return 1 - math.clamp(arg2(v51).Y.Offset / offset, 0, 1)
							end)

							arg.viewState.contentFadeState = contentFadeState
							arg.viewState.holderTargetSizeState = holderTargetSizeState

							local v52 = scope:Computed(function(arg2)
								return UDim2.fromOffset(0, fn24(arg2(arg.rowCountState), rowSpacing))
							end)

							local computed = scope.Computed

							local v53 = scope:New("ScrollingFrame")({
								Name = "List",
								Position = UDim2.fromOffset(listPaddingX, holderPadding3),
								Size = UDim2.new(1, -listPaddingX * 2, 1, -n),
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								CanvasSize = v52,
								AutomaticCanvasSize = Enum.AutomaticSize.None,
								ScrollingDirection = Enum.ScrollingDirection.Y,
								ScrollBarImageTransparency = 1,
								ScrollBarThickness = 0,
								Active = true,
								ClipsDescendants = true,
								ZIndex = 2,
								[children] = {
									scope:New("UIListLayout")({
										Padding = UDim.new(0, rowSpacing),
										SortOrder = Enum.SortOrder.LayoutOrder,
									}),
									computed(scope, function(arg2, arg3)
										local v53 = arg2(arg.rowCountState)
										local tbl14 = {}
										local renderRow = arg.viewState.renderRow
										if not renderRow then
											return tbl14
										end

										for i = 1, #v53 do
											local v54 = renderRow(arg2, arg3, i)

											if v54 then
												local insert = table.insert
												local Frame = arg3:New("Frame")

												local childrens = {
													Name = "Row",
													LayoutOrder = i,
													BackgroundTransparency = 1,
													BorderSizePixel = 0,
													Size = UDim2.new(
														1,
														0,
														0,
														v53[i].Height or track.Sizes.OptionHeight
													),
													ZIndex = track.ZIndex.Holder,
												}

												childrens[children] = { v54 }
												insert(tbl14, Frame(childrens))
											end
										end

										return tbl14
									end),
								},
							})

							arg.refs.DropdownList:set(v53)
							local tbl14 = { v53 }

							if arg.searchEnabled then
								local TextBox = scope:New("TextBox")

								local childrens = {
									Name = "Search",
									FontFace = v48.Fonts.Body,
									Text = arg.searchQueryState,
									PlaceholderText = arg.searchPlaceholder or "Search...",
									PlaceholderColor3 = v46.FgQuaternary,
									TextColor3 = v46.FgPrimary,
									TextTransparency = contentFadeState,
									TextSize = 12,
									TextXAlignment = Enum.TextXAlignment.Left,
									ClearTextOnFocus = false,
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Position = UDim2.fromOffset(track.Layout.HolderPadding, holderPadding),
									Size = UDim2.new(1, -track.Layout.HolderPadding * 2, 0, 26),
									ZIndex = track.ZIndex.Holder + 1,
								}

								childrens[children] = {
									scope:New("UIPadding")({
										PaddingLeft = UDim.new(0, paddingX),
										PaddingRight = UDim.new(0, paddingX),
									}),
								}
								childrens[out("Text")] = arg.searchQueryState
								local v54 = TextBox(childrens)
								arg.refs.DropdownSearch:set(v54)

								table.insert(
									tbl14,
									scope:New("Frame")({
										Name = "SearchHeader",
										Position = UDim2.fromOffset(0, 0),
										Size = UDim2.new(1, 0, 0, holderPadding2),
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										ZIndex = track.ZIndex.Holder + 1,
										[children] = {
											v54,
											scope:New("Frame")({
												Name = "Separator",
												AnchorPoint = Vector2.new(0, 1),
												Position = UDim2.fromScale(0, 1),
												Size = UDim2.new(1, 0, 0, 1),
												BackgroundColor3 = v46.BgTertiary,
												BackgroundTransparency = contentFadeState,
												BorderSizePixel = 0,
												ZIndex = track.ZIndex.Holder + 1,
											}),
										},
									})
								)
							end

							local childrens = {
								Name = "Frame",
								Color = v46.BgPrimary,
								StrokeColor = v46.BgTertiary,
								StrokeTransparency = contentFadeState,
								CornerRadius = arg.cornerRadius or track.Layout.CornerRadius,
								ClipsDescendants = true,
								Size = v51,
								Visible = true,
								Parent = arg.popupParent,
								ZIndex = track.ZIndex.Holder,
								Active = arg.isOpenState,
							}

							childrens[children] = tbl14
							local v54 = v49(scope, childrens)
							arg.refs.DropdownHolder:set(v54)
							return v54
						end,
						buildRoot = function(arg)
							local scope = arg.scope

							local v51 = v44(function(arg2)
								if arg2(arg.isOpenState) then
									return arg2(v46.AccentPrimary)
								end

								if arg2(arg.isHoveringState) then
									return arg2(v46.FgPrimary)
								end
								return arg2(v46.FgTertiary)
							end, track.Animation.IconSpeed, track.Animation.IconDamping, scope)

							local dropdownDisplay = arg.refs.DropdownDisplay
							local set = dropdownDisplay.set

							local v52 = scope:New("TextButton")({
								Name = "Interact",
								FontFace = v48.Fonts.Body,
								Text = "",
								TextSize = 12,
								TextXAlignment = Enum.TextXAlignment.Left,
								Active = true,
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundColor3 = v46.BgPrimary,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								LayoutOrder = 1,
								Position = UDim2.fromScale(1, 0.5),
								Selectable = false,
								Size = UDim2.fromOffset(track.Sizes.InteractWidth, track.Sizes.InteractHeight),
								ZIndex = track.ZIndex.Interact,
								[children] = {
									scope:New("UICorner")({ CornerRadius = UDim.new(0, track.Layout.CornerRadius) }),
									v47:Track(
										"DropdownArrowIcon",
										scope:New("ImageLabel")({
											Name = "Icon",
											AnchorPoint = Vector2.new(1, 0.5),
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											Interactable = false,
											LayoutOrder = 1,
											Position = UDim2.new(1, -5, 0.5, 0),
											Size = UDim2.fromOffset(track.Sizes.Icon.X, track.Sizes.Icon.Y),
											Image = v47.DropdownArrowIcon,
											ImageColor3 = v51,
										})
									),
									scope:New("UIStroke")({
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = v46.BgTertiary,
									}),
									set(
										dropdownDisplay,
										scope:New("TextLabel")({
											Name = "Values",
											FontFace = v48.Fonts.Body,
											Text = arg.displayTextState,
											TextColor3 = v44(function(arg2)
												return arg2(arg.isOpenState) and arg2(v46.FgPrimary)
													or arg2(v46.FgSecondary)
											end, track.Animation.TitleSpeed, track.Animation.TitleDamping, scope),
											TextSize = 14,
											TextTruncate = Enum.TextTruncate.AtEnd,
											TextXAlignment = Enum.TextXAlignment.Left,
											AnchorPoint = Vector2.new(0, 0.5),
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											ClipsDescendants = true,
											Position = UDim2.new(0, 10, 0.5, 0),
											Size = UDim2.new(1, -30, 1, 0),
										})
									),
								},
								[onEvent("MouseEnter")] = function()
									arg.onHoverChanged(true)
								end,
								[onEvent("MouseLeave")] = function()
									arg.onHoverChanged(false)
								end,
								[onEvent("MouseButton1Click")] = arg.onToggleOpen,
							})

							arg.refs.DropdownInner:set(v52)

							return scope:New("Frame")({
								Name = "Dropdown",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
								[children] = {
									v48.AddonsContainer.create({
										scope = scope,
										padding = v48.Layout.AddonPadding,
										children = { v52 },
									}),
									scope:New("Frame")({
										Name = "TextHolder",
										AutomaticSize = Enum.AutomaticSize.Y,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.new(1, -190, 1, 0),
										[children] = {
											scope:New("TextLabel")({
												Name = "Title",
												FontFace = v48.Fonts.Title,
												Text = arg.titleText,
												TextColor3 = v44(function(arg2)
													return arg2(arg.isOpenState) and arg2(v46.FgPrimary)
														or arg2(arg.isHoveringState) and arg2(v46.FgPrimary)
														or arg2(v46.FgSecondary)
												end, track.Animation.TitleSpeed, track.Animation.TitleDamping, scope),
												TextSize = 15,
												TextXAlignment = Enum.TextXAlignment.Left,
												AutomaticSize = Enum.AutomaticSize.Y,
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
												Position = UDim2.fromOffset(0, 10),
												Size = UDim2.fromScale(1, 0),
											}),
											scope:New("UIListLayout")({
												Padding = UDim.new(0, v48.Layout.TextPadding),
												VerticalAlignment = Enum.VerticalAlignment.Center,
												SortOrder = Enum.SortOrder.LayoutOrder,
											}),
											scope:Computed(function(arg2, arg3)
												local v53 = arg2(arg.descriptionState)

												if v53 and v53 ~= "" then
													return arg3:New("TextLabel")({
														Name = "Description",
														FontFace = v48.Fonts.Body,
														RichText = true,
														Text = v53,
														TextColor3 = v46.FgTertiary,
														TextSize = 15,
														TextWrapped = true,
														TextXAlignment = Enum.TextXAlignment.Left,
														AutomaticSize = Enum.AutomaticSize.Y,
														BackgroundTransparency = 1,
														BorderSizePixel = 0,
														Position = UDim2.fromOffset(0, 10),
														Size = UDim2.fromScale(1, 0),
														Visible = true,
													})
												end

												return nil
											end),
										},
									}),
								},
							})
						end,
						createCategoryHeader = function(arg)
							local scope = arg.scope
							local TextLabel = scope:New("TextLabel")

							local childrens = {
								Name = "CategoryHeader",
								FontFace = v48.Fonts.Body,
								Text = string.upper(arg.text),
								TextColor3 = v46.FgTertiary,
								TextSize = 11,
								TextTransparency = arg.contentFade or 0,
								TextXAlignment = Enum.TextXAlignment.Left,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.new(1, 0, 1, 0),
								ZIndex = track.ZIndex.Holder,
							}

							childrens[children] =
								{ scope:New("UIPadding")({ PaddingLeft = UDim.new(0, track.Layout.OptionPadding) }) }
							return TextLabel(childrens)
						end,
						createOptionSeparator = function(arg)
							local inset = arg.inset

							if inset == nil then
								inset = track.Layout.OptionPadding
							end

							return arg.scope:New("Frame")({
								Name = "Separator",
								AnchorPoint = Vector2.new(0, 0.5),
								Position = UDim2.new(0, inset, 0.5, 0),
								Size = UDim2.new(1, -inset * 2, 0, 1),
								BackgroundColor3 = v46.BgTertiary,
								BackgroundTransparency = arg.contentFade or 0,
								BorderSizePixel = 0,
								ZIndex = track.ZIndex.Holder,
							})
						end,
						createOptionButton = function(arg)
							local scope = arg.scope
							local optionStyle = arg.optionStyle or {}
							local paddingX = optionStyle.PaddingX or track.Layout.OptionPadding
							local paddingY = optionStyle.PaddingY or 3
							local labelFont = optionStyle.LabelFont or v48.Fonts.Title
							local labelSize = optionStyle.LabelSize or 13
							local descriptionGap = optionStyle.DescriptionGap or 4
							local flag19 = arg.icon ~= nil
							local flag20 = arg.description ~= nil and arg.description ~= ""
							local flag21 = arg.subtext ~= nil
							local n = flag21 and 36 or 0
							local x = flag19 and 18 or 0

							local v51 = v44(function(arg2)
								if arg2(arg.selectedState) then
									return arg2(v46.AccentPrimary)
								end

								if arg2(arg.isHoveredState) then
									return arg2(v46.FgPrimary)
								end
								return arg2(v46.FgSecondary)
							end, track.Animation.OptionSpeed, track.Animation.OptionDamping, scope)

							local tbl14 = {}

							local v52 = scope:New("UIListLayout")({
								Padding = UDim.new(0, flag20 and descriptionGap or 0),
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							})

							local TextLabel = scope:New("TextLabel")

							local tbl15 = {
								Name = "Label",
								FontFace = labelFont,
								Text = arg.valueText,
								TextColor3 = v51,
								TextTransparency = arg.contentFade or 0,
								TextSize = labelSize,
								TextTruncate = Enum.TextTruncate.AtEnd,
								TextXAlignment = Enum.TextXAlignment.Left,
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.new(1, 0, 0, 0),
								ZIndex = track.ZIndex.Holder,
							}

							local v53 = table.pack(TextLabel(tbl15))
							tbl14[1] = v52

							do
								local values = table.pack(table.unpack(v53, 1, v53.n))
								table.move(values, 1, values.n, 2, tbl14)
							end

							if flag20 then
								table.insert(
									tbl14,
									scope:New("TextLabel")({
										Name = "Description",
										FontFace = v48.Fonts.Body,
										Text = arg.description,
										TextColor3 = v46.FgTertiary,
										TextTransparency = arg.contentFade or 0,
										TextSize = 11,
										TextWrapped = true,
										TextTruncate = Enum.TextTruncate.None,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextYAlignment = Enum.TextYAlignment.Center,
										AutomaticSize = Enum.AutomaticSize.Y,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.new(1, 0, 0, 0),
										ZIndex = track.ZIndex.Holder,
									})
								)
							end

							local tbl16 = {
								scope:New("Frame")({
									Name = "Text",
									Position = UDim2.fromOffset(x, 0),
									Size = UDim2.new(1, -x, 1, 0),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									[children] = tbl14,
								}),
							}

							if flag19 then
								local v54 = scope:New("ImageLabel")({
									Name = "Icon",
									AnchorPoint = Vector2.new(0, 0.5),
									Position = UDim2.fromScale(0, 0.5),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									ImageColor3 = v51,
									ImageTransparency = arg.contentFade or 0,
									Size = UDim2.fromOffset(12, 12),
									ZIndex = track.ZIndex.Holder,
								})

								if v47:GetIcon(arg.icon) then
									v47:Track(arg.icon, v54)
								else
									v54.Image = arg.icon
								end

								table.insert(tbl16, v54)
							end

							local tbl17 = {
								scope:New("UICorner")({
									Name = "UICorner",
									CornerRadius = UDim.new(0, track.Layout.CornerRadius),
								}),
								scope:New("Frame")({
									Name = "Content",
									Position = UDim2.fromOffset(paddingX, paddingY),
									Size = UDim2.new(1, -(paddingX * 2 + n), 1, -(paddingY * 2)),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									ZIndex = track.ZIndex.Holder,
									[children] = tbl16,
								}),
							}

							if flag21 then
								table.insert(
									tbl17,
									scope:New("TextLabel")({
										Name = "Subtext",
										FontFace = v48.Fonts.Body,
										Text = arg.subtext,
										TextColor3 = v46.FgTertiary,
										TextSize = 11,
										TextTransparency = arg.contentFade or 0,
										TextTruncate = Enum.TextTruncate.AtEnd,
										TextXAlignment = Enum.TextXAlignment.Right,
										AnchorPoint = Vector2.new(1, 0.5),
										AutomaticSize = Enum.AutomaticSize.X,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Position = UDim2.new(1, -paddingX, 0.5, 0),
										Size = UDim2.new(0, 0, 0, labelSize + 4),
										ZIndex = track.ZIndex.Holder,
									})
								)
							end

							return scope:New("TextButton")({
								Name = "OptionButton",
								AutoButtonColor = false,
								Text = "",
								BackgroundTransparency = 1,
								BackgroundColor3 = v46.AccentPrimary,
								BorderSizePixel = 0,
								Selectable = false,
								Size = UDim2.new(1, 0, 1, 0),
								ZIndex = track.ZIndex.Holder,
								Active = true,
								[children] = tbl17,
								[onEvent("MouseEnter")] = function()
									arg.onHover(true)
								end,
								[onEvent("MouseLeave")] = function()
									arg.onHover(false)
								end,
								[onEvent("InputBegan")] = arg.onSelect,
							})
						end,
						createExpansionRow = function(arg)
							local scope = arg.scope
							local paddingX = (arg.optionStyle or {}).PaddingX or track.Layout.OptionPadding
							local accentFg = v46:GetAccentFg(scope, "Primary")
							local thinkingValue = arg.thinkingValues and arg.thinkingValues[arg.valueText]
								or scope:Value("")
							local tbl14 = {}

							for _, level in ipairs(arg.levels) do
								local v51 = scope:Value(false)
								local TextButton = scope:New("TextButton")

								local tbl15 = {
									Name = "Level_" .. level,
									Text = level,
									FontFace = v48.Fonts.Mono,
									TextSize = 11,
									TextTransparency = arg.contentFade or 0,
									TextColor3 = v44(function(arg2)
										if arg2(thinkingValue) == level then
											return arg2(accentFg)
										end

										if arg2(v51) then
											return arg2(v46.FgPrimary)
										end
										return arg2(v46.FgTertiary)
									end, track.Animation.IconSpeed, track.Animation.IconDamping, scope),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Selectable = false,
									AutomaticSize = Enum.AutomaticSize.X,
									Size = UDim2.fromOffset(0, 14),
									ZIndex = track.ZIndex.Holder,
								}

								tbl15[onEvent("MouseEnter")] = function()
									v51:set(true)
								end

								tbl15[onEvent("MouseLeave")] = function()
									v51:set(false)
								end

								tbl15[onEvent("InputBegan")] = function(input)
									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										arg.onThinkingSelect(level, arg.valueText)
									end
								end

								local v52 = TextButton(tbl15)
								table.insert(tbl14, v52)
							end

							local unpack_ = table.unpack

							return scope:New("Frame")({
								Name = "Expansion",
								Position = UDim2.new(0, paddingX, 0, 0),
								Size = UDim2.new(1, -paddingX * 2, 1, 0),
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								ZIndex = track.ZIndex.Holder,
								[children] = {
									scope:New("UIListLayout")({
										FillDirection = Enum.FillDirection.Horizontal,
										Padding = UDim.new(0, 10),
										SortOrder = Enum.SortOrder.LayoutOrder,
										VerticalAlignment = Enum.VerticalAlignment.Top,
									}),
									unpack_(tbl14),
								},
							})
						end,
					}
				end)()
			)
		end,
		[45] = function()
			local v, instance, v43 = fn23(45)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent
					local utils = parent.utils
					local v44 = v43(utils.insertitem)
					local v45 = v43(utils.safecallback)
					local packages = parent.packages
					local v46 = v43(packages.fusion)
					local v47 = v43(parent.Internal)
					local v48 = v43(packages.audio)
					local v49 = v43(parent.utils.controlRegistry)
					local v50 = v43(instance.interactions)
					local v51 = v43(instance.view)
					local scope = v47.Scope
					local peek = v46.peek
					local doCleanup = v46.doCleanup

					local index = {}
					index.__index = index
					index.__type = "Input"

					index.New = function(arg, arg2, arg3, arg4)
						local tbl14 = arg4 or {}
						local v52 = (arg2.Scope or scope):innerScope()
						local v53 = v52:Value(tbl14.Default or "")
						local v54 = v52:Value(false)
						local tbl15 = { Box = v52:Value(nil) }

						local tbl16 = {
							Value = tbl14.Default or "",
							Numeric = tbl14.Numeric or false,
							Finished = tbl14.Finished or false,
							Callback = tbl14.Callback or function() end,
							Placeholder = tbl14.Placeholder or "...",
							Type = "Input",
							Changed = function() end,
						}

						local v55 = v52:Value(tbl14.Description)

						local function fn24(arg5)
							local value = tostring(arg5 or "")

							if tbl16.Numeric and #value > 0 and not tonumber(value) then
								value = tbl16.Value
							end

							tbl16.Value = value
							v53:set(value)

							v45(function()
								tbl16.Callback(tbl16.Value)
								tbl16.Changed(tbl16.Value)
							end)

							v49.notifyControlChanged(arg3)
						end

						tbl16.SetValue = function(arg5, arg6)
							fn24(arg6)
						end

						tbl16.OnChanged = function(arg5, changed)
							tbl16.Changed = changed
							changed(tbl16.Value)
							return arg5
						end

						local tbl17 = { interactions = nil }

						tbl16.Render = function(arg5, arg6)
							local v56 = arg6:innerScope()

							tbl17.interactions = v50.create({
								isFocusedState = v54,
								isFinished = tbl16.Finished,
								getBox = function()
									return peek(tbl15.Box)
								end,
								getValue = function()
									return tbl16.Value
								end,
								setValue = fn24,
								registerConnection = function(arg7)
									v56:insert(arg7)
								end,
								audio = v48,
							})

							local root = v51.buildRoot({
								scope = v56,
								refs = tbl15,
								textState = v53,
								titleText = tbl14.Title or "",
								descriptionState = v55,
								placeholderText = tbl16.Placeholder,
								onFocused = tbl17.interactions.onFocused,
								onFocusLost = tbl17.interactions.onFocusLost,
							})

							tbl17.interactions.connectLiveInput()
							tbl16.Root = root
							return root
						end

						tbl16.Destroy = function()
							doCleanup(v52)
							v49.unregisterControl(arg3)
						end

						v44(arg2.Container, tbl16)

						v49.registerControl({
							optionKey = arg3,
							element = tbl16,
							type = tbl16.Type,
							title = tbl14.Title,
							description = tbl14.Description,
							context = arg2.AgentContext,
							defaultValue = tbl14.Default or "",
							risk = "write",
							getValue = function()
								return tbl16.Value
							end,
							setValue = function(arg5)
								tbl16:SetValue(arg5)
							end,
						})

						return tbl16
					end

					return index
				end)()
			)
		end,
		[46] = function()
			local v, instance, v43 = fn23(46)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.Parent.utils.pendingTasks)

					return {
						create = function(arg)
							return {
								onFocused = function()
									arg.isFocusedState:set(true)
								end,
								onFocusLost = function(arg2)
									arg.isFocusedState:set(false)

									if arg.isFinished and arg2 then
										local box = arg.getBox()

										if box then
											arg.setValue(box.Text or "")
										end
									end
								end,
								connectLiveInput = function()
									if arg.isFinished then
										return
									end
									local box = arg.getBox()
									if not box then
										return
									end

									local connection = box:GetPropertyChangedSignal("Text"):Connect(function()
										local text = box.Text or ""
										local value = arg.getValue()

										if #value < #text then
											arg.audio:Play("Key")
										elseif #text < #value and box:IsFocused() then
											v44.delay(0, function()
												arg.audio:Play("Backspace")
											end)
										end

										arg.setValue(text)
									end)

									arg.registerConnection(connection)
								end,
							}
						end,
					}
				end)()
			)
		end,
		[47] = function()
			local v, instance, v43 = fn23(47)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.storage.theme)
					local v46 = v43(instance.Parent.Parent.shared)
					local children = v44.Children
					local onChange = v44.OnChange
					local onEvent = v44.OnEvent

					return {
						buildRoot = function(arg)
							local scope = arg.scope
							local v47 = scope:Value(v46.Layout.MaxWidth)

							return scope:New("Frame")({
								Name = "Textbox",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
								[children] = {
									scope:New("Frame")({
										Name = "Addons",
										AnchorPoint = Vector2.new(1, 0),
										AutomaticSize = Enum.AutomaticSize.X,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Position = UDim2.fromScale(1, 0),
										Size = UDim2.fromScale(0, 1),
										[onChange("AbsoluteSize")] = function(arg2)
											v47:set(arg2.X)
										end,
										[children] = {
											scope:New("UIListLayout")({
												Padding = UDim.new(0, v46.Layout.AddonPadding),
												FillDirection = Enum.FillDirection.Horizontal,
												HorizontalAlignment = Enum.HorizontalAlignment.Right,
												SortOrder = Enum.SortOrder.LayoutOrder,
												VerticalAlignment = Enum.VerticalAlignment.Center,
											}),
											scope:New("Frame")({
												Name = "Holder",
												AutomaticSize = Enum.AutomaticSize.X,
												BackgroundColor3 = v45.BgPrimary,
												BackgroundTransparency = 0,
												BorderSizePixel = 0,
												ClipsDescendants = true,
												Size = UDim2.fromScale(0, 1),
												[children] = {
													arg.refs.Box:set(scope:New("TextBox")({
														Name = "Input",
														FontFace = v46.Fonts.Body,
														PlaceholderText = arg.placeholderText,
														Text = scope:Computed(function(arg2)
															return arg2(arg.textState)
														end),
														TextColor3 = v45.FgSecondary,
														TextSize = v46.Layout.PlaceholderTextSize,
														AutomaticSize = Enum.AutomaticSize.X,
														TextXAlignment = Enum.TextXAlignment.Left,
														BackgroundTransparency = 1,
														BorderSizePixel = 0,
														ClipsDescendants = true,
														LayoutOrder = 1,
														Size = UDim2.new(0, 0, 0, v46.Layout.BoxHeight),
														ZIndex = 2,
														[children] = {
															scope:New("UIPadding")({
																PaddingLeft = UDim.new(0, v46.Layout.BoxPaddingLeft),
															}),
															scope:New("UISizeConstraint")({
																MaxSize = Vector2.new(v46.Layout.MaxWidth, math.huge),
															}),
														},
														[onEvent("Focused")] = arg.onFocused,
														[onEvent("FocusLost")] = arg.onFocusLost,
													})),
													scope:New("UIListLayout")({
														FillDirection = Enum.FillDirection.Horizontal,
														SortOrder = Enum.SortOrder.LayoutOrder,
														VerticalAlignment = Enum.VerticalAlignment.Center,
													}),
													scope:New("UIStroke")({
														ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
														Color = v45.BgTertiary,
													}),
													scope:New("UICorner")({
														CornerRadius = UDim.new(0, v46.Layout.CornerRadius),
													}),
													scope:New("UIPadding")({
														PaddingRight = UDim.new(0, v46.Layout.BoxPaddingRight),
													}),
												},
											}),
										},
									}),
									v46.TextHolder.create({
										scope = scope,
										titleText = arg.titleText,
										titleColor = v45.FgSecondary,
										descriptionState = arg.descriptionState,
										descriptionColor = v45.FgTertiary,
										textSize = v46.Layout.TextSize,
										textPadding = v46.Layout.TextPadding,
										width = scope:Computed(function(arg2)
											return UDim2.new(1, -(arg2(v47) + v46.Layout.AddonPadding), 1, 0)
										end),
										fonts = v46.Fonts,
									}),
								},
							})
						end,
					}
				end)()
			)
		end,
		[48] = function()
			local v, instance, v43 = fn23(48)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent
					local userInputService = v43(parent.utils.services).UserInputService
					local utils = parent.utils
					local v44 = v43(utils.insertitem)
					local v45 = v43(utils.safecallback)
					local packages = parent.packages
					local v46 = v43(packages.fusion)
					local v47 = v43(parent.Internal)
					local v48 = v43(packages.states)
					local v49 = v43(packages.keybindDispatcher)
					local v50 = v43(parent.utils.controlRegistry)
					local v51 = v43(instance.interactions)
					local v52 = v43(instance.view)
					local scope = v47.Scope
					local peek = v46.peek
					local doCleanup = v46.doCleanup

					local index = {}
					index.__index = index
					index.__type = "Keybind"

					index.New = function(arg, arg2, arg3, arg4)
						local tbl14 = arg4 or {}
						local v53 = (arg2.Scope or scope):innerScope()
						local v54 = v53:Value(false)
						local v55 = v53:Value(tbl14.Default or "None")
						local v56 = v53:Value(tbl14.Description)

						local tbl15 = {
							Value = tbl14.Default or "None",
							Toggled = false,
							Mode = tbl14.Mode or "Toggle",
							Type = "Keybind",
							Callback = tbl14.Callback or function() end,
							Changed = function() end,
							Clicked = function() end,
						}

						local v57 = nil

						local function fn24(arg5)
							v57 = arg5
						end

						local function fn25(value, arg5)
							local value2 = tbl15.Value
							v55:set(value)
							tbl15.Value = value
							v49.updateKeybind(arg3, value, tbl14.Title or "Unknown Feature")

							if arg5 ~= nil then
								v45(function()
									tbl15.Changed(arg5)
								end)

								if value ~= value2 then
									v50.notifyControlChanged(arg3)
								end
							end
						end

						local tbl16 = { interactions = nil, pickingObserver = nil }

						tbl15.Render = function(arg5, arg6)
							local v58 = arg6:innerScope()

							tbl16.interactions = v51.create({
								scope = v58,
								getSessionScope = function()
									return v57
								end,
								setSessionScope = fn24,
								getPickingState = function()
									return peek(v54)
								end,
								setPickingState = function(arg7)
									v54:set(arg7)
								end,
								applyKey = fn25,
							})

							tbl16.pickingObserver = v58:Observer(v54):onChange(function()
								if not peek(v54) then
									tbl16.interactions.cleanupSession()
								end
							end)

							local root = v52.buildRoot({
								scope = v58,
								titleText = tbl14.Title or "",
								descriptionState = v56,
								keybindValueState = v55,
								pickingState = v54,
								onPickStart = tbl16.interactions.startPicking,
							})

							tbl15.Root = root
							return root
						end

						tbl15.GetState = function()
							if userInputService:GetFocusedTextBox() and tbl15.Mode ~= "Always" then
								return false
							end

							if tbl15.Mode == "Always" then
								return true
							end

							if tbl15.Mode == "Hold" then
								local value = tbl15.Value
								if value == "None" then
									return false
								end

								if value == "MouseLeft" then
									return userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
								end

								if value == "MouseRight" then
									return userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
								end
								return userInputService:IsKeyDown(Enum.KeyCode[value])
							end

							return tbl15.Toggled
						end

						tbl15.SetValue = function(arg5, value, mode2)
							value = value or tbl15.Value
							mode2 = mode2 or tbl15.Mode
							v55:set(value)
							tbl15.Value = value
							tbl15.Mode = mode2
							v49.updateKeybind(arg3, value, tbl14.Title or "Unknown Feature")
						end

						tbl15.OnClick = function(arg5, clicked)
							tbl15.Clicked = clicked
						end

						tbl15.OnChanged = function(arg5, changed)
							tbl15.Changed = changed
							changed(tbl15.Value)
						end

						tbl15.DoClick = function()
							local toggled = tbl15.Toggled

							v45(function()
								tbl15.Callback(toggled)
							end)

							v45(function()
								tbl15.Clicked(toggled)
							end)
						end

						local function fn26(arg5)
							local v58 = peek(v48.ActiveKeybinds)
							local v59 = table.clone(v58)
							v59[arg3] = arg5 or nil
							v48.ActiveKeybinds:set(v59)
						end

						tbl15.Destroy = function()
							fn26(false)
							v49.unregisterKeybindHandler(arg3)
							v49.removeKeybind(arg3)

							if v57 then
								doCleanup(v57)
								v57 = nil
							end

							doCleanup(v53)
							v50.unregisterControl(arg3)
						end

						v49.addKeybind(arg3, tbl15.Value, tbl14.Title or "Unknown Feature")

						v49.registerKeybindHandler(arg3, {
							onInputBegan = function()
								if peek(v54) then
									return
								end

								if tbl15.Mode == "Toggle" then
									tbl15.Toggled = not tbl15.Toggled
									fn26(tbl15.Toggled)
									tbl15:DoClick()
								elseif tbl15.Mode == "Hold" then
									fn26(true)
								end
							end,
							onInputEnded = function()
								if tbl15.Mode == "Hold" then
									fn26(false)
								end
							end,
						})

						v44(arg2.Container, tbl15)

						v50.registerControl({
							optionKey = arg3,
							element = tbl15,
							type = tbl15.Type,
							title = tbl14.Title,
							description = tbl14.Description,
							context = arg2.AgentContext,
							defaultValue = { key = tbl15.Value, mode = tbl15.Mode },
							risk = "write",
							getValue = function()
								return { key = tbl15.Value, mode = tbl15.Mode, toggled = tbl15.Toggled }
							end,
							setValue = function(arg5)
								if type(arg5) == "table" then
									tbl15:SetValue(arg5.key, arg5.mode)
									return
								end
								tbl15:SetValue(arg5)
							end,
						})

						return tbl15
					end

					return index
				end)()
			)
		end,
		[49] = function()
			fn23(49)

			return (function()
				return table.freeze({
					Layout = table.freeze({ ButtonCornerRadius = 2, ButtonPaddingLeft = 11, ButtonPaddingRight = 10 }),
				})
			end)()
		end,
		[50] = function()
			local v, instance, v43 = fn23(50)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local userInputService = v43(parent.utils.services).UserInputService
					local v44 = v43(parent.packages.keybindDispatcher)

					local function fn24(input)
						return input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
					end

					return {
						create = function(arg)
							local function fn25()
								local sessionScope = arg.getSessionScope()

								if sessionScope then
									sessionScope:doCleanup()
									arg.setSessionScope(nil)
								end
							end

							local function fn26()
								if not arg.getPickingState() then
									return
								end
								arg.setPickingState(false)
								fn25()
							end

							return {
								startPicking = function(arg2)
									if arg2 and not fn24(arg2) then
										return
									end

									if arg.getPickingState() then
										return
									end
									arg.setPickingState(true)
									local v45 = arg.scope:innerScope()
									arg.setSessionScope(v45)

									v45:insert(userInputService.InputBegan:Connect(function(input)
										if
											input.UserInputType == Enum.UserInputType.Keyboard
											and input.KeyCode == Enum.KeyCode.Escape
										then
											arg.applyKey("None", "None")
											fn26()
											return
										end

										local v46 = v44.normalizeInputToKey(input)
										if not v46 then
											return
										end

										v45:insert(userInputService.InputEnded:Connect(function(input2)
											if v44.isKeyMatch(input2, v46) then
												arg.applyKey(v46, input.KeyCode or input.UserInputType)
												fn26()
											end
										end))
									end))
								end,
								stopPicking = fn26,
								cleanupSession = fn25,
							}
						end,
					}
				end)()
			)
		end,
		[51] = function()
			local v, instance, v43 = fn23(51)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.storage.theme)
					local v46 = v43(instance.Parent.constants)
					local v47 = v43(instance.Parent.Parent.shared)
					local children = v44.Children
					local onEvent = v44.OnEvent

					return {
						buildRoot = function(arg)
							local scope = arg.scope

							local v48 = scope:New("TextButton")({
								Name = "Interact",
								FontFace = v47.Fonts.Body,
								Text = scope:Computed(function(arg2)
									if arg2(arg.pickingState) then
										return "..."
									end
									return arg2(arg.keybindValueState)
								end),
								TextColor3 = v45.FgSecondary,
								TextSize = v47.Layout.TextSize,
								TextXAlignment = Enum.TextXAlignment.Left,
								Active = false,
								AnchorPoint = Vector2.new(1, 0.5),
								AutomaticSize = Enum.AutomaticSize.X,
								BackgroundColor3 = v45.BgPrimary,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								LayoutOrder = 1,
								Position = UDim2.fromScale(1, 0.5),
								Selectable = false,
								Size = UDim2.fromOffset(0, v47.Layout.BoxHeight),
								[children] = {
									scope:New("UICorner")({ CornerRadius = UDim.new(0, v46.Layout.ButtonCornerRadius) }),
									scope:New("UIStroke")({
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = v45.BgTertiary,
									}),
									scope:New("UIPadding")({
										PaddingLeft = UDim.new(0, v46.Layout.ButtonPaddingLeft),
										PaddingRight = UDim.new(0, v46.Layout.ButtonPaddingRight),
									}),
								},
								[onEvent("InputEnded")] = arg.onPickStart,
							})

							return scope:New("Frame")({
								Name = "Keybind",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
								[children] = {
									v47.AddonsContainer.create({
										scope = scope,
										padding = v47.Layout.AddonPadding,
										children = { v48 },
									}),
									v47.TextHolder.create({
										scope = scope,
										titleText = arg.titleText,
										titleColor = v45.FgSecondary,
										descriptionState = arg.descriptionState,
										descriptionColor = v45.FgTertiary,
										textSize = v47.Layout.TextSize,
										textPadding = v47.Layout.TextPadding,
										fonts = v47.Fonts,
									}),
								},
							})
						end,
					}
				end)()
			)
		end,
		[52] = function()
			local v, instance, v43 = fn23(52)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.utils.insertitem)
					local v45 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local children = v45.Children
					local v46 = v43(instance.Parent.Parent.Parent.storage.theme)

					local index = {}
					index.__index = index
					index.__type = "Separator"

					index.New = function(arg, arg2)
						local tbl14

						tbl14 = {
							Scope = (arg2.Scope or scope):innerScope(),
							Root = nil,
							Render = function(arg3, arg4)
								local root = arg4:New("Frame")({
									Name = "Separator",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Interactable = false,
									Size = UDim2.new(1, 0, 0, 0),
									[children] = {
										arg4:New("Frame")({
											Name = "Frame",
											AnchorPoint = Vector2.new(0, 0.5),
											BackgroundColor3 = v46.BgTertiary,
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Position = UDim2.fromScale(0, 0.5),
											Size = UDim2.new(1, 0, 0, 0),
											[children] = {
												arg4:New("UIStroke")({ Name = "UIStroke", Color = v46.BgTertiary }),
											},
										}),
									},
								})

								tbl14.Root = root
								return root
							end,
						}

						v44(arg2.Container, tbl14)
						return tbl14
					end

					return index
				end)()
			)
		end,
		[53] = function()
			local v, v43, v44 = fn23(53)

			return (function()
				return table.freeze({
					TextHolder = v44(v43.TextHolder),
					AddonsContainer = v44(v43.AddonsContainer),
					Fonts = v44(v43.fonts),
					Layout = v44(v43.layout),
				})
			end)()
		end,
		[54] = function()
			local v, instance, v43 = fn23(54)

			return (function()
				local children = v43(instance.Parent.Parent.Parent.Parent.packages.fusion).Children
				local v44 = v43(instance.Parent.layout)

				local function fn24(...)
					local v45 = table.pack(...)
					local tbl14 = {}

					for i = 1, select("#", ...) do
						local value = select(i, table.unpack(v45, 1, v45.n))

						if value then
							for k, v46 in pairs(value) do
								tbl14[k] = v46
							end
						end
					end

					return tbl14
				end

				return table.freeze({
					create = function(arg)
						local scope = arg.scope
						local children2 = arg.children or {}
						local padding = arg.padding or v44.AddonPadding
						local anchorPoint = arg.anchorPoint or Vector2.new(1, 0)
						local position = arg.position or UDim2.fromScale(1, 0)
						local size = arg.size or UDim2.fromScale(0, 1)

						local children3 = {
							scope:New("UIListLayout")({
								Padding = UDim.new(0, padding),
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Right,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							}),
						}

						for _, child in ipairs(children2) do
							table.insert(children3, child)
						end

						return scope:New("Frame")(fn24({
							Name = "Addons",
							AnchorPoint = anchorPoint,
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = position,
							Size = size,
							[children] = children3,
						}, arg.extend))
					end,
				})
			end)()
		end,
		[55] = function()
			local v, instance, v43 = fn23(55)

			return (function()
				local children = v43(instance.Parent.Parent.Parent.Parent.packages.fusion).Children
				local v44 = v43(instance.Parent.fonts)
				local guiObject = v43(instance.Parent.layout)

				return table.freeze({
					create = function(arg)
						local scope = arg.scope
						local titleText = arg.titleText
						local titleColor = arg.titleColor
						local descriptionState = arg.descriptionState
						local descriptionColor = arg.descriptionColor
						local textSize = arg.textSize or guiObject.TextSize
						local textPadding = arg.textPadding or guiObject.TextPadding
						local width = arg.width or UDim2.new(1, -80, 1, 0)
						local fonts = arg.fonts or v44
						local Frame = scope:New("Frame")

						local childrens = {
							Name = "TextHolder",
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = width,
						}

						local children2 = children
						local tbl14 = {}

						local v45 = scope:New("TextLabel")({
							Name = "Title",
							FontFace = fonts.Title,
							Text = titleText,
							TextColor3 = titleColor,
							TextSize = textSize,
							TextXAlignment = Enum.TextXAlignment.Left,
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.fromOffset(0, 10),
							Size = UDim2.fromScale(1, 0),
							TextTruncate = Enum.TextTruncate.None,
						})

						local v46 = scope:New("UIListLayout")({
							Padding = UDim.new(0, textPadding),
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
						})

						local descriptionState2 = descriptionState
								and scope:Computed(function(arg2, arg3)
									local v47 = arg2(descriptionState)

									if v47 and v47 ~= "" then
										return arg3:New("TextLabel")({
											Name = "Description",
											FontFace = fonts.Body,
											RichText = true,
											Text = v47,
											TextColor3 = descriptionColor,
											TextSize = textSize,
											TextWrapped = true,
											TextXAlignment = Enum.TextXAlignment.Left,
											AutomaticSize = Enum.AutomaticSize.Y,
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											Position = UDim2.fromOffset(0, 10),
											Size = UDim2.fromScale(1, 0),
										})
									end

									return nil
								end)
							or nil

						tbl14[1] = v45
						tbl14[2] = v46
						tbl14[3] = descriptionState2
						childrens[children2] = tbl14
						return Frame(childrens)
					end,
				})
			end)()
		end,
		[56] = function()
			fn23(56)

			return (function()
				return table.freeze({
					Title = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
					Body = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					Mono = Font.fromEnum(Enum.Font.RobotoMono),
				})
			end)()
		end,
		[57] = function()
			fn23(57)

			return (function()
				return table.freeze({
					AddonPadding = 15,
					TextPadding = 5,
					BoxPaddingLeft = 10,
					BoxPaddingRight = 10,
					CornerRadius = 2,
					TextSize = 15,
					PlaceholderTextSize = 14,
					BoxHeight = 25,
					MaxWidth = 200,
				})
			end)()
		end,
		[58] = function()
			local v, instance, v43 = fn23(58)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent
					local runService = v43(parent.utils.services).RunService
					local utils = parent.utils
					local v44 = v43(utils.insertitem)
					local v45 = v43(utils.safecallback)
					local v46 = v43(utils.pendingTasks)
					local v47 = v43(parent.packages.fusion)
					local v48 = v43(parent.Internal)
					local v49 = v43(parent.utils.controlRegistry)
					local scope = v48.Scope
					local peek = v47.peek
					local v50 = v43(instance.view)
					local v51 = v43(instance.drag)

					local index = {}
					index.__index = index
					index.__type = "Slider"

					local function fn24(arg, rounding)
						if arg == nil then
							return 0
						end
						local n = 10 ^ (rounding or 0)
						return math.floor(arg * n + 0.5) / n
					end

					index.New = function(arg, arg2, arg3, arg4)
						local v52 = (arg2.Scope or scope):innerScope()
						local min = arg4.Min or 0
						local max = arg4.Max or 100
						local rounding = arg4.Rounding or 0
						local suffix = arg4.Suffix or ""

						if max <= min then
							max = min + 1
						end

						local v53 = fn24(math.clamp(arg4.Default or min, min, max), rounding)
						local v54 = v52:Value(v53)
						local v55 = v52:Value(min)
						local v56 = v52:Value(max)
						local v57 = v52:Value(false)
						local v58 = v52:Value(false)
						local v59 = v52:Value(nil)
						local v60 = v52:Value(nil)

						local tbl14 = {
							Title = arg4.Title,
							Description = arg4.Description,
							Suffix = suffix,
							Default = v53,
							Min = min,
							Max = max,
							Value = v53,
							Rounding = rounding,
							Type = "Slider",
							Callback = arg4.Callback or function() end,
							Changed = function() end,
						}

						local function fn25(arg5)
							if arg5 == nil then
								return
							end
							local v61 = peek(v55)
							local v62 = peek(v56)
							local value = math.clamp(fn24(arg5, rounding), v61, v62)

							if peek(v54) ~= value then
								v54:set(value)
								tbl14.Value = value
							end
						end

						local function fn26(arg5)
							if arg5 == nil then
								return
							end
							local value = fn24(arg5, rounding)

							if peek(v54) ~= value then
								v54:set(value)
								tbl14.Value = value
							end
						end

						local function fn27()
							v58:set(true)

							v46.spawn(function()
								runService.Heartbeat:Wait()
								local v61 = peek(v60)

								if v61 then
									v61:CaptureFocus()
								end
							end)
						end

						local function fn28(arg5)
							v58:set(false)
							if not arg5 then
								return
							end
							local num = tonumber(arg5)

							if not num and suffix ~= "" then
								local v61 = string.gsub(arg5, suffix .. "$", "")
								num = tonumber(v61)
							end

							if num then
								fn26(num)
							end
						end

						local function fn29()
							v58:set(false)
						end

						tbl14.Render = function(arg5, arg6)
							local root = v50.build({
								scope = arg6,
								props = arg4,
								valueState = v54,
								minState = v55,
								maxState = v56,
								rounding = rounding,
								suffix = suffix,
								isGrabbing = v57,
								isEditing = v58,
								barRef = v59,
								textBoxRef = v60,
								setValue = fn25,
								commitEdit = fn28,
								cancelEdit = fn29,
								startEdit = fn27,
							})

							tbl14.Root = root
							return root
						end

						local flag19 = true

						v52:Observer(v54):onChange(function()
							if flag19 then
								flag19 = false
								return
							end
							local value = peek(v54)
							tbl14.Value = value

							v45(function()
								tbl14.Callback(value)
								tbl14.Changed(value)
							end)

							v49.notifyControlChanged(arg3)
						end)

						v52:insert(function()
							v51.cleanup()
						end)

						tbl14.SetValue = function(arg5, arg6)
							fn25(arg6)

							v45(function()
								tbl14.Callback(peek(v54))
								tbl14.Changed(peek(v54))
							end)
						end

						tbl14.OnChanged = function(arg5, changed)
							tbl14.Changed = changed
							changed(peek(v54))
						end

						tbl14.UpdateMin = function(arg5, min2)
							v55:set(min2)
							tbl14.Min = min2
							local v61 = peek(v54)
							local v62 = peek(v56)
							local n = math.clamp(v61, min2, v62)

							if n ~= v61 then
								fn25(n)
							end
						end

						tbl14.UpdateMax = function(arg5, max2)
							v56:set(max2)
							tbl14.Max = max2
							local v61 = peek(v54)
							local n = math.clamp(v61, peek(v55), max2)

							if n ~= v61 then
								fn25(n)
							end
						end

						v44(arg2.Container, tbl14)

						v49.registerControl({
							optionKey = arg3,
							element = tbl14,
							type = tbl14.Type,
							title = arg4.Title,
							description = arg4.Description,
							context = arg2.AgentContext,
							minimum = min,
							maximum = max,
							step = 1 / 10 ^ rounding,
							defaultValue = v53,
							risk = "write",
							getValue = function()
								return tbl14.Value
							end,
							setValue = function(arg5)
								tbl14:SetValue(arg5)
							end,
						})

						v45(function()
							do
								tbl14.Callback(peek(v54))
								return
							end

							while true do
							end
						end)

						return tbl14
					end

					return index
				end)()
			)
		end,
		[59] = function()
			local v, instance, v43 = fn23(59)

			return (function()
				local parent = instance.Parent.Parent.Parent.Parent
				local userInputService = v43(parent.utils.services).UserInputService
				local v44 = v43(parent.packages.fusion)
				local scope = v43(parent.Internal).Scope
				local peek = v44.peek
				local v45 = nil

				local function fn24(arg)
					if v45 then
						v45:doCleanup()
						v45 = nil
					end

					arg:set(false)
				end

				return table.freeze({
					startDrag = function(e, M, x, O, R, d, d)
						fn24(x)
						x:set(true)
						v45 = (e or scope):innerScope()

						local function e(p)
							local I = peek(M)
							if not I then
								return
							end
							local M, E = I.AbsolutePosition.X, I.AbsoluteSize.X
							if E <= 0 then
								return
							end
							I = peek(O)
							local O, w = peek(R) - I, p.X - M
							d(I + (math.clamp(w / E, 0, 1) * O))
						end

						e(userInputService:GetMouseLocation())

						v45:insert(userInputService.InputChanged:Connect(function(M)
							if
								(M.UserInputType == Enum.UserInputType.MouseMovement)
								or (M.UserInputType == Enum.UserInputType.Touch)
							then
								e(M.Position)
							end
						end))

						v45:insert(userInputService.InputEnded:Connect(function(e)
							if
								(e.UserInputType == Enum.UserInputType.MouseButton1)
								or (e.UserInputType == Enum.UserInputType.Touch)
							then
								fn24(x)
							end
						end))
					end,
					stopDrag = fn24,
					cleanup = function()
						if v45 then
							v45:doCleanup()
							v45 = nil
						end
					end,
				})
			end)()
		end,
		[60] = function()
			local v, instance, v43 = fn23(60)

			return (function()
				local parent = instance.Parent.Parent.Parent.Parent
				local v44 = v43(parent.packages.fusion)
				local v45 = v43(parent.storage.theme)
				local v46 = v43(parent.utils.animate)
				local v47 = v43(instance.Parent.drag)
				local v48 = v43(instance.Parent.Parent.shared)
				local children = v44.Children
				local onEvent = v44.OnEvent
				local peek = v44.peek
				local title = v48.Fonts.Title
				local body = v48.Fonts.Body

				return table.freeze({
					build = function(arg)
						local scope = arg.scope
						local props = arg.props
						local valueState = arg.valueState
						local minState = arg.minState
						local maxState = arg.maxState
						local rounding = arg.rounding
						local suffix = arg.suffix
						local isGrabbing = arg.isGrabbing
						local isEditing = arg.isEditing
						local barRef = arg.barRef
						local textBoxRef = arg.textBoxRef
						local setValue = arg.setValue
						local commitEdit = arg.commitEdit
						local cancelEdit = arg.cancelEdit
						local startEdit = arg.startEdit

						local v49 = scope:Computed(function(arg2)
							local v49 = arg2(valueState)
							local v50 = arg2(minState)
							local n = arg2(maxState) - v50
							if n <= 0 then
								return 0
							end
							return math.clamp((v49 - v50) / n, 0, 1)
						end)

						local v50 = scope:Computed(function(arg2)
							return UDim2.fromScale(arg2(v49), 1)
						end)

						local str7 = "%." .. rounding .. "f"

						local v51 = scope:Computed(function(arg2)
							local v51 = arg2(valueState)
							return string.format(str7, v51) .. suffix
						end)

						local v52 = scope:Computed(function(arg2)
							return arg2(isGrabbing) and arg2(v45.FgPrimary) or arg2(v45.FgSecondary)
						end)

						local v53 = scope:Value(false)

						local v54 = scope:Computed(function(arg2)
							return arg2(v53) and UDim2.fromOffset(15, 15) or UDim2.fromOffset(12, 12)
						end)

						local Frame = scope:New("Frame")

						local childrens = {
							Name = "Slider",
							Size = UDim2.fromScale(1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.Y,
						}

						local children2 = children
						local tbl14 = {}
						local v55 = scope:New("UIListLayout")({
							Padding = UDim.new(0, 10),
							SortOrder = Enum.SortOrder.LayoutOrder,
						})
						local Frame2 = scope:New("Frame")

						local childrens2 = {
							Name = "TextHolder",
							LayoutOrder = 1,
							Size = UDim2.fromScale(1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.Y,
						}

						local children3 = children
						local tbl15 = {}
						local Frame3 = scope:New("Frame")

						local childrens3 = {
							Name = "Text",
							Size = UDim2.fromScale(1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.Y,
						}

						local children4 = children
						local tbl16 = {}

						local v56 = scope:New("UIListLayout")({
							Padding = UDim.new(0, 5),
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
						})

						local v57 = scope:New("TextLabel")({
							Name = "Title",
							FontFace = title,
							Text = props.Title or "",
							TextColor3 = v46(function(arg2)
								return arg2(v52)
							end, 40, 1, scope),
							TextSize = 15,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.fromScale(1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.Y,
						})

						local description = props.Description
								and scope:New("TextLabel")({
									Name = "Description",
									FontFace = body,
									RichText = true,
									Text = props.Description,
									TextColor3 = v45.FgTertiary,
									TextSize = 15,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Left,
									Size = UDim2.new(1, -50, 0, 0),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									AutomaticSize = Enum.AutomaticSize.Y,
								})
							or nil

						tbl16[1] = v56
						tbl16[2] = v57
						tbl16[3] = description
						childrens3[children4] = tbl16
						local v58 = Frame3(childrens3)
						local set = textBoxRef.set

						local v59 = table.pack(scope:New("Frame")({
							Name = "ValueContainer",
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.fromScale(1, 0.5),
							AutomaticSize = Enum.AutomaticSize.XY,
							Size = UDim2.fromOffset(0, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							[children] = {
								scope:New("TextButton")({
									Name = "Value",
									FontFace = title,
									Text = v51,
									TextColor3 = v46(function(arg2)
										return arg2(v52)
									end, 40, 1, scope),
									TextSize = 15,
									TextXAlignment = Enum.TextXAlignment.Right,
									AutomaticSize = Enum.AutomaticSize.XY,
									AutoButtonColor = false,
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Visible = scope:Computed(function(arg2)
										return not arg2(isEditing)
									end),
									[onEvent("Activated")] = function()
										startEdit()
									end,
								}),
								set(
									textBoxRef,
									scope:New("TextBox")({
										Name = "ValueInput",
										FontFace = title,
										Text = scope:Computed(function(arg2)
											return tostring(arg2(valueState))
										end),
										TextColor3 = v45.FgPrimary,
										TextSize = 15,
										TextXAlignment = Enum.TextXAlignment.Right,
										AutomaticSize = Enum.AutomaticSize.XY,
										BackgroundTransparency = 0.9,
										BackgroundColor3 = v45.BgPrimaryHighlight,
										BorderSizePixel = 0,
										ClearTextOnFocus = false,
										Visible = isEditing,
										[onEvent("FocusLost")] = function(arg2)
											if arg2 then
												local v59 = peek(textBoxRef)

												if v59 then
													commitEdit(v59.Text)
												end
											else
												cancelEdit()
											end
										end,
										[onEvent("Focused")] = function()
											local v59 = peek(textBoxRef)

											if v59 then
												v59.CursorPosition = #v59.Text + 1
												v59.SelectionStart = 1
											end
										end,
									})
								),
							},
						}))

						tbl15[1] = v58

						do
							local values = table.pack(table.unpack(v59, 1, v59.n))
							table.move(values, 1, values.n, 2, tbl15)
						end

						childrens2[children3] = tbl15
						local v60 = Frame2(childrens2)

						local v61 = table.pack(barRef:set(scope:New("Frame")({
							Name = "Bar",
							BackgroundColor3 = v45.BgPrimaryHighlight,
							BorderSizePixel = 0,
							LayoutOrder = 2,
							Size = UDim2.new(1, 0, 0, 5),
							[children] = {
								scope:New("UIStroke")({ Color = v45.BgTertiary }),
								scope:New("UICorner")({ CornerRadius = UDim.new(0, 2) }),
								scope:New("Frame")({
									Name = "Progress",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundColor3 = v45.AccentPrimary,
									BorderSizePixel = 0,
									Position = UDim2.fromScale(0, 0.5),
									Size = v46(function(arg2)
										return arg2(v50)
									end, 40, 1, scope),
									[children] = {
										scope:New("UIStroke")({ Color = v45.BgTertiary }),
										scope:New("UICorner")({ CornerRadius = UDim.new(0, 2) }),
										scope:New("Frame")({
											Name = "Drag",
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = v45.FgPrimary,
											BorderSizePixel = 0,
											Position = UDim2.fromScale(1, 0.5),
											Size = v46(function(arg2)
												return arg2(v54)
											end, 40, 1, scope),
											[children] = { scope:New("UICorner")({ CornerRadius = UDim.new(1, 0) }) },
											[onEvent("MouseEnter")] = function()
												v53:set(true)
											end,
											[onEvent("MouseLeave")] = function()
												v53:set(false)
											end,
										}),
									},
								}),
							},
							[onEvent("InputBegan")] = function(input)
								if
									input.UserInputType == Enum.UserInputType.MouseButton1
									or input.UserInputType == Enum.UserInputType.Touch
								then
									if not peek(isEditing) then
										v47.startDrag(scope, barRef, isGrabbing, minState, maxState, rounding, setValue)
									end
								end
							end,
						})))

						tbl14[1] = v55
						tbl14[2] = v60

						do
							local values = table.pack(table.unpack(v61, 1, v61.n))
							table.move(values, 1, values.n, 3, tbl14)
						end

						childrens[children2] = tbl14

						childrens[onEvent("InputBegan")] = function(input)
							if
								input.UserInputType == Enum.UserInputType.MouseButton1
								or input.UserInputType == Enum.UserInputType.Touch
							then
								if not peek(isEditing) then
									v47.startDrag(scope, barRef, isGrabbing, minState, maxState, rounding, setValue)
								end
							end
						end

						return (Frame(childrens))
					end,
				})
			end)()
		end,
		[61] = function()
			local v, instance, v43 = fn23(61)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent
					local v44 = v43(parent.utils.insertitem)
					local packages = parent.packages
					local v45 = v43(packages.fusion)
					local v46 = v43(parent.Internal)
					local v47 = v43(packages.states)
					local v48 = v43(instance.interactions)
					local v49 = v43(instance.view)
					local scope = v46.Scope
					local peek = v45.peek
					local doCleanup = v45.doCleanup

					local function fn24(arg)
						if arg == nil then
							return table.freeze({})
						end
						return table.freeze(table.clone(arg))
					end

					local index = {}
					index.__index = index
					index.__type = "Table"

					index.New = function(arg, arg2, arg3, arg4)
						local tbl14 = arg4 or {}
						local v50 = (arg2.Scope or scope):innerScope()
						local tbl15 = { Type = "Table" }
						local v51 = v50:Value(fn24(tbl14.Headers))
						local v52 = v50:Value(fn24(tbl14.Rows))
						local v53 = v50:Value(tbl14.ItemsPerPage or 10)
						local v54 = v50:Value(1)

						local v55 = v50:Computed(function(arg5)
							return math.ceil(#arg5(v52) / arg5(v53))
						end)

						local tbl16 = {}

						local function fn25(arg5, arg6)
							local v56 = tbl16[arg5]
							if v56 and v56.Data == arg6 then
								return v56
							end
							local v57 = table.freeze({ OriginalIndex = arg5, Data = arg6 })
							tbl16[arg5] = v57
							return v57
						end

						local v56 = v50:Computed(function(arg5)
							local v56 = arg5(v52)
							local v57 = arg5(v54)
							local v58 = arg5(v53)
							local n = (v57 - 1) * v58 + 1
							local tbl17 = {}

							for i = n, math.min(n + v58 - 1, #v56) do
								tbl17[#tbl17 + 1] = fn25(i, v56[i])
							end

							return table.freeze(tbl17)
						end)

						local v57 = v50:Computed(function(arg5)
							local v57 = arg5(v51)
							if #v57 == 0 then
								return UDim2.new(1, 0, 1, 0)
							end
							return UDim2.new(1 / #v57, 0, 1, 0)
						end)

						local v58 = v50:Value(nil)
						local v59 = v50:Value(false)
						local v60 = v50:Value(UDim2.fromOffset(0, 0))
						local v61 = v50:Value(UDim2.fromOffset(0, 0))
						local v62 = v50:Value(tbl14.Description)
						local tbl17 = { interactions = nil, selectionObserver = nil }
						local v63 = nil

						if not tbl14.DisablePagination then
							v63 = v50:Computed(function(arg5)
								return arg5(v55) > 1
							end)
						end

						local function fn26(arg5)
							local v64 = peek(v55)
							local n = math.max(1, math.min(arg5, v64))
							v54:set(n)

							if tbl14.OnPageChange then
								tbl14.OnPageChange(n)
							end
						end

						tbl15.Render = function(arg5, arg6)
							local v64 = arg6:innerScope()
							tbl17.interactions = v48.create({
								selectedCell = v58,
								selectionVisible = v59,
								selectionPosition = v60,
								selectionSize = v61,
							})

							tbl17.selectionObserver = v64:Observer(v58):onChange(function()
								tbl17.interactions.updateSelectionHighlight(peek(v58))
							end)

							local v65 = peek(v47.Library)

							v49.buildSelectionHighlight({
								scope = v64,
								selectionVisible = v59,
								selectionPosition = v60,
								selectionSize = v61,
								selectionParent = v65 and v65.GUI or nil,
							})

							local root = v49.buildRoot({
								scope = v64,
								headersState = v51,
								visibleRows = v56,
								headerWidth = v57,
								titleText = tbl14.Title or "",
								descriptionState = v62,
								layoutOrder = tbl14.LayoutOrder,
								alternateBackground = tbl14.AlternateBackground or false,
								showPagination = v63,
								currentPage = v54,
								totalPages = v55,
								onPrevPage = function()
									if peek(v54) > 1 then
										fn26(peek(v54) - 1)
									end
								end,
								onNextPage = function()
									if peek(v54) < peek(v55) then
										fn26(peek(v54) + 1)
									end
								end,
								onCellFocused = function(arg7)
									v58:set(arg7)
								end,
								onCellFocusLost = function(arg7, arg8, arg9, arg10)
									v58:set(nil)
									v59:set(false)

									if tbl14.OnRowUpdate then
										local v66 = table.clone(arg10)
										v66[arg8.Key] = arg9 and arg9.Text or ""
										tbl14.OnRowUpdate(arg7, v66)
									end
								end,
							})

							tbl15.Root = root
							return root
						end

						tbl15.UpdateHeaders = function(arg5, arg6)
							v51:set(fn24(arg6))
						end

						tbl15.UpdateRows = function(arg5, arg6)
							table.clear(tbl16)
							v52:set(fn24(arg6))
							v54:set(1)
						end

						tbl15.SetPage = function(arg5, arg6)
							fn26(arg6)
						end

						tbl15.NextPage = function()
							fn26(peek(v54) + 1)
						end

						tbl15.PrevPage = function()
							fn26(peek(v54) - 1)
						end

						tbl15.SetItemsPerPage = function(arg5, arg6)
							v53:set(arg6)
							v54:set(1)
						end

						tbl15.GetPageInfo = function()
							return {
								CurrentPage = peek(v54),
								TotalPages = peek(v55),
								ItemsPerPage = peek(v53),
								TotalItems = #peek(v52),
							}
						end

						tbl15.Destroy = function()
							if tbl17.selectionObserver ~= nil then
								tbl17.selectionObserver()
								tbl17.selectionObserver = nil
							end

							if tbl17.interactions then
								tbl17.interactions.cleanup()
							end

							doCleanup(v50)
						end

						if arg2.Container ~= nil then
							v44(arg2.Container, tbl15)
						end

						return tbl15
					end

					return index
				end)()
			)
		end,
		[62] = function()
			fn23(62)

			return (function()
				return table.freeze({
					Sizes = table.freeze({
						HeaderHeight = 30,
						RowHeight = 30,
						SelectionBorder = 2,
						PageButtonWidth = 80,
						PageInfoWidth = 50,
						PageControlHeight = 25,
						PaginationHeight = 20,
					}),
					Layout = table.freeze({ MainPadding = 8, HeaderPadding = 10, HolderPadding = 5, EntryPadding = 10 }),
				})
			end)()
		end,
		[63] = function()
			local v, instance, v43 = fn23(63)

			return (
				(function()
					local peek = v43(instance.Parent.Parent.Parent.Parent.packages.fusion).peek

					return {
						create = function(arg)
							local connection = nil
							local connection2 = nil

							local function fn24()
								if connection then
									connection:Disconnect()
									connection = nil
								end

								if connection2 then
									connection2:Disconnect()
									connection2 = nil
								end
							end

							return {
								updateSelectionHighlight = function(guiObject)
									fn24()
									if not guiObject then
										arg.selectionVisible:set(false)
										return
									end
									local absolutePosition = guiObject.AbsolutePosition
									local absoluteSize = guiObject.AbsoluteSize
									arg.selectionPosition:set(UDim2.fromOffset(absolutePosition.X, absolutePosition.Y))
									arg.selectionSize:set(UDim2.fromOffset(absoluteSize.X, absoluteSize.Y))
									arg.selectionVisible:set(true)

									connection = guiObject
										:GetPropertyChangedSignal("AbsolutePosition")
										:Connect(function()
											if peek(arg.selectedCell) == guiObject then
												local absolutePosition2 = guiObject.AbsolutePosition
												arg.selectionPosition:set(
													UDim2.fromOffset(absolutePosition2.X, absolutePosition2.Y)
												)
											end
										end)

									connection2 = guiObject.Destroying:Connect(function()
										fn24()
										arg.selectionVisible:set(false)
									end)
								end,
								cleanup = function()
									fn24()
								end,
							}
						end,
					}
				end)()
			)
		end,
		[64] = function()
			local v, instance, v43 = fn23(64)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.storage.theme)
					local v46 = v43(instance.Parent.constants)
					local v47 = v43(instance.Parent.Parent.shared)
					local children = v44.Children
					local onEvent = v44.OnEvent
					local peek = v44.peek

					local function fn24(arg, bgTertiary)
						return arg:New("UIStroke")({ Color = bgTertiary })
					end

					local function fn25(arg, arg2)
						return arg:New("UIPadding")({ PaddingLeft = UDim.new(0, arg2 or v46.Layout.EntryPadding) })
					end

					local function fn26(...)
						local v48 = table.pack(...)
						local tbl14 = {}

						for i = 1, select("#", ...) do
							local value = select(i, table.unpack(v48, 1, v48.n))

							if value then
								for k, v49 in pairs(value) do
									tbl14[k] = v49
								end
							end
						end

						return tbl14
					end

					return {
						buildSelectionHighlight = function(arg)
							local scope = arg.scope

							return scope:New("Frame")({
								Name = "SelectionHighlight",
								BackgroundTransparency = 1,
								Size = arg.selectionSize,
								Position = arg.selectionPosition,
								BorderSizePixel = 0,
								ZIndex = 50,
								Visible = arg.selectionVisible,
								Parent = arg.selectionParent,
								[children] = {
									scope:New("Frame")({
										Name = "TopBorder",
										BackgroundColor3 = v45.AccentPrimary,
										Size = UDim2.new(1, 0, 0, v46.Sizes.SelectionBorder),
										Position = UDim2.fromOffset(0, 0),
										BorderSizePixel = 0,
										ZIndex = 1,
									}),
									scope:New("Frame")({
										Name = "LeftBorder",
										BackgroundColor3 = v45.AccentPrimary,
										Size = UDim2.new(0, v46.Sizes.SelectionBorder, 1, 0),
										Position = UDim2.fromOffset(0, 0),
										BorderSizePixel = 0,
										ZIndex = 1,
									}),
									scope:New("Frame")({
										Name = "RightBorder",
										BackgroundColor3 = v45.AccentPrimary,
										Size = UDim2.new(0, v46.Sizes.SelectionBorder, 1, 0),
										Position = UDim2.new(1, -v46.Sizes.SelectionBorder, 0, 0),
										BorderSizePixel = 0,
										ZIndex = 1,
									}),
									scope:New("Frame")({
										Name = "BottomBorder",
										BackgroundColor3 = v45.AccentPrimary,
										Size = UDim2.new(1, 0, 0, v46.Sizes.SelectionBorder),
										Position = UDim2.new(0, 0, 1, -v46.Sizes.SelectionBorder),
										BorderSizePixel = 0,
										ZIndex = 1,
									}),
								},
							})
						end,
						buildRoot = function(arg)
							local scope = arg.scope

							local v48 = scope:New("Frame")({
								Name = "TextHolder",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.new(1, 0, 0, 0),
								LayoutOrder = 1,
								[children] = {
									scope:New("UIListLayout")({
										Padding = UDim.new(0, v47.Layout.TextPadding),
										VerticalAlignment = Enum.VerticalAlignment.Top,
										HorizontalAlignment = Enum.HorizontalAlignment.Left,
										SortOrder = Enum.SortOrder.LayoutOrder,
									}),
									scope:New("TextLabel")({
										Name = "Title",
										FontFace = v47.Fonts.Title,
										Text = arg.titleText,
										TextColor3 = v45.FgSecondary,
										TextSize = 15,
										TextXAlignment = Enum.TextXAlignment.Left,
										AutomaticSize = Enum.AutomaticSize.Y,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Position = UDim2.fromOffset(0, 0),
										LayoutOrder = 1,
										Size = UDim2.fromScale(1, 0),
									}),
									scope:Computed(function(arg2, arg3)
										local v48 = arg2(arg.descriptionState)

										if v48 and v48 ~= "" then
											return arg3:New("TextLabel")({
												Name = "Description",
												FontFace = v47.Fonts.Body,
												RichText = true,
												Text = v48,
												TextColor3 = v45.FgTertiary,
												TextSize = 15,
												TextWrapped = true,
												TextXAlignment = Enum.TextXAlignment.Left,
												AutomaticSize = Enum.AutomaticSize.Y,
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
												Position = UDim2.fromOffset(0, 0),
												LayoutOrder = 2,
												Size = UDim2.fromScale(1, 0),
												Visible = true,
											})
										end

										return nil
									end),
								},
							})

							local v49 = scope:New("Frame")({
								Name = "Top",
								BackgroundColor3 = v45.BgPrimary,
								BorderSizePixel = 0,
								LayoutOrder = -1,
								Size = UDim2.new(1, 0, 0, v46.Sizes.HeaderHeight),
								[children] = {
									fn24(scope, v45.BgTertiary),
									scope:New("UIListLayout")({
										FillDirection = Enum.FillDirection.Horizontal,
										SortOrder = Enum.SortOrder.LayoutOrder,
									}),
									scope:ForPairs(arg.headersState, function(arg2, arg3, arg4, arg5)
										return arg4,
											arg3:New("Frame")({
												Name = "Header",
												Size = arg.headerWidth,
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
												[children] = {
													arg3:New("Frame")({
														Name = "UIStroke",
														BackgroundColor3 = v45.BgTertiary,
														Size = UDim2.new(0, 1, 1, 0),
														Position = UDim2.fromScale(1, 0),
													}),
													arg3:New("TextLabel")({
														Name = "Title",
														FontFace = v47.Fonts.Title,
														Text = arg5.Name,
														TextColor3 = v45.FgSecondary,
														TextSize = 14,
														TextTruncate = Enum.TextTruncate.AtEnd,
														BackgroundTransparency = 1,
														BorderSizePixel = 0,
														TextXAlignment = Enum.TextXAlignment.Left,
														Size = UDim2.fromScale(1, 1),
														[children] = { fn25(arg3, v46.Layout.HeaderPadding) },
													}),
												},
											})
									end),
								},
							})

							local forPairs = scope.ForPairs
							local visibleRows = arg.visibleRows

							local v50 = scope:New("Frame")({
								Name = "Entry",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.new(1, 0, 0, v46.Sizes.RowHeight),
								[children] = {
									scope:New("UIListLayout")({ SortOrder = Enum.SortOrder.LayoutOrder }),
									forPairs(scope, visibleRows, function(arg2, arg3, arg4, arg5)
										local data = arg5.Data
										local originalIndex = arg5.OriginalIndex
										local v50 = arg3:Value(arg4 % 2 == 0 and arg.alternateBackground or false)

										local v51 = arg3:Computed(function(arg6)
											return arg6(v50) and arg6(v45.BgPrimary) or arg6(v45.BgPrimaryHighlight)
										end)

										return arg4,
											arg3:New("Frame")({
												Name = "Row",
												BackgroundColor3 = v51,
												BorderSizePixel = 0,
												LayoutOrder = arg4,
												Size = UDim2.new(1, 0, 0, v46.Sizes.RowHeight),
												[children] = {
													fn24(arg3, v45.BgTertiary),
													arg3:New("UIListLayout")({
														FillDirection = Enum.FillDirection.Horizontal,
														SortOrder = Enum.SortOrder.LayoutOrder,
													}),
													arg3:ForPairs(arg.headersState, function(arg6, arg7, arg8, arg9)
														local v52 = arg7:Value(nil)
														local v53 = arg7:Value(nil)
														local editable = arg9.Editable or false
														local v54 = v52
														local set = v54.set
														local Frame = arg7:New("Frame")
														local childrens = {
															Name = "Entry",
															BackgroundTransparency = 1,
															BorderSizePixel = 0,
															Size = arg.headerWidth,
														}
														local children2 = children
														local tbl14 = {}

														local v55 = arg7:New("Frame")({
															Name = "UIStroke",
															BackgroundColor3 = v45.BgTertiary,
															Size = UDim2.new(0, 1, 1, 0),
															Position = UDim2.fromScale(1, 0),
														})

														local v56 = v53
														local set2 = v56.set
														local TextBox = arg7:New("TextBox")

														local childrens2 = {
															Name = "Title",
															FontFace = v47.Fonts.Title,
															Text = tostring(data[arg9.Key] or ""),
															Interactable = editable,
															TextColor3 = v45.FgSecondary,
															TextSize = 14,
															TextTruncate = Enum.TextTruncate.AtEnd,
															ClearTextOnFocus = false,
															BackgroundTransparency = 1,
															BorderSizePixel = 0,
															TextXAlignment = Enum.TextXAlignment.Left,
															Size = UDim2.fromScale(1, 1),
														}

														childrens2[children] = { fn25(arg7, v46.Layout.EntryPadding) }

														childrens2[onEvent("Focused")] = function()
															if editable then
																arg.onCellFocused(peek(v52))
															end
														end

														childrens2[onEvent("FocusLost")] = function()
															arg.onCellFocusLost(originalIndex, arg9, peek(v53), data)
														end

														local v57 = table.pack(set2(v56, TextBox(childrens2)))
														tbl14[1] = v55

														do
															local values = table.pack(table.unpack(v57, 1, v57.n))
															table.move(values, 1, values.n, 2, tbl14)
														end

														childrens[children2] = tbl14
														return arg8, set(v54, Frame(childrens))
													end),
												},
											})
									end),
								},
							})

							local v51 = scope:New("Frame")({
								Name = "Holder",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundColor3 = v45.BgPrimaryHighlight,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
								LayoutOrder = 2,
								Position = UDim2.new(0, 0, 0, 0),
								[children] = {
									fn24(scope, v45.BgTertiary),
									scope:New("UIListLayout")({ SortOrder = Enum.SortOrder.LayoutOrder }),
									v49,
									v50,
								},
							})

							local tbl14 = {
								scope:New("UIListLayout")({
									Padding = UDim.new(0, v46.Layout.MainPadding),
									SortOrder = Enum.SortOrder.LayoutOrder,
								}),
								v48,
								v51,
							}

							local v52 = nil

							if arg.showPagination then
								v52 = scope:New("Frame")({
									Name = "PaginationHolder",
									Size = UDim2.new(1, 0, 0, v46.Sizes.PaginationHeight),
									Position = UDim2.new(0, 0, 0, 5),
									AnchorPoint = Vector2.new(0, 0),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									LayoutOrder = 999,
									Visible = arg.showPagination,
									[children] = {
										scope:New("UIListLayout")({
											FillDirection = Enum.FillDirection.Horizontal,
											HorizontalAlignment = Enum.HorizontalAlignment.Left,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											SortOrder = Enum.SortOrder.LayoutOrder,
											Padding = UDim.new(0, v47.Layout.TextPadding),
										}),
										scope:New("TextButton")({
											Name = "PrevButton",
											Text = "previous",
											LayoutOrder = 1,
											BackgroundColor3 = v45.BgPrimary,
											BorderSizePixel = 0,
											Size = UDim2.fromOffset(
												v46.Sizes.PageButtonWidth,
												v46.Sizes.PageControlHeight
											),
											FontFace = v47.Fonts.Title,
											TextColor3 = v45.FgTertiary,
											TextSize = 14,
											[children] = {
												scope:New("UIStroke")({
													Color = v45.BgTertiary,
													Thickness = 1,
													ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
												}),
											},
											[onEvent("MouseButton1Click")] = arg.onPrevPage,
										}),
										scope:New("TextLabel")({
											Name = "PageInfo",
											LayoutOrder = 2,
											Size = UDim2.fromOffset(
												v46.Sizes.PageInfoWidth,
												v46.Sizes.PageControlHeight
											),
											BackgroundColor3 = v45.BgPrimary,
											BorderSizePixel = 0,
											FontFace = v47.Fonts.Title,
											TextSize = 14,
											Text = scope:Computed(function(arg2)
												return arg2(arg.currentPage) .. "/" .. arg2(arg.totalPages)
											end),
											TextColor3 = v45.AccentPrimary,
											[children] = {
												scope:New("UIStroke")({
													Color = v45.BgTertiary,
													Thickness = 1,
													ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
												}),
											},
										}),
										scope:New("TextButton")({
											Name = "NextButton",
											Text = "next",
											LayoutOrder = 3,
											BackgroundColor3 = v45.BgPrimary,
											BorderSizePixel = 0,
											Size = UDim2.fromOffset(
												v46.Sizes.PageButtonWidth,
												v46.Sizes.PageControlHeight
											),
											FontFace = v47.Fonts.Title,
											TextColor3 = v45.FgTertiary,
											TextSize = 14,
											[children] = {
												scope:New("UIStroke")({
													Color = v45.BgTertiary,
													Thickness = 1,
													ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
												}),
											},
											[onEvent("MouseButton1Click")] = arg.onNextPage,
										}),
									},
								})

								table.insert(tbl14, v52)
							end

							return scope:New("Frame")(fn26({
								Name = "Table",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
							}, { LayoutOrder = arg.layoutOrder or 0 }, { [children] = tbl14 })),
								v52
						end,
					}
				end)()
			)
		end,
		[65] = function()
			local v, instance, v43 = fn23(65)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.utils.insertitem)
					local v45 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local v46 = v43(instance.Parent.shared)
					local children = v45.Children
					local v47 = v43(instance.Parent.Parent.Parent.storage.theme)
					local title = v46.Fonts.Title
					local body = v46.Fonts.Body

					local index = {}
					index.__index = index
					index.__type = "Text"

					index.New = function(arg, arg2, arg3)
						local tbl14 = { Title = nil, Description = nil, Root = nil }
						local v48 = (arg2.Scope or scope):innerScope()
						tbl14.Title = arg3.Title ~= nil and v48:Value(arg3.Title) or nil
						tbl14.Description = arg3.Description ~= nil and v48:Value(arg3.Description) or nil

						tbl14.Render = function(arg4, arg5)
							local root = arg5:New("Frame")({
								Name = "Text",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.new(1, 0, 0, 0),
								[children] = {
									arg5:New("Frame")({
										Name = "TextHolder",
										AutomaticSize = Enum.AutomaticSize.Y,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Size = UDim2.new(1, -80, 1, 0),
										[children] = {
											arg5:Computed(function(arg6, arg7)
												if tbl14.Title ~= nil then
													return arg7:New("TextLabel")({
														Name = "Title",
														FontFace = title,
														Text = arg6(tbl14.Title),
														TextColor3 = v47.FgSecondary,
														TextSize = 15,
														TextXAlignment = Enum.TextXAlignment.Left,
														AutomaticSize = Enum.AutomaticSize.Y,
														BackgroundColor3 = Color3.fromRGB(255, 255, 255),
														BackgroundTransparency = 1,
														BorderColor3 = Color3.fromRGB(0, 0, 0),
														BorderSizePixel = 0,
														Position = UDim2.fromOffset(0, 10),
														Size = UDim2.fromScale(1, 0),
													})
												end

												return nil
											end),
											arg5:New("UIListLayout")({
												Name = "UIListLayout",
												Padding = UDim.new(0, 5),
												VerticalAlignment = Enum.VerticalAlignment.Center,
												SortOrder = Enum.SortOrder.LayoutOrder,
											}),
											arg5:Computed(function(arg6, arg7)
												if tbl14.Description ~= nil then
													return arg7:New("TextLabel")({
														Name = "Description",
														FontFace = body,
														RichText = true,
														Text = arg6(tbl14.Description),
														TextColor3 = v47.FgTertiary,
														TextSize = 15,
														TextWrapped = true,
														TextXAlignment = Enum.TextXAlignment.Left,
														AutomaticSize = Enum.AutomaticSize.Y,
														BackgroundColor3 = Color3.fromRGB(255, 255, 255),
														BackgroundTransparency = 1,
														BorderColor3 = Color3.fromRGB(0, 0, 0),
														BorderSizePixel = 0,
														Position = UDim2.fromOffset(0, 10),
														Size = UDim2.fromScale(1, 0),
														Visible = true,
													})
												end

												return nil
											end),
										},
									}),
								},
							})

							tbl14.Root = root
							return root
						end

						tbl14.SetTitle = function(arg4, arg5)
							do
								tbl14.Title:set(arg5)
							end
						end

						tbl14.SetDescription = function(arg4, arg5)
							tbl14.Description:set(arg5)
						end

						v44(arg2.Container, tbl14)
						return tbl14
					end

					return index
				end)()
			)
		end,
		[66] = function()
			local v, instance, v43 = fn23(66)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent
					local utils = parent.utils
					local v44 = v43(utils.animate)
					local v45 = v43(utils.insertitem)
					local v46 = v43(utils.safecallback)
					local v47 = v43(parent.packages.fusion)
					local v48 = v43(parent.Internal)
					local v49 = v43(parent.utils.controlRegistry)
					local v50 = v43(parent.storage.theme)
					local v51 = v43(instance.Parent.components.checkbox)
					local v52 = v43(instance.Parent.colorpicker)
					local v53 = v43(instance.input)
					local v54 = v43(instance.keybindMenu)
					local v55 = v43(instance.Parent.shared)
					local scope = v48.Scope
					local children = v47.Children
					local onChange = v47.OnChange
					local onEvent = v47.OnEvent
					local peek = v47.peek

					local function fn24() end

					local title = v55.Fonts.Title
					local body = v55.Fonts.Body
					local index = {}
					index.__index = index
					index.__type = "Toggle"

					index.New = function(arg, arg2, arg3, arg4)
						local v56 = (arg2.Scope or scope):innerScope()
						local agentContext = arg2.AgentContext or {}
						local default = arg4.Default or false
						local callback = arg4.Callback or fn24
						local v57 = v56:Value(default)
						local v58 = v56:Value(false)
						local tbl14

						tbl14 = {
							Title = arg4.Title,
							Description = arg4.Description,
							Value = default,
							Callback = callback,
							Type = "Toggle",
							Changed = function() end,
							Keybind = nil,
							Colorpicker = nil,
							Root = nil,
							AgentContext = agentContext,
							_renderKeybind = nil,
							_renderAddons = {},
							SetValue = function(arg5, value)
								tbl14.Value = value
								v57:set(value)
							end,
							GetValue = function()
								return tbl14.Value
							end,
							OnChanged = function(arg5, changed)
								tbl14.Changed = changed
								changed(tbl14.Value)
							end,
							AddKeybind = function(arg5, arg6, arg7)
								local keybind, renderKeybind = v54.create(v56, tbl14, arg6, arg7, v57, arg4)
								tbl14.Keybind = keybind
								tbl14.KeybindMenu = nil
								tbl14._renderKeybind = renderKeybind
								tbl14._renderAddons.Keybind = renderKeybind
								return keybind
							end,
							AddColorpicker = function(arg5, arg6, arg7)
								local tbl15

								if arg7 then
									tbl15 = table.clone(arg7)
								else
									tbl15 = {}
								end

								if tbl15.Title == nil then
									tbl15.Title = (arg4.Title or "Toggle") .. " Color"
								end

								tbl15.LayoutOrder = tbl15.LayoutOrder or 0
								local addon = v52.createAddon({ Scope = v56, AgentContext = agentContext }, arg6, tbl15)
								tbl14.Colorpicker = addon

								tbl14._renderAddons.Colorpicker = function(arg8)
									return addon:Render(arg8)
								end

								return addon
							end,
							Render = function(arg5, arg6)
								local v59 = v44(function(arg7)
									return (arg7(v57) or arg7(v58)) and arg7(v50.FgPrimary) or arg7(v50.FgSecondary)
								end, 40, 1, arg6)

								local v60 = arg6:Value(24)
								local tbl15 = {}

								if tbl14._renderAddons.Keybind then
									table.insert(tbl15, tbl14._renderAddons.Keybind(arg6))
								end

								if tbl14._renderAddons.Colorpicker then
									table.insert(tbl15, tbl14._renderAddons.Colorpicker(arg6))
								end

								table.insert(
									tbl15,
									v51.new({
										Scope = arg6,
										State = v57,
										OnToggle = function(arg7)
											tbl14:SetValue(arg7)
										end,
										Extend = table.freeze({ LayoutOrder = 1 }),
									})
								)

								local Frame = arg6:New("Frame")

								local childrens = {
									Name = arg4.Title or "Toggle",
									Size = UDim2.fromScale(1, 0),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									AutomaticSize = Enum.AutomaticSize.Y,
								}

								local children2 = children
								local tbl16 = {}

								local v61 = v55.AddonsContainer.create({
									scope = arg6,
									padding = 12,
									children = tbl15,
									extend = {
										[onChange("AbsoluteSize")] = function(arg7)
											v60:set(arg7.X)
										end,
									},
								})

								local Frame2 = arg6:New("Frame")

								local childrens2 = {
									Name = "TextHolder",
									Size = arg6:Computed(function(arg7)
										return UDim2.new(1, -(arg7(v60) + 12), 1, 0)
									end),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									AutomaticSize = Enum.AutomaticSize.Y,
								}

								local children3 = children
								local tbl17 = {}

								local v62 = arg6:New("UIListLayout")({
									Padding = UDim.new(0, 5),
									VerticalAlignment = Enum.VerticalAlignment.Center,
									SortOrder = Enum.SortOrder.LayoutOrder,
								})

								local v63 = arg6:New("TextLabel")({
									Name = "Title",
									FontFace = title,
									Text = arg4.Title or "",
									TextColor3 = v59,
									TextSize = 15,
									TextXAlignment = Enum.TextXAlignment.Left,
									Position = UDim2.fromOffset(0, 10),
									Size = UDim2.fromScale(1, 0),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									AutomaticSize = Enum.AutomaticSize.Y,
								})

								local description = arg4.Description
										and arg6:New("TextLabel")({
											Name = "Description",
											FontFace = body,
											RichText = true,
											Text = arg4.Description,
											TextColor3 = v50.FgTertiary,
											TextSize = 15,
											TextWrapped = true,
											TextXAlignment = Enum.TextXAlignment.Left,
											Position = UDim2.fromOffset(0, 10),
											Size = UDim2.fromScale(1, 0),
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											AutomaticSize = Enum.AutomaticSize.Y,
										})
									or nil

								tbl17[1] = v62
								tbl17[2] = v63
								tbl17[3] = description
								childrens2[children3] = tbl17

								childrens2[onEvent("MouseEnter")] = function()
									v58:set(true)
								end

								childrens2[onEvent("MouseLeave")] = function()
									v58:set(false)
								end

								childrens2[onEvent("InputEnded")] = function(arg7)
									if v53.isMouseOrTouch(arg7) then
										tbl14:SetValue(not peek(v57))
									end
								end

								local v64 = table.pack(Frame2(childrens2))
								tbl16[1] = v61

								do
									local values = table.pack(table.unpack(v64, 1, v64.n))
									table.move(values, 1, values.n, 2, tbl16)
								end

								childrens[children2] = tbl16
								local root = Frame(childrens)
								tbl14.Root = root
								return root
							end,
						}

						v56:Observer(v57):onChange(function()
							local value = peek(v57)
							tbl14.Value = value

							v46(function()
								tbl14.Callback(value)
								tbl14.Changed(value)
							end)

							v49.notifyControlChanged(arg3)
						end)

						v45(arg2.Container, tbl14)

						v49.registerControl({
							optionKey = arg3,
							element = tbl14,
							type = tbl14.Type,
							title = arg4.Title,
							description = arg4.Description,
							context = arg2.AgentContext,
							defaultValue = default,
							risk = "write",
							getValue = function()
								return tbl14:GetValue()
							end,
							setValue = function(arg5)
								tbl14:SetValue(arg5)
							end,
						})

						return tbl14
					end

					return index
				end)()
			)
		end,
		[67] = function()
			local v, instance, v43 = fn23(67)

			return (function()
				local parent = instance.Parent.Parent.Parent.Parent
				local userInputService = v43(parent.utils.services).UserInputService

				return table.freeze({
					isMouseOrTouch = function(input)
						return input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
					end,
					isKeyboard = function(input)
						return input.UserInputType == Enum.UserInputType.Keyboard
					end,
					getKeyFromInput = v43(parent.packages.keybindDispatcher).normalizeInputToKey,
					isKeyHeld = function(arg)
						if arg == "None" or arg == ". . ." then
							return false
						end

						if arg == "MouseLeft" then
							return userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						end

						if arg == "MouseRight" then
							return userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
						end

						local ok, result = pcall(function()
							return userInputService:IsKeyDown(Enum.KeyCode[arg])
						end)

						return ok and result or false
					end,
					isTextBoxFocused = function()
						return userInputService:GetFocusedTextBox() ~= nil
					end,
				})
			end)()
		end,
		[68] = function()
			local v, instance, v43 = fn23(68)

			return (function()
				local parent = instance.Parent.Parent.Parent.Parent
				local v44 = v43(parent.utils.services)
				local guiService = v44.GuiService
				local userInputService = v44.UserInputService
				local packages = parent.packages
				local v45 = v43(packages.fusion)
				local v46 = v43(parent.Internal)
				local v47 = v43(packages.states)
				local v48 = v43(packages.keybindDispatcher)
				local utils = parent.utils
				local v49 = v43(utils.animate)
				local v50 = v43(utils.safecallback)
				local v51 = v43(utils.images)
				local v52 = v43(utils.controlRegistry)
				local v53 = v43(utils.pendingTasks)
				local v54 = v43(parent.storage.theme)
				local v55 = v43(instance.Parent.input)
				local scope = v46.Scope
				local children = v45.Children
				local onEvent = v45.OnEvent
				local onChange = v45.OnChange
				local peek = v45.peek

				local function fn24() end

				local title = v43(instance.Parent.Parent.shared).Fonts.Title
				local vector2 = Vector2.new(0.5, 0.5)
				local tbl14 = { BackgroundTransparency = 1, BorderSizePixel = 0 }
				local tbl15 = { AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0) }
				local tbl16 = { ApplyStrokeMode = Enum.ApplyStrokeMode.Border }

				local function fn25(...)
					local v56 = table.pack(...)
					local tbl17 = {}

					for i = 1, select("#", ...) do
						local value = select(i, table.unpack(v56, 1, v56.n))

						if value then
							for k, v57 in pairs(value) do
								tbl17[k] = v57
							end
						end
					end

					return tbl17
				end

				local function fn26(arg)
					return arg:New("UICorner")({ CornerRadius = UDim.new(0, 4) })
				end

				local function fn27(arg, bgTertiary, arg2)
					return arg:New("UIStroke")(fn25({ Color = bgTertiary, Thickness = 1, Transparency = 0 }, arg2))
				end

				return table.freeze({
					create = function(arg, arg2, arg3, arg4, arg5, arg6)
						local v56 = (arg or scope):innerScope()
						local default = arg4.Default or ". . ."
						local mode2 = arg4.Mode or arg4.Type or "Toggle"

						local keybind = {
							Value = default,
							Toggled = arg2.Value,
							Mode = mode2,
							Type = "Keybind",
							Callback = arg4.Callback or fn24,
							Changed = function() end,
							Clicked = function() end,
							SyncState = arg4.SyncState or false,
						}

						arg2.Keybind = keybind
						v48.addKeybind(arg3, keybind.Value, arg6.Title or "Unknown Feature")

						v56:Observer(arg5):onChange(function()
							keybind.Toggled = peek(arg5)
						end)

						local modeState = v56:Value(mode2)
						local pickingState = v56:Value(false)
						keybind.ModeState = modeState
						keybind.PickingState = pickingState
						keybind._view = nil

						local function getSettingsIcon(arg7)
							local v57 = (arg7 or scope):innerScope()
							local v58 = v57:Value(nil)
							local v59 = v57:Value(false)
							local v60 = v57:Value(nil)
							local v61 = v57:Value(false)
							local v62 = nil
							local guiObject = nil
							local v63 = nil

							local v64 = v49(function(arg8)
								return arg8(v61) and arg8(v54.FgSecondary) or arg8(v54.FgTertiary)
							end, 40, 1, v57)

							local v65 = v49(function(arg8)
								return arg8(modeState) == "Toggle" and arg8(v54.FgPrimary) or arg8(v54.FgSecondary)
							end, 40, 1, v57)

							local v66 = v49(function(arg8)
								return arg8(modeState) == "Toggle" and arg8(v54.AccentPrimary)
									or arg8(v54.BgPrimaryHighlight)
							end, 40, 1, v57)

							local v67 = v49(function(arg8)
								return arg8(modeState) == "Hold" and arg8(v54.FgPrimary) or arg8(v54.FgSecondary)
							end, 40, 1, v57)

							local v68 = v49(function(arg8)
								return arg8(modeState) == "Hold" and arg8(v54.AccentPrimary)
									or arg8(v54.BgPrimaryHighlight)
							end, 40, 1, v57)

							local function fn28()
								local guiObject2 = peek(v60)
								if not guiObject2 or not guiObject then
									return
								end
								local absolutePosition = guiObject2.AbsolutePosition
								guiObject.Position = UDim2.fromOffset(
									absolutePosition.X,
									absolutePosition.Y + guiObject2.AbsoluteSize.Y + 10 + guiService:GetGuiInset().Y
								)
							end

							local function fn29()
								if not v62 then
									v59:set(false)
									return
								end

								if not peek(v59) then
									return
								end
								v59:set(false)
								v53.cancel(v63)
								local v69 = v62

								v63 = v53.delay(0.14, function()
									if v62 ~= v69 or peek(v59) then
										return
									end
									v45.doCleanup(v69)
									v62 = nil
									guiObject = nil
									v63 = nil
								end)

								if not v63 then
									v45.doCleanup(v69)
									v62 = nil
									guiObject = nil
								end
							end

							local function fn30()
								local v69 = peek(v58)
								if not v69 then
									return
								end
								pickingState:set(true)
								v69.Text = "..."
								local v70 = v57:innerScope()

								v53.delay(0.2, function()
									local flag19 = false

									v70:insert(userInputService.InputBegan:Connect(function(input)
										if flag19 then
											return
										end

										if v55.isKeyboard(input) and input.KeyCode == Enum.KeyCode.Escape then
											pickingState:set(false)
											v69.Text = keybind.Value
											v45.doCleanup(v70)
											return
										end

										local keyFromInput = v55.getKeyFromInput(input)
										if not keyFromInput then
											return
										end
										flag19 = true

										v70:insert(userInputService.InputEnded:Connect(function(input2)
											if v55.getKeyFromInput(input2) == keyFromInput then
												local value = keybind.Value
												pickingState:set(false)
												v69.Text = keyFromInput
												keybind.Value = keyFromInput
												v48.updateKeybind(arg3, keyFromInput, arg6.Title or "Unknown Feature")

												v50(function()
													keybind.Changed(input.KeyCode or input.UserInputType)
												end)

												if keyFromInput ~= value then
													v52.notifyControlChanged(arg3)
												end

												v45.doCleanup(v70)
											end
										end))
									end))
								end)
							end

							local function fn31()
								if v62 then
									if not peek(v59) then
										v53.cancel(v63)
										v63 = nil
										v59:set(true)
										fn28()
									end

									return
								end

								local v69 = peek(v47.Library)
								if not v69 or not v69.GUI then
									return
								end
								v62 = v57:innerScope()
								local v70 = v62
								local v71 = v62:Value(0)

								local v72 = v70:Tween(
									v70:Computed(function(arg8)
										return arg8(v59) and 0 or 1
									end),
									TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
								)

								local Frame = v70:New("Frame")

								local childrens = {
									Name = "KeybindMenu",
									BackgroundColor3 = v54.BgPrimaryHighlight,
									BackgroundTransparency = v72,
									BorderSizePixel = 0,
									Size = v70:Computed(function(arg8)
										return UDim2.fromOffset(235, arg8(v71))
									end),
									Visible = true,
									Parent = v69.GUI,
									ZIndex = 9999,
									Interactable = v59,
									Active = v59,
								}

								local children2 = children
								local v73 = fn26(v70)
								local v74 = fn27(v70, v54.BgTertiary, { Transparency = v72 })
								local Frame2 = v70:New("Frame")

								local childrens2 = {
									Name = "Holder",
									Position = v70:Computed(function(arg8)
										return UDim2.fromOffset(0, 4 * arg8(v72))
									end),
									Size = UDim2.fromScale(1, 0),
								}

								local children3 = children

								local v75 = v70:New("UIListLayout")({
									Padding = UDim.new(0, 5),
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									SortOrder = Enum.SortOrder.LayoutOrder,
								})

								local Frame3 = v70:New("Frame")

								local childrens3 = {
									Name = "KeybindSection",
									BackgroundColor3 = v54.BgPrimaryHighlight,
									BorderSizePixel = 0,
									Size = UDim2.new(1, -10, 0, 0),
								}

								local children4 = children
								local v76 = fn26(v70)
								local v77 = fn27(v70, v54.BgTertiary)
								local Frame4 = v70:New("Frame")
								local childrens4 = { Name = "Picker", Size = UDim2.fromScale(1, 0) }
								local children5 = children

								local v78 = v58:set(v70:New("TextButton")(fn25(tbl14, {
									Name = "KeyDisplay",
									FontFace = title,
									Text = keybind.Value,
									TextColor3 = v54.FgTertiary,
									TextSize = 14,
									AnchorPoint = Vector2.new(1, 0.5),
									AutomaticSize = Enum.AutomaticSize.X,
									Position = UDim2.new(1, -10, 0.5, 0),
									Size = UDim2.fromOffset(0, 25),
									[onEvent("InputBegan")] = function(arg8)
										if v55.isMouseOrTouch(arg8) then
											fn30()
										end
									end,
								})))

								local Frame5 = v70:New("Frame")
								local childrens5 = { Name = "Label", AutomaticSize = Enum.AutomaticSize.XY }
								local children6 = children
								local v79 = v51
								local track = v79.Track

								local v80 = table.pack(v70:New("ImageLabel")(fn25(tbl14, {
									Image = v51.KeyboardIcon,
									ImageColor3 = v54.FgTertiary,
									LayoutOrder = -1,
									Size = UDim2.fromOffset(16, 16),
								})))

								v80.n = 3 + v80.n - 1
								table.move(v80, 1, v80.n, 3, v80)
								v80[1] = v79
								v80[2] = "KeyboardIcon"

								childrens5[children6] = {
									track(table.unpack(v80, 1, v80.n)),
									v70:New("TextLabel")(fn25(tbl14, {
										FontFace = title,
										Text = "Keybind",
										TextColor3 = v54.FgSecondary,
										TextSize = 15,
										TextXAlignment = Enum.TextXAlignment.Left,
										AutomaticSize = Enum.AutomaticSize.XY,
										Position = UDim2.fromOffset(10, 0),
									})),
									v70:New("UIListLayout")({
										Padding = UDim.new(0, 7),
										FillDirection = Enum.FillDirection.Horizontal,
										SortOrder = Enum.SortOrder.LayoutOrder,
										VerticalAlignment = Enum.VerticalAlignment.Center,
									}),
									v70:New("UIPadding")({ PaddingLeft = UDim.new(0, 8) }),
								}

								childrens4[children5] = { v78, Frame5(fn25(tbl14, childrens5)) }
								local v81 = Frame4(fn25(tbl14, tbl15, childrens4))
								local Frame6 = v70:New("Frame")
								local childrens6 = { Name = "ModeButtons", Size = UDim2.new(1, 0, 0, 30) }
								local children7 = children

								local v82 = v70:New("UIListLayout")({
									Padding = UDim.new(0, 4),
									FillDirection = Enum.FillDirection.Horizontal,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									SortOrder = Enum.SortOrder.LayoutOrder,
									VerticalAlignment = Enum.VerticalAlignment.Center,
								})

								local bgTertiary = v54.BgTertiary

								local v83 = v70:New("TextButton")({
									Name = "ToggleMode",
									FontFace = title,
									Text = "Toggle",
									TextColor3 = v65,
									TextSize = 14,
									AutoButtonColor = false,
									BackgroundColor3 = v66,
									BackgroundTransparency = 0,
									BorderSizePixel = 0,
									Size = UDim2.fromOffset(106, 25),
									[children] = { fn26(v70), fn27(v70, bgTertiary, tbl16) },
									[onEvent("MouseButton1Click")] = function()
										local flag19 = keybind.Mode ~= "Toggle"
										keybind.Mode = "Toggle"
										modeState:set("Toggle")

										if flag19 then
											v52.notifyControlChanged(arg3)
										end
									end,
								})

								local bgTertiary2 = v54.BgTertiary

								childrens6[children7] = {
									v82,
									v83,
									v70:New("TextButton")({
										Name = "HoldMode",
										FontFace = title,
										Text = "Hold",
										TextColor3 = v67,
										TextSize = 14,
										AutoButtonColor = false,
										BackgroundColor3 = v68,
										BorderSizePixel = 0,
										Size = UDim2.fromOffset(106, 25),
										[children] = { fn26(v70), fn27(v70, bgTertiary2, tbl16) },
										[onEvent("MouseButton1Click")] = function()
											local flag19 = keybind.Mode ~= "Hold"
											keybind.Mode = "Hold"
											modeState:set("Hold")

											if flag19 then
												v52.notifyControlChanged(arg3)
											end
										end,
									}),
								}

								childrens3[children4] = {
									v76,
									v77,
									v81,
									Frame6(fn25(tbl14, childrens6)),
									v70:New("UIListLayout")({
										Padding = UDim.new(0, 2),
										SortOrder = Enum.SortOrder.LayoutOrder,
									}),
									v70:New("UIPadding")({
										PaddingBottom = UDim.new(0, 10),
										PaddingTop = UDim.new(0, 10),
									}),
								}

								childrens2[children3] = {
									v75,
									Frame3(fn25(tbl15, childrens3)),
									v70:New("UIPadding")({
										PaddingBottom = UDim.new(0, 5),
										PaddingTop = UDim.new(0, 5),
									}),
								}

								childrens2[onChange("AbsoluteSize")] = function(arg8)
									v71:set(arg8.Y)
								end

								childrens[children2] = {
									v73,
									v74,
									Frame2(fn25(tbl14, tbl15, childrens2)),
									v70:New("ImageLabel")(fn25(tbl14, {
										Name = "Shadow",
										Image = v51.Shadow,
										ImageColor3 = v54.BgPrimary,
										ImageTransparency = v70:Computed(function(arg8)
											return 0.5 + 0.5 * arg8(v72)
										end),
										ScaleType = Enum.ScaleType.Slice,
										SliceCenter = Rect.new(45, 45, 45, 45),
										SliceScale = 1.2,
										AnchorPoint = vector2,
										Position = UDim2.fromScale(0.5, 0.5),
										Size = UDim2.new(1, 75, 1, 75),
										ZIndex = -1,
									})),
								}

								guiObject = Frame(childrens)
								local instance2 = peek(v60)

								if instance2 then
									v70:insert(instance2:GetPropertyChangedSignal("AbsolutePosition"):Connect(fn28))
								end

								fn28()

								v70:insert(userInputService.InputBegan:Connect(function(input)
									if not v55.isMouseOrTouch(input) then
										return
									end

									if peek(pickingState) then
										return
									end

									if not guiObject then
										return
									end
									local absolutePosition = guiObject.AbsolutePosition
									local absoluteSize = guiObject.AbsoluteSize
									local mouseLocation = userInputService:GetMouseLocation()

									if
										mouseLocation.X < absolutePosition.X
										or mouseLocation.X > absolutePosition.X + absoluteSize.X
										or mouseLocation.Y < absolutePosition.Y - 20
										or mouseLocation.Y > absolutePosition.Y + absoluteSize.Y + 20
									then
										fn29()
									end
								end))

								v59:set(true)
							end

							local SettingsIcon = v51:Track(
								"SettingsIcon",
								v57:New("ImageButton")(fn25(tbl14, {
									Name = "SettingsButton",
									Image = v51.SettingsIcon,
									ImageColor3 = v64,
									Size = UDim2.fromOffset(16, 16),
									LayoutOrder = -1,
									[onEvent("MouseEnter")] = function()
										v61:set(true)
									end,
									[onEvent("MouseLeave")] = function()
										v61:set(false)
									end,
									[onEvent("InputEnded")] = function(arg8)
										if v55.isMouseOrTouch(arg8) then
											if peek(v59) then
												fn29()
											else
												fn31()
											end
										end
									end,
								}))
							)

							v60:set(SettingsIcon)

							v57:insert(function()
								v53.cancel(v63)
								v63 = nil
								v62 = nil
								guiObject = nil
							end)

							keybind._view = { display = v58, closePopup = fn29 }

							v57:insert(function()
								keybind._view = nil
							end)

							return SettingsIcon
						end

						keybind.GetState = function()
							if v55.isTextBoxFocused() and keybind.Mode ~= "Always" then
								return false
							end

							if keybind.Mode == "Always" then
								return true
							end

							if keybind.Mode == "Hold" then
								return v55.isKeyHeld(keybind.Value)
							end
							return keybind.Toggled
						end

						keybind.SetValue = function(arg7, text, mode3)
							text = text or keybind.Value
							mode3 = mode3 or keybind.Mode

							if keybind._view and keybind._view.display then
								local v57 = peek(keybind._view.display)

								if v57 then
									v57.Text = text or ". . ."
								end
							end

							keybind.Value = text
							keybind.Mode = mode3
							modeState:set(mode3)
							v48.updateKeybind(arg3, text, arg6.Title or "Unknown Feature")
						end

						keybind.OnClick = function(arg7, clicked)
							keybind.Clicked = clicked
						end

						keybind.OnChanged = function(arg7, changed)
							keybind.Changed = changed
							changed(keybind.Value)
						end

						keybind.DoClick = function()
							v50(function()
								keybind.Callback(keybind.Toggled)
							end)

							v50(function()
								keybind.Clicked(keybind.Toggled)
							end)
						end

						local function fn28(arg7)
							local v57 = peek(v47.ActiveKeybinds)
							local v58 = table.clone(v57)
							v58[arg3] = arg7 or nil
							v47.ActiveKeybinds:set(v58)
						end

						keybind.Destroy = function()
							if keybind._view and keybind._view.closePopup then
								keybind._view.closePopup()
							end

							fn28(false)
							v48.unregisterKeybindHandler(arg3)
							v48.removeKeybind(arg3)
							v52.unregisterControl(arg3)
						end

						v48.registerKeybindHandler(arg3, {
							onInputBegan = function()
								if peek(pickingState) then
									return
								end

								if keybind.Mode == "Toggle" then
									keybind.Toggled = not keybind.Toggled
									fn28(keybind.Toggled)

									if arg4.SyncState then
										arg2:SetValue(keybind.Toggled)
									end

									keybind:DoClick()
								elseif keybind.Mode == "Hold" then
									fn28(true)

									if arg4.SyncState then
										arg2:SetValue(true)
									end

									keybind:DoClick()
								end
							end,
							onInputEnded = function()
								if peek(pickingState) or keybind.Mode ~= "Hold" then
									return
								end
								fn28(false)

								if arg4.SyncState then
									arg2:SetValue(false)
								end

								keybind:DoClick()
							end,
						})

						v52.registerControl({
							optionKey = arg3,
							element = keybind,
							type = "Keybind",
							title = arg6.Title or "Unknown Feature",
							description = "Keybind for " .. (arg6.Title or "this toggle"),
							context = arg2.AgentContext or {},
							defaultValue = { key = keybind.Value, mode = keybind.Mode },
							risk = "write",
							getValue = function()
								return { key = keybind.Value, mode = keybind.Mode, toggled = keybind.Toggled }
							end,
							setValue = function(arg7)
								if type(arg7) == "table" then
									keybind:SetValue(arg7.key, arg7.mode)
									return
								end
								keybind:SetValue(arg7)
							end,
						})

						return keybind, getSettingsIcon
					end,
				})
			end)()
		end,
		[70] = function()
			local v, instance, v43 = fn23(70)

			return (
				(function()
					local utils = instance.Parent.Parent.Parent.utils
					local v44 = v43(utils.animate)
					local v45 = v43(utils.insertitem)
					local v46 = v43(utils.controlRegistry)
					local v47 = v43(instance.Parent.Parent.Parent.Internal)
					local packages = instance.Parent.Parent.Parent.packages
					local v48 = v43(packages.fusion)
					local v49 = v43(packages.states)
					local scope = v47.Scope
					local children = v48.Children
					local peek = v48.peek
					local onEvent = v48.OnEvent
					local onChange = v48.OnChange
					local v50 = v43(instance.Parent.Parent.Parent.storage.theme)
					local v51 = v43(instance.Parent.Parent.Parent.utils.images)

					return function(arg)
						local v52 = (arg.Scope or scope):innerScope()

						local tbl14 = {
							Tabs = v52:Value(table.freeze({})),
							Collapsed = v52:Value(false),
							ExpandedHeight = v52:Value(0),
							Hovering = v52:Value(false),
							Scope = v52,
						}

						local v53 = v52:Value()
						local Frame = v52:New("Frame")

						local childrens = {
							Name = "Section",
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							LayoutOrder = arg.Order,
							Size = v44(function(arg2)
								return arg2(tbl14.Collapsed) and UDim2.new(1, 0, 0, 40)
									or UDim2.new(1, 0, 0, arg2(tbl14.ExpandedHeight) + 45)
							end, 50, 1, v52),
							ClipsDescendants = true,
						}

						local children2 = children
						local tbl15 = {}
						local ImageButton = v52:New("ImageButton")

						local childrens2 = {
							Name = "Title",
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 40),
							[onEvent("MouseEnter")] = function()
								tbl14.Hovering:set(true)
							end,
							[onEvent("MouseLeave")] = function()
								tbl14.Hovering:set(false)
							end,
							[onEvent("Activated")] = function()
								tbl14.Collapsed:set(not peek(tbl14.Collapsed))
							end,
						}

						local children3 = children
						local tbl16 = {}

						local v54 = v52:New("TextLabel")({
							Name = "TextLabel",
							FontFace = Font.new(
								"rbxassetid://12187365364",
								Enum.FontWeight.Medium,
								Enum.FontStyle.Normal
							),
							Text = arg.Title,
							TextColor3 = v44(function(arg2)
								if arg2(tbl14.Hovering) then
									return arg2(v50.FgPrimary)
								end
								return arg2(v50.FgSecondary)
							end, 25, 1, v52),
							TextSize = 17,
							TextXAlignment = Enum.TextXAlignment.Left,
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromOffset(14, 0),
							Size = UDim2.fromScale(0, 1),
						})

						local v55 = v51
						local track = v55.Track
						local ImageButton2 = v52:New("ImageButton")

						local tbl17 = {
							Name = "Collapse",
							Image = v51.ChevronDownIcon,
							ImageColor3 = v44(function(arg2)
								if arg2(tbl14.Hovering) then
									return arg2(v50.FgSecondary)
								end
								return arg2(v50.FgTertiary)
							end, 25, 1, v52),
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.new(1, -15, 0.5, -1),
							Size = UDim2.fromOffset(20, 20),
							Rotation = v44(function(arg2)
								if arg2(tbl14.Collapsed) then
									return 180
								end
								return 0
							end, 25, 1, v52),
							ImageTransparency = arg.IsTablistCollapsed and v44(function(arg2)
								return arg2(arg.IsTablistCollapsed) and 1 or 0
							end, 55, 1, v52) or 0,
						}

						local v56 = table.pack(track(v55, "ChevronDownIcon", ImageButton2(tbl17)))
						tbl16[1] = v54

						do
							local values = table.pack(table.unpack(v56, 1, v56.n))
							table.move(values, 1, values.n, 2, tbl16)
						end

						childrens2[children3] = tbl16
						local v57 = ImageButton(childrens2)
						local v58 = v52:New("UIListLayout")({
							Name = "UIListLayout",
							Padding = UDim.new(0, 0),
							SortOrder = Enum.SortOrder.LayoutOrder,
						})
						local forPairs = v52.ForPairs
						local tabs = tbl14.Tabs

						local v59 = table.pack(v52:New("Frame")({
							Name = "Holder",
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 0),
							[children] = {
								v53:set(v52:New("UIListLayout")({
									Name = "UIListLayout",
									Padding = UDim.new(0, 13),
									SortOrder = Enum.SortOrder.LayoutOrder,
									[onChange("AbsoluteContentSize")] = function(arg2)
										tbl14.ExpandedHeight:set(arg2.Y)
									end,
								})),
								forPairs(v52, tabs, function(arg2, arg3, arg4, arg5)
									return arg4, arg5
								end),
							},
						}))

						tbl15[1] = v57
						tbl15[2] = v58

						do
							local values = table.pack(table.unpack(v59, 1, v59.n))
							table.move(values, 1, values.n, 3, tbl15)
						end

						childrens[children2] = tbl15
						tbl14.Root = Frame(childrens)

						tbl14.AddTab = function(arg2, arg3)
							local v60 = v43(instance.Parent.tab)({
								Title = arg3.Title,
								Scope = v52,
								IsCompact = arg.IsCompact,
								OnSelected = arg.OnTabSelected,
							})

							local v61 = v46.registerTab({
								title = arg3.Title,
								order = #peek(tbl14.Tabs),
								windowTitle = tbl14.AgentContext and tbl14.AgentContext.windowTitle or "",
								categoryId = tbl14.AgentContext and tbl14.AgentContext.categoryId or nil,
								categoryTitle = tbl14.AgentContext and tbl14.AgentContext.categoryTitle or "",
							})

							v60.AgentContext = {
								windowTitle = tbl14.AgentContext and tbl14.AgentContext.windowTitle or "",
								categoryId = tbl14.AgentContext and tbl14.AgentContext.categoryId or nil,
								categoryTitle = tbl14.AgentContext and tbl14.AgentContext.categoryTitle or "",
								tabId = v61.id,
								tabTitle = v61.title,
							}

							v45(tbl14.Tabs, v60.Root)

							if not peek(v49.HasSelected) then
								v49.HasSelected:set(true)
								v60.Selected:set(true)
							end

							return v60
						end

						tbl14.ExpandedHeight:set(peek(v53).AbsoluteContentSize.Y)
						return tbl14
					end
				end)()
			)
		end,
		[71] = function()
			local v, instance, v43 = fn23(71)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.Internal)
					local utils = instance.Parent.Parent.Parent.utils
					local v45 = v43(utils.animate)
					local v46 = v43(utils.color3)
					local v47 = v43(utils.insertitem)
					local v48 = v43(utils.removeitem)
					local v49 = v43(utils.safecallback)
					local v50 = v43(utils.services)
					local userInputService = v50.UserInputService
					local currentCamera = v50.Workspace.CurrentCamera
					local v51 = v43(utils.pendingTasks)
					local v52 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local children = v52.Children
					local onEvent = v52.OnEvent
					local scope = v44.Scope
					local peek = v52.peek
					local v53 = v43(instance.Parent.Parent.Parent.storage.theme)
					local v54 = v43(instance.Parent.Parent.Parent.utils.images)
					local tbl14 = { Window = nil, Scope = nil }
					local tbl15 = {}

					tbl14.init = function(arg, window, scope2)
						tbl14.Window = window
						tbl14.Scope = scope2
					end

					local function fn24(style, arg, arg2, arg3)
						local style2 = string.lower(style or "default")

						if style2 == "primary" then
							local v55 = arg(v53.AccentPrimary)
							local v56 = v46.darkenRGB(v55, 15)
							return arg(v53.FgPrimary), arg(arg2) and not arg(arg3) and v56 or v55
						end

						if style2 == "danger" then
							local v55 = arg(v53.AccentDestructive)
							local v56 = v46.darkenRGB(v55, 12)
							return arg(v53.FgPrimary), arg(arg2) and not arg(arg3) and v56 or v55
						end

						if style2 == "warning" then
							local v55 = arg(v53.AccentCaution)
							local v56 = v46.darkenRGB(v55, 12)
							return arg(v53.BgPrimary), arg(arg2) and not arg(arg3) and v56 or v55
						end

						local v55 = arg(v53.BgPrimary)
						local v56 = v46.darkenRGB(v55, 5)
						return arg(v53.FgTertiary), arg(arg2) and not arg(arg3) and v56 or v55
					end

					tbl14.Create = function(arg, arg2)
						assert(tbl14.Window ~= nil, "Dialog module must be initialized before creating a dialog")
						local v55 = (tbl14.Scope or scope):innerScope()
						local x = math.max(320, tonumber(arg2 and arg2.Width) or 500)
						local dismissable = arg2 and arg2.Dismissable ~= nil and arg2.Dismissable or true
						local closeOnOverlayClick = arg2
								and arg2.CloseOnOverlayClick ~= nil
								and arg2.CloseOnOverlayClick
							or true
						local closeOnEsc = arg2 and arg2.CloseOnEsc ~= nil and arg2.CloseOnEsc or true
						local confirmOnEnter = arg2 and arg2.ConfirmOnEnter ~= nil and arg2.ConfirmOnEnter or true
						local y = math.min(
							tonumber(arg2 and arg2.MaxHeight) or math.floor(currentCamera.ViewportSize.Y * 0.85),
							math.max(120, tbl14.Window.AbsoluteSize.Y - 24)
						)
						local variant = string.lower(arg2 and arg2.Variant or "")

						local tbl16 = {
							Opened = v55:Value(false),
							Buttons = v55:Value({}),
							Connection = nil,
							KeyboardConnection = nil,
							DefaultAction = nil,
							Content = v55:Value(nil),
						}

						tbl16.Title = v55:Value(arg2 and arg2.Title or "")
						tbl16.Description = v55:Value(arg2 and arg2.Description or "")
						tbl16.closeTask = nil
						tbl16.destroyed = false
						local v56 = v55:Value()

						local v57 = v55:Computed(function(arg3)
							if variant == "danger" then
								return arg3(v53.AccentDestructive)
							end

							if variant == "warning" then
								return arg3(v53.AccentCaution)
							end

							if variant == "success" then
								return arg3(v53.Success)
							end

							if variant == "info" then
								return arg3(v53.AccentPrimary)
							end
							return arg3(v53.BgTertiary)
						end)

						tbl16.Destroy = function(arg3)
							if arg3.destroyed then
								return
							end
							arg3.destroyed = true
							v55:doCleanup()
						end

						tbl16.Close = function(arg3)
							if arg3.destroyed or arg3.closeTask then
								return
							end
							arg3.Opened:set(false)

							arg3.closeTask = v51.delay(0.22, function()
								arg3.closeTask = nil
								arg3:Destroy()
							end)
						end

						local v58 = v55:Tween(
							v55:Computed(function(arg3)
								return arg3(tbl16.Opened) and 1 or 0
							end),
							TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						)

						local TextButton = v55:New("TextButton")

						local childrens = {
							Name = "Modal",
							AutoButtonColor = false,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(0, 0, 0),
							BackgroundTransparency = v55:Computed(function(arg3)
								return 1 - 0.55 * math.clamp(arg3(v58), 0, 1)
							end),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(1, 1),
							ZIndex = 100,
							Parent = tbl14.Window,
						}

						local children2 = children
						local set = v56.set
						local CanvasGroup = v55:New("CanvasGroup")

						local childrens2 = {
							Name = "Canvas",
							AnchorPoint = Vector2.new(0.5, 0.5),
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundColor3 = v53.BgPrimaryHighlight,
							GroupTransparency = v55:Computed(function(arg3)
								return 1 - math.clamp(arg3(v58), 0, 1)
							end),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.new(1, -24, 0, 0),
						}

						local v59 = v54
						local track = v59.Track

						childrens2[children] = {
							v55:New("UISizeConstraint")({ MaxSize = Vector2.new(x, y) }),
							v55:New("UICorner")({ CornerRadius = UDim.new(0, 8) }),
							v55:New("UIStroke")({
								Color = v53.BgTertiary,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Transparency = v55:Computed(function(arg3)
									return 1 - math.clamp(arg3(v58), 0, 1)
								end),
							}),
							v55:New("Frame")({
								Name = "Accent",
								BackgroundColor3 = v57,
								BorderSizePixel = 0,
								Size = UDim2.new(1, 0, 0, 3),
							}),
							v55:New("Frame")({
								Name = "Holder",
								BackgroundTransparency = 1,
								Size = UDim2.fromScale(1, 1),
								[children] = {
									v55:New("UIListLayout")({
										Padding = UDim.new(0, 12),
										SortOrder = Enum.SortOrder.LayoutOrder,
									}),
									v55:New("Frame")({
										Name = "Header",
										LayoutOrder = 1,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 44),
										[children] = {
											v55:New("UIPadding")({
												PaddingLeft = UDim.new(0, 20),
												PaddingRight = UDim.new(0, 12),
												PaddingTop = UDim.new(0, 16),
											}),
											v55:New("TextLabel")({
												Name = "Title",
												BackgroundTransparency = 1,
												FontFace = Font.new(
													"rbxassetid://12187365364",
													Enum.FontWeight.Medium,
													Enum.FontStyle.Normal
												),
												Text = tbl16.Title,
												TextColor3 = v53.FgSecondary,
												TextSize = 17,
												TextXAlignment = Enum.TextXAlignment.Left,
												AutomaticSize = Enum.AutomaticSize.XY,
												TextTransparency = v45(function(arg3)
													return arg3(tbl16.Opened) and 0 or 1
												end, 40, 1, v55),
											}),
											track(
												v59,
												"CloseIcon",
												v55:New("ImageButton")({
													Name = "Close",
													AnchorPoint = Vector2.new(1, 0),
													BackgroundTransparency = 1,
													Position = UDim2.fromScale(1, 0),
													Size = UDim2.fromOffset(22, 22),
													Image = v54.CloseIcon,
													ImageColor3 = v53.FgTertiary,
													ImageTransparency = v45(function(arg3)
														return arg3(tbl16.Opened) and 0 or 1
													end, 40, 1, v55),
													[onEvent("Activated")] = function()
														if dismissable then
															tbl16:Close()
														end
													end,
												})
											),
										},
									}),
									v55:New("Frame")({
										Name = "Body",
										LayoutOrder = 2,
										BackgroundTransparency = 1,
										Size = UDim2.fromScale(1, 0),
										AutomaticSize = Enum.AutomaticSize.Y,
										[children] = {
											v55:New("UIPadding")({
												PaddingLeft = UDim.new(0, 20),
												PaddingRight = UDim.new(0, 20),
											}),
											v55:New("TextLabel")({
												Name = "Description",
												BackgroundTransparency = 1,
												FontFace = Font.new("rbxassetid://12187365364"),
												RichText = true,
												Text = tbl16.Description,
												TextColor3 = v53.FgTertiary,
												TextSize = 15,
												TextWrapped = true,
												TextXAlignment = Enum.TextXAlignment.Left,
												AutomaticSize = Enum.AutomaticSize.Y,
												Size = UDim2.fromScale(1, 0),
												TextTransparency = v45(function(arg3)
													return arg3(tbl16.Opened) and 0 or 1
												end, 40, 1, v55),
											}),
											v55:New("Frame")({
												Name = "CustomContent",
												BackgroundTransparency = 1,
												Size = UDim2.fromScale(1, 0),
												AutomaticSize = Enum.AutomaticSize.Y,
												[children] = tbl16.Content,
											}),
										},
									}),
									v55:New("Frame")({
										Name = "Footer",
										LayoutOrder = 3,
										AnchorPoint = Vector2.new(0, 1),
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 48),
										[children] = {
											v55:New("Frame")({
												Name = "Separator",
												BackgroundColor3 = v53.BgTertiary,
												BackgroundTransparency = v45(function(arg3)
													return arg3(tbl16.Opened) and 0 or 1
												end, 40, 1, v55),
												BorderSizePixel = 0,
												Position = UDim2.fromOffset(0, 0),
												Size = UDim2.new(1, 0, 0, 1),
											}),
											v55:New("Frame")({
												Name = "ButtonRow",
												BackgroundTransparency = 1,
												Size = UDim2.fromScale(1, 1),
												[children] = {
													v55:New("UIListLayout")({
														FillDirection = Enum.FillDirection.Horizontal,
														HorizontalAlignment = Enum.HorizontalAlignment.Right,
														VerticalAlignment = Enum.VerticalAlignment.Center,
														Padding = UDim.new(0, 6),
													}),
													v55:New("UIPadding")({ PaddingRight = UDim.new(0, 10) }),
													v55:ForPairs(tbl16.Buttons, function(arg3, arg4, arg5, arg6)
														return arg5, arg6
													end),
												},
											}),
										},
									}),
								},
							}),
						}

						childrens[children2] = { set(v56, CanvasGroup(childrens2)) }
						tbl16.Root = TextButton(childrens)

						v55:insert(function()
							tbl16.destroyed = true

							if tbl16.closeTask then
								v51.cancel(tbl16.closeTask)
								tbl16.closeTask = nil
							end

							tbl16.Connection = nil
							tbl16.KeyboardConnection = nil
							tbl16.DefaultAction = nil
							tbl15[tbl16] = nil
						end)

						v55:insert(tbl16.Root.Destroying:Connect(function()
							tbl16:Destroy()
						end))

						tbl16.SetTitle = function(arg3, arg4)
							arg3.Title:set(tostring(arg4 or ""))
						end

						tbl16.SetDescription = function(arg3, arg4)
							arg3.Description:set(tostring(arg4 or ""))
						end

						tbl16.SetContent = function(arg3, arg4)
							arg3.Content:set(arg4)
						end

						tbl16.AddButton = function(arg3, arg4)
							local v60 = v55:innerScope()
							local v61 = v60:Value(false)
							local v62 = v60:Value(false)
							local v63 = v60:Value(arg4.Disabled == true)
							local style = arg4.Style or "default"
							local title = arg4.Title or "Button"

							local v64 = v60:New("TextButton")({
								Name = "DialogButton",
								AutoButtonColor = false,
								FontFace = Font.new(
									"rbxassetid://12187365364",
									Enum.FontWeight.Medium,
									Enum.FontStyle.Normal
								),
								Text = title,
								AutomaticSize = Enum.AutomaticSize.X,
								TextColor3 = v60:Computed(function(arg5)
									return (fn24(style, arg5, v61, v62))
								end),
								TextSize = 14,
								BackgroundColor3 = v60:Computed(function(arg5)
									local v64, v65 = fn24(style, arg5, v61, v62)
									return v65
								end),
								BackgroundTransparency = v45(function(arg5)
									return arg5(tbl16.Opened) and 0 or 1
								end, 40, 1, v60),
								BorderSizePixel = 0,
								Size = UDim2.fromOffset(0, 30),
								AutoLocalize = false,
								Active = v60:Computed(function(arg5)
									return not arg5(v63)
								end),
								[children] = {
									v60:New("UIStroke")({
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = v53.BgTertiary,
										Transparency = v45(function(arg5)
											return arg5(tbl16.Opened) and 0 or 1
										end, 40, 1, v60),
									}),
									v60:New("UICorner")({ CornerRadius = UDim.new(0, 4) }),
									v60:New("UIPadding")({
										PaddingLeft = UDim.new(0, 10),
										PaddingRight = UDim.new(0, 10),
									}),
								},
								[onEvent("InputEnded")] = function(input)
									if peek(v63) then
										return
									end

									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										v62:set(false)

										v49(function()
											if arg4.Callback and typeof(arg4.Callback) == "function" then
												if arg4.Callback() == false then
													return
												end
											end

											tbl16:Close()
										end)
									end
								end,
								[onEvent("InputBegan")] = function(input)
									if peek(v63) then
										return
									end

									if
										input.UserInputType == Enum.UserInputType.MouseButton1
										or input.UserInputType == Enum.UserInputType.Touch
									then
										v62:set(true)
									end
								end,
								[onEvent("MouseEnter")] = function()
									if peek(v63) then
										return
									end
									v61:set(true)
								end,
								[onEvent("MouseLeave")] = function()
									v61:set(false)
									v62:set(false)
								end,
							})

							local defaultAction = nil

							if arg4.Default == true then
								defaultAction = function()
									if peek(v63) then
										return
									end

									v49(function()
										if arg4.Callback and typeof(arg4.Callback) == "function" then
											if arg4.Callback() == false then
												return
											end
										end

										tbl16:Close()
									end)
								end

								tbl16.DefaultAction = defaultAction
							end

							v47(tbl16.Buttons, v64)
							local flag19 = false
							local v65 = nil

							local function fn25()
								if flag19 then
									return
								end
								flag19 = true

								if not tbl16.destroyed then
									v48(tbl16.Buttons, v64)
								end

								if tbl16.DefaultAction == defaultAction then
									tbl16.DefaultAction = nil
								end
							end

							local function onDestroying()
								if tbl16.destroyed then
									return
								end

								if v65 == nil then
									v65 = v51.defer(function()
										v65 = nil
										fn25()
										local v66 = table.find(v60, v64)

										if v66 ~= nil then
											table.remove(v60, v66)
										end

										v60:doCleanup()
									end)
								end
							end

							v60:insert(function()
								if v65 ~= nil then
									v51.cancel(v65)
									v65 = nil
								end

								fn25()
							end)

							v60:insert(v64.Destroying:Connect(onDestroying))
							return v64
						end

						tbl16.Connection = userInputService.InputBegan:Connect(function(input)
							if peek(v56) == nil then
								if tbl16.Connection then
									tbl16.Connection:Disconnect()
								end

								return
							end

							if
								(
									input.UserInputType == Enum.UserInputType.MouseButton1
									or input.UserInputType == Enum.UserInputType.Touch
								)
								and closeOnOverlayClick
								and dismissable
							then
								local guiObject = peek(v56)
								local absolutePosition = guiObject.AbsolutePosition
								local absoluteSize = guiObject.AbsoluteSize
								local mouseLocation = userInputService:GetMouseLocation()
								if
									mouseLocation.X < absolutePosition.X
									or mouseLocation.X > absolutePosition.X + absoluteSize.X
									or mouseLocation.Y < absolutePosition.Y - 1
									or mouseLocation.Y > absolutePosition.Y + absoluteSize.Y
								then
									tbl16:Close()
									return
								end
							end
						end)

						tbl16.KeyboardConnection = userInputService.InputBegan:Connect(function(input, gameProcessed)
							if gameProcessed then
								return
							end

							if userInputService:GetFocusedTextBox() then
								return
							end

							if closeOnEsc and input.KeyCode == Enum.KeyCode.Escape and dismissable then
								tbl16:Close()
							elseif
								confirmOnEnter
								and (input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter)
							then
								if tbl16.DefaultAction then
									tbl16.DefaultAction()
								end
							end
						end)

						v55:insert(tbl16.Connection)
						v55:insert(tbl16.KeyboardConnection)

						if arg2 and typeof(arg2.Buttons) == "table" then
							for _, button in ipairs(arg2.Buttons) do
								tbl16:AddButton(button)
							end
						end

						tbl16.Opened:set(true)
						tbl15[tbl16] = true
						return tbl16
					end

					tbl14.cleanup = function()
						for k in pairs(tbl15) do
							k:Destroy()
						end

						tbl15 = {}
						tbl14.Window = nil
						tbl14.Scope = nil
					end

					return tbl14
				end)()
			)
		end,
		[73] = function()
			local v, instance, v43 = fn23(73)

			return (
				(function()
					local utils = instance.Parent.Parent.Parent.Parent.utils
					local v44 = v43(utils.animate)
					local v45 = v43(utils.images)
					local packages = instance.Parent.Parent.Parent.Parent.packages
					local v46 = v43(packages.fusion)
					local v47 = v43(packages.states)
					local v48 = v43(instance.Parent.Parent.Parent.Parent.Internal)
					local v49 = v43(instance.Parent.Parent.Parent.Parent.storage.theme)
					local scope = v48.Scope
					local children = v46.Children
					local onEvent = v46.OnEvent
					local parts = instance.Parent.Parent.parts

					return function(arg)
						local v50 = (arg.Scope or scope):innerScope()
						local window = arg.Window
						local isTablistCollapsed = arg.isTablistCollapsed
						local isCompact = arg.isCompact or v50:Value(false)
						local statuses = arg.statuses
						local createStatusIndicator = arg.CreateStatusIndicator
						local forPairs = v50.ForPairs

						local v51 = v50:New("Frame")({
							Name = "MainPage",
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 1),
							[children] = {
								v50:New("Frame")({
									Name = "Tablist",
									BackgroundColor3 = v49.BgPrimary,
									BackgroundTransparency = v50:Computed(function(arg2)
										local n

										if arg2(isCompact) then
											n = 0
										else
											n = 1
										end

										return n
									end),
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.fromOffset(0, 0),
									Size = v44(function(arg2)
										local v51 = arg2(isTablistCollapsed)
										local v52

										if arg2(isCompact) then
											v52 = 180
										else
											v52 = 200
										end

										return UDim2.new(0, v51 and 0 or v52, 1, 0)
									end, 30, 1, v50),
									Interactable = v50:Computed(function(arg2)
										return not arg2(isTablistCollapsed)
									end),
									ClipsDescendants = true,
									ZIndex = 5,
									[children] = {
										v50:New("ScrollingFrame")({
											Name = "Tablist",
											ScrollBarImageColor3 = Color3.fromRGB(32, 32, 44),
											ScrollBarThickness = 0,
											ScrollingDirection = Enum.ScrollingDirection.Y,
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Selectable = false,
											Size = UDim2.new(1, 0, 1, -40),
											AutomaticCanvasSize = Enum.AutomaticSize.Y,
											CanvasSize = UDim2.new(0, 0, 0, 0),
											[children] = {
												v50:New("UIListLayout")({
													Name = "UIListLayout",
													Padding = UDim.new(0, 10),
													SortOrder = Enum.SortOrder.LayoutOrder,
												}),
												v50:New("UIPadding")({
													Name = "UIPadding",
													PaddingTop = UDim.new(0, 4),
												}),
												v50:ForPairs(v47.Categorys, function(arg2, arg3, arg4, arg5)
													return arg4, arg5
												end),
											},
										}),
										v50:New("Frame")({
											Name = "Buttons",
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Size = UDim2.new(1, 0, 0, 30),
											AnchorPoint = Vector2.new(0, 1),
											Position = UDim2.fromScale(0, 1),
											[children] = {
												v50:New("Frame")({
													Name = "Holder",
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													BorderColor3 = Color3.fromRGB(0, 0, 0),
													BorderSizePixel = 0,
													Size = UDim2.new(1, 0, 1, 0),
													[children] = {
														v50:New("UIListLayout")({
															Name = "UIListLayout",
															SortOrder = Enum.SortOrder.LayoutOrder,
															VerticalAlignment = Enum.VerticalAlignment.Center,
															Padding = UDim.new(0, 7),
															FillDirection = Enum.FillDirection.Horizontal,
														}),
														v50:New("UIPadding")({
															Name = "UIPadding",
															PaddingLeft = UDim.new(0, 10),
															PaddingBottom = UDim.new(0, 10),
														}),
														forPairs(
															v50,
															v50:Computed(function()
																return {
																	ClientControl = {
																		Name = "ClientControlContainer",
																		DefaultImageKey = "ClientControlIcon",
																		ActiveImageKey = "ClientControlActiveIcon",
																		IsToggled = v47.isCustomContainerToggled,
																		LayoutOrder = 1,
																	},
																}
															end),
															function(arg2, arg3, arg4, guiObject)
																local v51 = v43(
																	instance.Parent.Parent.Parent.actionButton
																).new({
																	Scope = arg3,
																	Name = guiObject.Name,
																	DefaultImageKey = guiObject.DefaultImageKey,
																	ActiveImageKey = guiObject.ActiveImageKey,
																	IsToggled = guiObject.IsToggled,
																	HasNotification = guiObject.HasNotification,
																	ShowNotification = guiObject.ShowNotification,
																	LayoutOrder = guiObject.LayoutOrder,
																	OnClick = guiObject.OnClick,
																})

																window.ActionButtons[arg4] = v51
																return arg4, v51.Root
															end
														),
													},
												}),
											},
										}),
										v50:New("Frame")({
											Name = "Seperator",
											BackgroundColor3 = v49.BgTertiary,
											BackgroundTransparency = v44(function(arg2)
												return arg2(isTablistCollapsed) and 1 or 0
											end, 55, 1, v50),
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Position = UDim2.fromScale(1, 0),
											Size = UDim2.new(0, -1, 1, 0),
										}),
									},
								}),
								v50:New("Frame")({
									Name = "Containers",
									AnchorPoint = Vector2.new(1, 0),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									ClipsDescendants = true,
									Position = UDim2.new(1, 0, 0, 0),
									Size = v44(function(arg2)
										local v51 = arg2(isTablistCollapsed)
										if arg2(isCompact) then
											return UDim2.fromScale(1, 1)
										end
										return UDim2.new(1, v51 and 0 or -200, 1, 0)
									end, 30, 1, v50),
									SelectionGroup = true,
									[children] = {
										v43(parts.statusBar)({
											scope = v50,
											Theme = v49,
											statuses = statuses,
											States = v47,
											Images = v45,
											CreateStatusIndicator = createStatusIndicator,
										}),
										v50:New("ScrollingFrame")({
											Name = "ClientControlContainer",
											ScrollBarImageColor3 = v49.FgTertiary,
											ScrollBarThickness = 2,
											ScrollingDirection = Enum.ScrollingDirection.Y,
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											ClipsDescendants = true,
											Selectable = false,
											Size = UDim2.new(1, 0, 1, -31),
											AutomaticCanvasSize = Enum.AutomaticSize.Y,
											CanvasSize = UDim2.new(0, 0, 0, 0),
											Visible = v50:Computed(function(arg2)
												return arg2(v47.isCustomContainerToggled)
											end),
											[children] = {
												v50:New("UIPadding")({
													Name = "UIPadding",
													PaddingTop = UDim.new(0, 8),
													PaddingBottom = UDim.new(0, 8),
												}),
												v50:New("UIListLayout")({
													Name = "UIListLayout",
													HorizontalAlignment = Enum.HorizontalAlignment.Center,
													SortOrder = Enum.SortOrder.LayoutOrder,
													Padding = UDim.new(0, 10),
												}),
												v50:ForPairs(
													window.ClientControlContainer.Sections,
													function(arg2, arg3, arg4, arg5)
														return arg4, arg5
													end
												),
											},
										}),
										v50:ForPairs(v47.Containers, function(arg2, arg3, arg4, arg5)
											return arg4, arg5
										end),
									},
								}),
								v50:New("TextButton")({
									Name = "CompactSidebarScrim",
									Text = "",
									AutoButtonColor = false,
									BackgroundColor3 = Color3.new(0, 0, 0),
									BackgroundTransparency = 0.45,
									BorderSizePixel = 0,
									Size = UDim2.fromScale(1, 1),
									Visible = v50:Computed(function(arg2)
										return arg2(isCompact) and not arg2(isTablistCollapsed)
									end),
									ZIndex = 4,
									[onEvent("Activated")] = function()
										window:ToggleTablist()
									end,
								}),
							},
						})

						local flag19 = false

						local function onDestroying()
							if flag19 then
								return
							end
							v50:doCleanup()
						end

						v50:insert(function()
							flag19 = true
						end)

						v50:insert(v51.Destroying:Connect(onDestroying))
						return v51
					end
				end)()
			)
		end,
		[74] = function()
			local v, instance, v43 = fn23(74)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.Parent.packages.fusion)
					local scope = v43(instance.Parent.Parent.Parent.Parent.Internal).Scope
					local children = v44.Children

					return function(arg)
						local v45 = (arg.Scope or scope):innerScope()
						local pageManager = arg.pageManager

						local v46 = v45:New("Frame")({
							Name = "PageContainer",
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 1),
							ClipsDescendants = true,
							[children] = {
								v45:Computed(function(arg2, arg3)
									local v46 = arg2(pageManager.currentPage)
									local v47 = v44.peek(pageManager.pages)[v46]
									if v47 and v47.component then
										return v47.component(arg3)
									end

									return arg3:New("Frame")({
										Name = "EmptyPage",
										BackgroundTransparency = 1,
										Size = UDim2.fromScale(1, 1),
										[children] = {
											arg3:New("TextLabel")({
												Name = "EmptyMessage",
												Text = "Page not found: " .. tostring(v46),
												TextColor3 = Color3.fromRGB(200, 200, 200),
												TextSize = 16,
												BackgroundTransparency = 1,
												Size = UDim2.fromScale(1, 1),
												TextXAlignment = Enum.TextXAlignment.Center,
												TextYAlignment = Enum.TextYAlignment.Center,
											}),
										},
									})
								end),
							},
						})

						local flag19 = false

						local function onDestroying()
							if flag19 then
								return
							end
							v45:doCleanup()
						end

						v45:insert(function()
							flag19 = true
						end)

						v45:insert(v46.Destroying:Connect(onDestroying))
						return v46
					end
				end)()
			)
		end,
		[75] = function()
			local v, instance, v43 = fn23(75)

			return (
				(function()
					local peek = v43(instance.Parent.Parent.Parent.Parent.packages.fusion).peek
					local index = {}
					index.__index = index

					index.new = function(scope)
						local obj = setmetatable({}, index)
						obj.currentPage = scope:Value("main")
						obj.pages = scope:Value({})
						obj.pageHistory = scope:Value({})
						obj.breadcrumbs = scope:Value({})
						obj.scope = scope
						return obj
					end

					index.RegisterPage = function(arg, arg2, arg3)
						assert(type(arg2) == "string", "Page ID must be a string")
						assert(type(arg3) == "table", "Page config must be a table")
						assert(type(arg3.title) == "string", "Page config must have a title")
						assert(type(arg3.component) == "function", "Page config must have a component function")
						local v44 = peek(arg.pages)
						local v45 = table.clone(v44)

						v45[arg2] = {
							id = arg2,
							title = arg3.title,
							component = arg3.component,
							icon = arg3.icon,
							showTablist = arg3.showTablist ~= false,
							showContainers = arg3.showContainers ~= false,
							breadcrumbPath = arg3.breadcrumbPath or { arg3.title },
							metadata = arg3.metadata or {},
						}

						arg.pages:set(v45)
					end

					index.NavigateTo = function(arg, arg2, arg3)
						local flag19 = arg3 ~= false
						local v44 = peek(arg.pages)[arg2]
						if not v44 then
							warn("Attempted to navigate to non-existent page: " .. tostring(arg2))
							return false
						end

						if flag19 then
							local v45 = peek(arg.currentPage)

							if v45 ~= arg2 then
								local v46 = peek(arg.pageHistory)
								local v47 = table.clone(v46)
								table.insert(v47, v45)
								arg.pageHistory:set(v47)
							end
						end

						arg.currentPage:set(arg2)
						arg.breadcrumbs:set(v44.breadcrumbPath)
						return true
					end

					index.NavigateBack = function(arg)
						local v44 = peek(arg.pageHistory)

						if #v44 > 0 then
							local v45 = v44[#v44]
							local v46 = table.clone(v44)
							table.remove(v46)
							arg.pageHistory:set(v46)
							return arg:NavigateTo(v45, false)
						end

						return false
					end

					index.GetCurrentPage = function(arg)
						local v44 = peek(arg.currentPage)
						return peek(arg.pages)[v44]
					end

					index.GetCurrentPageComponent = function(arg)
						local currentPage = arg:GetCurrentPage()
						if currentPage and currentPage.component then
							return currentPage.component(arg.scope)
						end
						return nil
					end

					index.ShouldShowTablist = function(arg)
						local currentPage = arg:GetCurrentPage()
						return currentPage and currentPage.showTablist or false
					end

					index.ShouldShowContainers = function(arg)
						local currentPage = arg:GetCurrentPage()
						return currentPage and currentPage.showContainers or false
					end

					index.GetBreadcrumbs = function(arg)
						return peek(arg.breadcrumbs)
					end

					index.GetAllPages = function(arg)
						return peek(arg.pages)
					end

					index.CanNavigateBack = function(arg)
						return #peek(arg.pageHistory) > 0
					end

					index.Reset = function(arg)
						arg.currentPage:set("main")
						arg.pageHistory:set({})
					end

					return index
				end)()
			)
		end,
		[77] = function()
			local v, instance, v43 = fn23(77)

			return (
				(function()
					local parent = instance.Parent.Parent.Parent.Parent
					local v44 = v43(parent.utils.images)
					local scope = v43(parent.Internal).Scope

					return function(arg)
						local v45 = ((arg or {}).Scope or scope):innerScope()

						local v46 = v45:New("ImageLabel")({
							Name = "Dropshadow",
							Image = v44.Dropshadow,
							ImageColor3 = Color3.fromRGB(0, 0, 0),
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(128, 128, 128, 128),
							SliceScale = 0.35,
							Active = true,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.new(1, 56, 1, 56),
							ZIndex = -2,
						})

						local flag19 = false

						local function onDestroying()
							if flag19 then
								return
							end
							v45:doCleanup()
						end

						v45:insert(function()
							flag19 = true
						end)

						v45:insert(v46.Destroying:Connect(onDestroying))
						return v46
					end
				end)()
			)
		end,
		[78] = function()
			fn23(78)

			return (
				(function()
					return function(arg)
						local scope = arg.scope
						local onEvent = arg.OnEvent
						local resizing = arg.Resizing
						local resizePos = arg.ResizePos
						local initialResizeSize = arg.InitialResizeSize
						local size = arg.Size
						local peek = arg.peek
						local isCompact = arg.IsCompact
						local Frame = scope:New("Frame")

						local tbl14 = {
							Name = "ResizeFrame",
							AnchorPoint = Vector2.new(1, 1),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(1, 1),
						}

						local udim2

						if isCompact then
							udim2 = scope:Computed(function(arg2)
								local x

								if arg2(isCompact) then
									x = 32
								else
									x = 16
								end

								return UDim2.fromOffset(x, x)
							end)
						else
							udim2 = UDim2.fromOffset(16, 16)
						end

						tbl14.Size = udim2

						tbl14[onEvent("InputBegan")] = function(input)
							if
								input.UserInputType == Enum.UserInputType.MouseButton1
								or input.UserInputType == Enum.UserInputType.Touch
							then
								resizing:set(true)
								resizePos:set(input.Position)
								initialResizeSize:set(Vector2.new(peek(size).X, peek(size).Y))
							end
						end

						return Frame(tbl14)
					end
				end)()
			)
		end,
		[79] = function()
			fn23(79)

			return (
				(function()
					return function(arg)
						local scope = arg.scope
						local theme = arg.Theme
						local statuses = arg.statuses
						local states = arg.States
						local images = arg.Images
						local createStatusIndicator = arg.CreateStatusIndicator

						return scope:New("Frame")({
							Name = "StatusBar",
							AnchorPoint = Vector2.new(0, 1),
							BackgroundColor3 = theme.BgPrimary,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0, 1),
							Size = UDim2.new(1, 0, 0, 25),
							Visible = scope:Computed(function(arg2)
								return not arg2(states.ChatOpen) and not arg2(states.isAIChatToggled)
							end),
							[scope.Children] = {
								scope:New("UIStroke")({ Name = "UIStroke", Color = theme.BgTertiary }),
								scope:New("Frame")({
									Name = "StatusWrapper",
									Size = UDim2.new(1, 0, 1, 0),
									BackgroundTransparency = 1,
									[scope.Children] = {
										scope:New("UIListLayout")({
											Name = "UIListLayout",
											FillDirection = Enum.FillDirection.Horizontal,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											Padding = UDim.new(0, 10),
										}),
										scope:New("UIPadding")({
											Name = "UIPadding",
											PaddingLeft = UDim.new(0, 10),
											PaddingRight = UDim.new(0, 10),
										}),
										scope:ForPairs(statuses, function(arg2, arg3, arg4, arg5)
											return arg4, createStatusIndicator(arg3, arg4, arg5)
										end),
									},
								}),
								scope:New("ImageLabel")({
									Name = "Resize Handle",
									Size = UDim2.new(0, 12, 0, 12),
									Image = images.ResizeHandle,
									ImageColor3 = theme.FgTertiary,
									Selectable = false,
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									AnchorPoint = Vector2.new(1, 0.5),
									Position = UDim2.new(1, -5, 0.5, 0),
								}),
							},
						})
					end
				end)()
			)
		end,
		[80] = function()
			local v, instance, v43 = fn23(80)

			return (
				(function()
					local utils = instance.Parent.Parent.Parent.Parent.utils
					local v44 = v43(utils.color3)
					local v45 = v43(utils.fusionUtils.combineProps)
					local v46 = v43(instance.Parent.Parent.Parent.ui.adaptiveHighlight)
					local tbl14 = {}
					local font = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
					local font2 = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

					return function(arg)
						local scope = arg.scope
						local theme = arg.Theme
						local images = arg.Images
						local animate = arg.animate
						local window = arg.Window
						local minimizeHovering = arg.MinimizeHovering
						local minimizeHeldDown = arg.MinimizeHeldDown
						local closeHovering = arg.CloseHovering
						local closeHeldDown = arg.CloseHeldDown
						local onEvent = arg.OnEvent
						local title = arg.Title
						local tag = arg.Tag
						local library = arg.Library
						local isCompact = arg.IsCompact or scope:Value(false)
						local pageManager = arg.pageManager
						local v47 = scope:Value(false)
						local v48 = scope:Value(false)

						local v49 = scope:Computed(function(arg2)
							local v49 = arg2(pageManager.breadcrumbs)
							return type(v49) == "table" and #v49 > 0
						end)

						local v50 = scope:Computed(function(arg2)
							local v50 = arg2(title)
							if not v50 or type(v50) ~= "string" or v50 == "" then
								return "Window"
							end
							return v50
						end)

						local v51 = scope:Computed(function(arg2)
							local v51 = arg2(pageManager.breadcrumbs)
							if type(v51) ~= "table" then
								return ""
							end
							local v52 = arg2(theme.FgTertiary):ToHex()
							return table.concat(v51, string.format(' <font color="#%s">/</font> ', v52))
						end)

						local track = images.Track

						return scope:New("Frame")({
							Name = "Topbar",
							BackgroundColor3 = theme.BgPrimaryHighlight,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 45),
							ZIndex = 1,
							[scope.Children] = {
								scope:New("Frame")({
									Name = "Seperator",
									BackgroundColor3 = theme.BgTertiary,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.new(0, 0, 1, -1),
									Size = UDim2.new(1, 0, 0, 1),
								}),
								scope:New("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 4) }),
								scope:New("Frame")({
									Name = "TextHolder",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.fromOffset(15, 0),
									Size = scope:Computed(function(arg2)
										local udim2 = UDim2.new
										local n

										if arg2(isCompact) then
											n = -105
										else
											n = -15
										end

										return udim2(1, n, 1, 0)
									end),
									ClipsDescendants = true,
									[scope.Children] = {
										scope:New("TextButton")({
											Name = "Title",
											Text = "",
											AutomaticSize = Enum.AutomaticSize.X,
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Position = UDim2.fromOffset(15, 0),
											Size = UDim2.fromOffset(0, 45),
											[scope.Children] = {
												scope:New("TextLabel")({
													Name = "TitleText",
													FontFace = font2,
													Text = v50,
													TextColor3 = animate(function(arg2)
														if arg2(v48) then
															return arg2(theme.FgTertiary)
														end

														if arg2(v47) then
															return arg2(theme.FgSecondary)
														end
														return arg2(theme.FgPrimary)
													end, 30, 1.2, scope),
													TextSize = 17,
													TextXAlignment = Enum.TextXAlignment.Left,
													TextYAlignment = Enum.TextYAlignment.Center,
													AutomaticSize = Enum.AutomaticSize.X,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													BorderColor3 = Color3.fromRGB(0, 0, 0),
													BorderSizePixel = 0,
													Size = UDim2.fromOffset(0, 45),
												}),
												scope:New("Frame")({
													Name = "BreadcrumbSeparator",
													Visible = scope:Computed(function(arg2)
														return arg2(v49) and not arg2(isCompact)
													end),
													BackgroundColor3 = scope:Computed(function(arg2)
														return v44.darkenRGB(arg2(theme.FgTertiary), 20)
													end),
													BorderColor3 = Color3.fromRGB(0, 0, 0),
													BorderSizePixel = 0,
													Size = UDim2.fromOffset(4, 4),
													[scope.Children] = {
														scope:New("UICorner")({
															Name = "UICorner",
															CornerRadius = UDim.new(1, 0),
														}),
													},
												}),
												scope:New("TextLabel")({
													Name = "Breadcrumbs",
													FontFace = font,
													Text = v51,
													RichText = true,
													TextColor3 = theme.FgTertiary,
													TextSize = 17,
													TextXAlignment = Enum.TextXAlignment.Left,
													TextYAlignment = Enum.TextYAlignment.Center,
													Visible = scope:Computed(function(arg2)
														return arg2(v49) and not arg2(isCompact)
													end),
													AutomaticSize = Enum.AutomaticSize.X,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													BorderColor3 = Color3.fromRGB(0, 0, 0),
													BorderSizePixel = 0,
													Size = UDim2.fromOffset(0, 45),
												}),
												scope:New("UIListLayout")({
													Name = "UIListLayout",
													Padding = UDim.new(0, 7),
													FillDirection = Enum.FillDirection.Horizontal,
													SortOrder = Enum.SortOrder.LayoutOrder,
													VerticalAlignment = Enum.VerticalAlignment.Center,
												}),
											},
											[onEvent("MouseEnter")] = function()
												v47:set(true)
											end,
											[onEvent("MouseLeave")] = function()
												v48:set(false)
												v47:set(false)
											end,
											[onEvent("InputBegan")] = function(input)
												if
													input.UserInputType == Enum.UserInputType.MouseButton1
													or input.UserInputType == Enum.UserInputType.Touch
												then
													v48:set(true)
												end
											end,
											[onEvent("InputEnded")] = function(input)
												if
													input.UserInputType == Enum.UserInputType.MouseButton1
													or input.UserInputType == Enum.UserInputType.Touch
												then
													v48:set(false)
												end
											end,
											[onEvent("Activated")] = function()
												if pageManager:GetCurrentPage().id == "main" then
													window:ToggleTablist()
												else
													pageManager:NavigateBack()
												end
											end,
										}),
										scope:New("UIListLayout")({
											Name = "UIListLayout",
											Padding = UDim.new(0, 7),
											FillDirection = Enum.FillDirection.Horizontal,
											SortOrder = Enum.SortOrder.LayoutOrder,
											VerticalAlignment = Enum.VerticalAlignment.Center,
										}),
										v46(scope, function(arg2, arg3)
											local v52 = arg3[tbl14]
											arg3[tbl14] = nil

											local v53 = arg2:New("ImageLabel")({
												Name = "ButtonHighlight",
												Image = images.ButtonIcon,
												Size = UDim2.fromScale(1, 1),
												BackgroundTransparency = 1,
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												ImageColor3 = Color3.fromRGB(255, 255, 255),
												ScaleType = Enum.ScaleType.Slice,
												SliceScale = 0.5,
												SliceCenter = Rect.new(25, 25, 25, 25),
												Active = false,
												ZIndex = 1,
											})

											return arg2:New("Frame")(v45(arg3, {
												Name = "TagHolder",
												Visible = scope:Computed(function(arg4)
													return not arg4(isCompact)
												end),
												AutomaticSize = Enum.AutomaticSize.X,
												BackgroundColor3 = theme.AccentPrimary,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Size = UDim2.fromOffset(0, 15),
												[scope.Children] = {
													v53,
													arg2:New("UIStroke")({
														Name = "AdaptiveHighlightStroke",
														ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
														Color = Color3.fromRGB(255, 255, 255),
														Thickness = 1.5,
														[scope.Children] = { v52 },
													}),
													scope:New("TextLabel")({
														Name = "TagTitle",
														FontFace = Font.new(
															"rbxassetid://12187365364",
															Enum.FontWeight.Medium,
															Enum.FontStyle.Normal
														),
														Text = tag,
														TextColor3 = Color3.fromRGB(0, 0, 0),
														TextSize = 12,
														AutomaticSize = Enum.AutomaticSize.X,
														BackgroundColor3 = Color3.fromRGB(255, 255, 255),
														BackgroundTransparency = 1,
														BorderColor3 = Color3.fromRGB(0, 0, 0),
														BorderSizePixel = 0,
														Size = UDim2.fromScale(1, 1),
													}),
													scope:New("UIPadding")({
														Name = "UIPadding",
														PaddingLeft = UDim.new(0, 5),
														PaddingRight = UDim.new(0, 5),
													}),
													scope:New("UICorner")({
														Name = "UICorner",
														CornerRadius = UDim.new(0, 4),
													}),
												},
											}))
										end, {
											GradientColor = scope:Computed(function(arg2)
												local v52 = arg2(theme.AccentPrimary)
												local new = ColorSequenceKeypoint.new
												local darkenRGB = v44.darkenRGB
												return ColorSequence.new({
													ColorSequenceKeypoint.new(0, v44.lightenRGB(v52, 35)),
													new(1, darkenRGB(v52, 35)),
												})
											end),
											GradientTransparency = 0,
											GradientProperty = tbl14,
										}),
									},
								}),
								scope:New("Frame")({
									Name = "ButtonHolder",
									AnchorPoint = Vector2.new(1, 0),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.new(1, -15, 0, 0),
									Size = UDim2.new(1, -15, 1, 0),
									[scope.Children] = {
										scope:New("UIListLayout")({
											Name = "UIListLayout",
											Padding = UDim.new(0, 10),
											FillDirection = Enum.FillDirection.Horizontal,
											HorizontalAlignment = Enum.HorizontalAlignment.Right,
											SortOrder = Enum.SortOrder.LayoutOrder,
											VerticalAlignment = Enum.VerticalAlignment.Center,
										}),
										images:Track(
											"MinimizeIcon",
											scope:New("ImageButton")({
												Name = "Minimize",
												Image = images.MinimizeIcon,
												ImageColor3 = animate(function(arg2)
													if arg2(minimizeHeldDown) then
														return arg2(theme.FgSecondary)
													end

													if arg2(minimizeHovering) then
														return arg2(theme.FgPrimary)
													end
													return arg2(theme.FgTertiary)
												end, 25, 1, scope),
												Active = false,
												AnchorPoint = Vector2.new(0.5, 0.5),
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.fromScale(0.5, 0.5),
												Selectable = false,
												Size = scope:Computed(function(arg2)
													local x

													if arg2(isCompact) then
														x = 32
													else
														x = 22
													end

													return UDim2.fromOffset(x, x)
												end),
												[onEvent("InputEnded")] = function(input)
													if
														input.UserInputType == Enum.UserInputType.MouseButton1
														or input.UserInputType == Enum.UserInputType.Touch
													then
														minimizeHeldDown:set(false)
													end
												end,
												[onEvent("Activated")] = function()
													window:Minimize()
												end,
												[onEvent("InputBegan")] = function(input)
													if
														input.UserInputType == Enum.UserInputType.MouseButton1
														or input.UserInputType == Enum.UserInputType.Touch
													then
														minimizeHeldDown:set(true)
													end
												end,
												[onEvent("MouseEnter")] = function()
													minimizeHovering:set(true)
												end,
												[onEvent("MouseLeave")] = function()
													minimizeHeldDown:set(false)
													minimizeHovering:set(false)
												end,
											})
										),
										track(
											images,
											"CloseIcon",
											scope:New("ImageButton")({
												Name = "Close",
												Image = images.CloseIcon,
												ImageColor3 = animate(function(arg2)
													if arg2(closeHeldDown) then
														return arg2(theme.FgSecondary)
													end

													if arg2(closeHovering) then
														return arg2(theme.FgPrimary)
													end
													return arg2(theme.FgTertiary)
												end, 25, 1, scope),
												Active = false,
												AnchorPoint = Vector2.new(0.5, 0.5),
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.fromScale(0.5, 0.5),
												Selectable = false,
												Size = scope:Computed(function(arg2)
													local x

													if arg2(isCompact) then
														x = 32
													else
														x = 22
													end

													return UDim2.fromOffset(x, x)
												end),
												[onEvent("InputEnded")] = function(input)
													if
														input.UserInputType == Enum.UserInputType.MouseButton1
														or input.UserInputType == Enum.UserInputType.Touch
													then
														closeHeldDown:set(false)
														local v52 = window:Dialog({
															Title = "EXIT SCRIPT",
															Description = "Are you sure you want to exit the script?",
														})
														v52:AddButton({ Title = "Go Back", Style = "default" })

														v52:AddButton({
															Title = "Exit Script",
															Style = "primary",
															Callback = function()
																library:Destroy()
															end,
														})
													end
												end,
												[onEvent("InputBegan")] = function(input)
													if
														input.UserInputType == Enum.UserInputType.MouseButton1
														or input.UserInputType == Enum.UserInputType.Touch
													then
														closeHeldDown:set(true)
													end
												end,
												[onEvent("MouseEnter")] = function()
													closeHovering:set(true)
												end,
												[onEvent("MouseLeave")] = function()
													closeHovering:set(false)
													closeHeldDown:set(false)
												end,
											})
										),
									},
								}),
							},
						})
					end
				end)()
			)
		end,
		[81] = function()
			local v, instance, v43 = fn23(81)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local utils = instance.Parent.Parent.Parent.utils
					local v45 = v43(utils.images)
					local v46 = v43(utils.animate)
					local children = v44.Children
					local onEvent = v44.OnEvent
					local out = v44.Out
					local peek = v44.peek
					local v47 = v43(instance.Parent.Parent.Parent.storage.theme)

					return function(arg)
						local scope2 = (arg.Scope or scope):innerScope()
						local tbl14 = { Title = arg.Title, Components = scope2:Value(table.freeze({})) }
						tbl14.Collapsed = scope2:Value(arg.Collapsed or false)
						tbl14.Scope = scope2
						tbl14.Root = nil

						tbl14.Render = function(arg2, arg3)
							local v48 = arg3:innerScope()
							local v49 = v48:Value(Vector2.new())
							local v50 = v45
							local track = v50.Track
							local forPairs = v48.ForPairs

							local root = v48:New("Frame")({
								Name = "Section",
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundColor3 = v47.BgPrimaryHighlight,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.new(1, -12, 0, 0),
								ClipsDescendants = true,
								[children] = {
									v48:New("UIStroke")({ Name = "UIStroke", Color = v47.BgTertiary }),
									v48:New("UIListLayout")({
										Name = "UIListLayout",
										SortOrder = Enum.SortOrder.LayoutOrder,
									}),
									v48:New("Frame")({
										Name = "Header",
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Size = UDim2.new(1, 0, 0, 40),
										[children] = {
											v48:New("TextLabel")({
												Name = "Title",
												FontFace = Font.new(
													"rbxassetid://12187365364",
													Enum.FontWeight.SemiBold,
													Enum.FontStyle.Normal
												),
												Text = tbl14.Title,
												TextColor3 = v47.FgTertiary,
												TextSize = 18,
												TextXAlignment = Enum.TextXAlignment.Left,
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												AutomaticSize = Enum.AutomaticSize.X,
												Size = UDim2.fromScale(0, 1),
											}),
											track(
												v50,
												"ChevronDownIcon",
												v48:New("ImageButton")({
													Name = "Collapse",
													Image = v45.ChevronDownIcon,
													ImageColor3 = v47.FgTertiary,
													AnchorPoint = Vector2.new(1, 0.5),
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													BorderColor3 = Color3.fromRGB(0, 0, 0),
													BorderSizePixel = 0,
													Position = UDim2.new(1, -15, 0.5, 0),
													Size = UDim2.fromOffset(20, 20),
													Rotation = v46(function(arg4)
														if arg4(tbl14.Collapsed) then
															return 180
														end
														return 0
													end, 25, 1, v48),
													[onEvent("Activated")] = function()
														tbl14.Collapsed:set(not peek(tbl14.Collapsed))
													end,
												})
											),
										},
									}),
									v48:New("TextLabel")({
										Name = "CollapsedMessage",
										LayoutOrder = 1,
										Visible = v48:Computed(function(arg4)
											return arg4(tbl14.Collapsed)
										end),
										FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
										Text = "Click the arrow to expand this section and view all elements...",
										TextColor3 = v47.FgTertiary,
										TextSize = 15,
										TextXAlignment = Enum.TextXAlignment.Left,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Size = UDim2.fromScale(1, 0),
										AutomaticSize = Enum.AutomaticSize.Y,
									}),
									v48:New("UIPadding")({
										Name = "UIPadding",
										PaddingBottom = UDim.new(0, 12),
										PaddingLeft = UDim.new(0, 12),
										PaddingTop = UDim.new(0, 4),
									}),
									v48:New("Frame")({
										Name = "Holder",
										LayoutOrder = 2,
										AutomaticSize = Enum.AutomaticSize.None,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										ClipsDescendants = false,
										Size = v46(function(arg4)
											if arg4(tbl14.Collapsed) then
												return UDim2.fromScale(1, 0)
											end
											return UDim2.new(1, 0, 0, arg4(v49).Y)
										end, 25, 1, v48),
										[children] = {
											v48:New("UIListLayout")({
												Name = "UIListLayout",
												Padding = UDim.new(0, 10),
												SortOrder = Enum.SortOrder.LayoutOrder,
												VerticalAlignment = Enum.VerticalAlignment.Top,
												[out("AbsoluteContentSize")] = v49,
											}),
											v48:New("UIPadding")({
												Name = "UIPadding",
												PaddingRight = UDim.new(0, 15),
												PaddingLeft = UDim.new(0, 2),
												PaddingTop = UDim.new(0, 1),
												PaddingBottom = UDim.new(0, 1),
											}),
											forPairs(v48, tbl14.Components, function(arg4, arg5, arg6, arg7)
												if arg4(tbl14.Collapsed) then
													return nil
												end

												if arg7 and arg7.Render then
													return arg6, arg7:Render(arg5)
												end
												return nil
											end),
										},
									}),
								},
							})

							tbl14.Root = root
							return root
						end

						return tbl14
					end
				end)()
			)
		end,
		[82] = function()
			local v, instance, v43 = fn23(82)

			return (
				(function()
					local utils = instance.Parent.Parent.Parent.utils
					local v44 = v43(utils.animate)
					local v45 = v43(utils.insertitem)
					local v46 = v43(utils.controlRegistry)
					local packages = instance.Parent.Parent.Parent.packages
					local v47 = v43(packages.fusion)
					local v48 = v43(packages.states)
					local scope = v43(instance.Parent.Parent.Parent.Internal).Scope
					local children = v47.Children
					local onEvent = v47.OnEvent
					local onChange = v47.OnChange
					local peek = v47.peek
					local v49 = v43(instance.Parent.Parent.Parent.storage.theme)
					local v50 = 10

					return function(arg)
						local v51 = (arg.Scope or scope):innerScope()

						local tbl14 = {
							Selected = v51:Value(false),
							Sections = v51:Value(table.freeze({})),
							LeftSections = v51:Value(table.freeze({})),
							RightSections = v51:Value(table.freeze({})),
							nSections = 0,
							Hovering = v51:Value(false),
							LayoutMode = v51:Value("vertical"),
							Scope = v51,
							ViewState = { CanvasPosition = Vector2.new(0, 0) },
							Root = nil,
						}

						local v52 = peek(v48.Elements)
						local v53 = nil
						local v54 = nil

						local v55 = v51:Computed(function(arg2)
							return not arg2(v48.ChatOpen)
								and not arg2(v48.isCustomContainerToggled)
								and not arg2(v48.isAIChatToggled)
								and arg2(tbl14.Selected)
						end)

						local function fn24(arg2)
							local function fn25(arg3, arg4, arg5, udim2, arg6)
								return arg3:New("Frame")({
									Name = arg4,
									LayoutOrder = arg6,
									AutomaticSize = Enum.AutomaticSize.Y,
									Size = udim2,
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									[children] = {
										arg3:New("UIListLayout")({
											Name = "UIListLayout",
											SortOrder = Enum.SortOrder.LayoutOrder,
											HorizontalAlignment = Enum.HorizontalAlignment.Center,
											Padding = UDim.new(0, v50),
										}),
										arg3:New("UIPadding")({
											Name = "UIPadding",
											PaddingTop = UDim.new(0, 8),
											PaddingBottom = UDim.new(0, 8),
										}),
										arg3:ForPairs(arg5, function(arg7, arg8, arg9, arg10)
											if not arg10 or not arg10.Render then
												return nil
											end
											return arg9, arg10:Render(arg8)
										end),
									},
								})
							end

							return (
								arg2:New("ScrollingFrame")({
									Name = arg.Title,
									ScrollBarImageColor3 = v49.FgTertiary,
									ScrollBarThickness = 1,
									ScrollingDirection = Enum.ScrollingDirection.Y,
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									ClipsDescendants = true,
									Selectable = false,
									Size = UDim2.new(1, 0, 1, -31),
									AutomaticCanvasSize = Enum.AutomaticSize.Y,
									CanvasSize = UDim2.new(0, 0, 0, 0),
									CanvasPosition = tbl14.ViewState.CanvasPosition,
									Visible = v55,
									[onChange("CanvasPosition")] = function(canvasPosition)
										tbl14.ViewState.CanvasPosition = canvasPosition
									end,
									[children] = {
										arg2:Computed(function(arg3, arg4)
											local isCompact = arg.IsCompact and arg3(arg.IsCompact) or false
											if arg3(tbl14.LayoutMode) == "vertical" or isCompact then
												return fn25(
													arg4,
													arg.Title .. "Sections",
													tbl14.Sections,
													UDim2.new(1, 0, 0, 0),
													1
												)
											end
											local rightSections = tbl14.RightSections

											return arg4:New("Frame")({
												Name = "Columns",
												AutomaticSize = Enum.AutomaticSize.Y,
												Position = UDim2.new(),
												Size = UDim2.new(1, 0, 0, 0),
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
												[children] = {
													arg4:New("UIListLayout")({
														Name = "UIListLayout",
														FillDirection = Enum.FillDirection.Horizontal,
														SortOrder = Enum.SortOrder.LayoutOrder,
														Padding = UDim.new(0, 0),
													}),
													fn25(
														arg4,
														"LeftColumn",
														tbl14.LeftSections,
														UDim2.new(0.5, 0, 0, 0),
														1
													),
													fn25(
														arg4,
														"RightColumn",
														rightSections,
														UDim2.new(0.5, 0, 0, 0),
														2
													),
												},
											})
										end),
									},
								})
							)
						end

						tbl14.Root = v51:New("TextButton")({
							Name = arg.Title,
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 0),
							[children] = {
								v51:New("TextLabel")({
									Name = "TextLabel",
									FontFace = Font.new(
										"rbxassetid://12187365364",
										Enum.FontWeight.Medium,
										Enum.FontStyle.Normal
									),
									Text = arg.Title,
									TextColor3 = v44(function(arg2)
										if arg2(tbl14.Selected) then
											return arg2(v49.FgPrimary)
										end

										if arg2(tbl14.Hovering) then
											return arg2(v49.FgSecondary)
										end
										return arg2(v49.FgTertiary)
									end, 25, 1, v51),
									TextSize = 15,
									TextXAlignment = Enum.TextXAlignment.Left,
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.fromOffset(15, 0),
									Size = UDim2.new(1, -15, 0, -10),
								}),
								v51:New("Frame")({
									Name = "Indicator",
									BackgroundColor3 = v49.AccentPrimary,
									BackgroundTransparency = v44(function(arg2)
										if arg2(tbl14.Selected) then
											return 0
										end
										return 1
									end, 25, 1, v51),
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.new(0, 15, 1, 0),
									Size = v44(function(arg2)
										if arg2(tbl14.Selected) then
											return UDim2.fromOffset(15, 4)
										end
										return UDim2.fromOffset(0, 4)
									end, 20, 1, v51),
									Visible = tbl14.Selected,
									[children] = { v51:New("UICorner")({ Name = "UICorner" }) },
								}),
								v51:New("UIListLayout")({
									Name = "UIListLayout",
									Padding = UDim.new(0, 8),
									SortOrder = Enum.SortOrder.LayoutOrder,
								}),
								v51:New("UIPadding")({ Name = "UIPadding", PaddingLeft = UDim.new(0, 15) }),
							},
							[onEvent("Activated")] = function()
								for _, v56 in pairs(peek(v48.Tabs)) do
									v56.Selected:set(false)
								end

								tbl14.Selected:set(true)

								if arg.OnSelected then
									arg.OnSelected()
								end
							end,
							[onEvent("MouseEnter")] = function()
								tbl14.Hovering:set(true)
							end,
							[onEvent("MouseLeave")] = function()
								tbl14.Hovering:set(false)
							end,
						})

						v48.add("Tabs", tbl14, arg.Title)

						v51:Observer(v55):onChange(function()
							if peek(v55) and not v53 then
								v53 = v51:innerScope()
								v54 = fn24(v53)
								v48.add("Containers", v54, arg.Title)
							end
						end)

						v51:insert(function()
							v48.remove("Containers", arg.Title)
						end)

						local v56 = v43(instance.Parent.section)

						tbl14.AddSection = function(arg2, arg3)
							local tbl15 = {}

							local v57 = v46.registerSection({
								title = arg3.Title,
								order = tbl14.nSections,
								kind = "tab",
								side = arg3.Side or tbl14.nSections % 2 == 0 and "left" or "right",
								windowTitle = tbl14.AgentContext and tbl14.AgentContext.windowTitle or "",
								categoryId = tbl14.AgentContext and tbl14.AgentContext.categoryId or nil,
								categoryTitle = tbl14.AgentContext and tbl14.AgentContext.categoryTitle or "",
								tabId = tbl14.AgentContext and tbl14.AgentContext.tabId or nil,
								tabTitle = tbl14.AgentContext and tbl14.AgentContext.tabTitle or arg.Title,
							})

							tbl15.Component = v56({
								Title = arg3.Title,
								Order = tbl14.nSections,
								Collapsed = arg3.Collapsed,
								Scope = v51,
							})
							tbl15.Container = tbl15.Component.Components
							tbl15.Scope = tbl15.Component.Scope
							tbl15.Side = arg3.Side or tbl14.nSections % 2 == 0 and "left" or "right"

							tbl15.AgentContext = {
								windowTitle = tbl14.AgentContext and tbl14.AgentContext.windowTitle or "",
								categoryId = tbl14.AgentContext and tbl14.AgentContext.categoryId or nil,
								categoryTitle = tbl14.AgentContext and tbl14.AgentContext.categoryTitle or "",
								tabId = tbl14.AgentContext and tbl14.AgentContext.tabId or nil,
								tabTitle = tbl14.AgentContext and tbl14.AgentContext.tabTitle or arg.Title,
								sectionId = v57.id,
								sectionTitle = v57.title,
								sectionKind = v57.kind,
								side = tbl15.Side,
							}

							v45(tbl14.Sections, tbl15.Component)

							if tbl15.Side == "right" then
								v45(tbl14.RightSections, tbl15.Component)
							else
								v45(tbl14.LeftSections, tbl15.Component)
							end

							tbl14.nSections += 1
							setmetatable(tbl15, v52)
							return tbl15
						end

						tbl14.SetLayoutMode = function(arg2, arg3)
							if arg3 == "vertical" or arg3 == "horizontal" then
								tbl14.LayoutMode:set(arg3)
							end
						end

						return tbl14
					end
				end)()
			)
		end,
		[83] = function()
			local v, instance, v43 = fn23(83)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local children = v44.Children
					local v45 = v43(instance.Parent.Parent.Parent.packages.states)
					local v46 = v43(instance.Parent.Parent.Parent.utils.services)
					local userInputService = v46.UserInputService
					local runService = v46.RunService
					local v47 = v43(instance.Parent.Parent.Parent.storage.theme)
					local v48 = v43(instance.Parent.Parent.Parent.Internal)
					local v49 = v43(instance.Parent.Parent.Parent.utils.perf)
					local scope = v48.Scope
					local peek = v44.peek
					local n = 0.98
					local n27 = 0.3
					local v50 = 0.01

					return function(arg)
						local v51 = (arg.Scope or scope):innerScope()
						local v52 = v51:Value(false)
						local v53 = v51:Value(UDim2.fromOffset(0, 0))
						local v54 = v51:Value(Vector2.new(100, 22))
						local v55 = v51:Value()

						local v56 = v51:Computed(function(arg2)
							local n28

							if arg2(v52) then
								n28 = 1
							else
								n28 = 0
							end

							return n28
						end)

						local v57 = v51:Spring(v56, 36, 1)

						local v58 = v51:Computed(function(arg2)
							if not arg2(v45.AnimationsEnabled) then
								return arg2(v56)
							end
							return math.clamp(arg2(v57), 0, 1)
						end)

						local v59 = v51:Computed(function(arg2)
							if not arg2(v45.AnimationsEnabled) then
								local n28

								if arg2(v56) == 1 then
									n28 = 1
								else
									n28 = 0.98
								end

								return n28
							end

							return n + (1 - n) * arg2(v58)
						end)

						v55:set(v51:New("TextLabel")({
							Text = arg.Text or "Tooltip",
							TextSize = 12,
							FontFace = Font.new("rbxassetid://12187365364"),
							Size = UDim2.fromOffset(0, 0),
							Position = UDim2.fromOffset(0, 0),
							TextWrapped = false,
							Visible = false,
							Parent = peek(v45.Library).GUI,
						}))

						local Frame = v51:New("Frame")

						local childrens = {
							Name = "Tooltip",
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ClipsDescendants = false,
							AutomaticSize = Enum.AutomaticSize.None,
							Size = v51:Computed(function(arg2)
								local v60 = arg2(v54)
								return UDim2.fromOffset(v60.X, v60.Y)
							end),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = v51:Computed(function(arg2)
								local v60 = arg2(v53)
								local viewportSize = workspace.CurrentCamera.ViewportSize
								local v61 = arg2(v54)
								local offset = v60.Y.Offset
								local y = v61.Y / 2
								return UDim2.fromOffset(
									math.clamp(v60.X.Offset, 10, math.max(10, viewportSize.X - v61.X - 10)) + v61.X / 2,
									math.clamp(offset, 10, math.max(10, viewportSize.Y - v61.Y - 10)) + y
								)
							end),
							Visible = v51:Computed(function(arg2)
								return arg2(v52) or arg2(v58) > v50
							end),
							ZIndex = 1000,
							Parent = peek(v45.Library).GUI,
						}

						local children2 = children
						local tbl14 = {}

						local v60 = v51:New("Frame")({
							Name = "Surface",
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							BackgroundColor3 = v47.BgPrimaryHighlight,
							BackgroundTransparency = v51:Computed(function(arg2)
								return 1 - math.clamp(arg2(v58), 0, 1)
							end),
							BorderSizePixel = 0,
							Size = v51:Computed(function(arg2)
								local v60 = arg2(v54)
								local v61 = arg2(v59)
								return UDim2.fromOffset(
									math.max(1, math.round(v60.X * v61)),
									math.max(1, math.round(v60.Y * v61))
								)
							end),
							ZIndex = 1000,
							[children] = {
								v51:New("UICorner")({ CornerRadius = UDim.new(0, 3) }),
								v51:New("UIStroke")({
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									Color = v47.BgTertiary,
									Thickness = 1,
									Transparency = v51:Computed(function(arg2)
										return 1 - arg2(v58) * (1 - n27)
									end),
								}),
							},
						})

						local TextLabel = v51:New("TextLabel")

						local childrens2 = {
							Text = arg.Text or "Tooltip",
							TextColor3 = v47.FgSecondary,
							TextTransparency = v51:Computed(function(arg2)
								return 1 - math.clamp(arg2(v58), 0, 1)
							end),
							TextSize = 12,
							FontFace = Font.new("rbxassetid://12187365364"),
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.None,
							Size = UDim2.fromScale(1, 1),
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextWrapped = true,
							ZIndex = 1001,
						}

						childrens2[children] = {
							v51:New("UIPadding")({
								PaddingLeft = UDim.new(0, 6),
								PaddingRight = UDim.new(0, 6),
								PaddingTop = UDim.new(0, 3),
								PaddingBottom = UDim.new(0, 3),
							}),
						}

						local v61 = TextLabel(childrens2)
						local v62 = table.pack(
							v51:New("UISizeConstraint")({
								MinSize = Vector2.new(0, 16),
								MaxSize = Vector2.new(300, 200),
							})
						)
						tbl14[1] = v60
						tbl14[2] = v61

						do
							local values = table.pack(table.unpack(v62, 1, v62.n))
							table.move(values, 1, values.n, 3, tbl14)
						end

						childrens[children2] = tbl14
						local v63 = Frame(childrens)
						local vector22 = nil
						local text2 = nil

						local function getMeasureText()
							return v49.time("ui:tooltip:measureText", function()
								local text = arg.Text or "Tooltip"
								if text2 == text and vector22 then
									return vector22
								end
								text2 = text
								local guiObject = peek(v55)

								if guiObject then
									guiObject.Text = text
									local textSize = v46.TextService:GetTextSize(
										guiObject.Text,
										guiObject.TextSize,
										Enum.Font.Gotham,
										Vector2.new(300, 10000)
									)
									local x = textSize.X + 12
									local vector2 = Vector2.new(x, textSize.Y + 8)
									v54:set(vector2)
									guiObject.Size = UDim2.fromOffset(x, textSize.Y)
									vector22 = vector2
									return vector22
								end

								return nil
							end)
						end

						local function onRenderStepped()
							v49.profile("ui:tooltip:updatePosition", function()
								local reference = arg.Reference and peek(arg.Reference) or nil

								if reference and reference.Parent then
									local absolutePosition = reference.AbsolutePosition
									local absoluteSize = reference.AbsoluteSize
									v53:set(
										UDim2.fromOffset(
											absolutePosition.X + absoluteSize.X / 2 - peek(v54).X / 2,
											absolutePosition.Y + absoluteSize.Y + 6
										)
									)
								else
									local mouseLocation = userInputService:GetMouseLocation()
									local v64 = peek(v54)
									v53:set(
										UDim2.fromOffset(mouseLocation.X - v64.X / 2, mouseLocation.Y - 30 - v64.Y / 2)
									)
								end
							end)
						end

						getMeasureText()
						local connection = nil

						v51:Observer(v52):onChange(function()
							if peek(v52) then
								if not connection then
									onRenderStepped()
									local reference = arg.Reference and peek(arg.Reference) or nil

									if reference then
										local connections = {}
										table.insert(
											connections,
											reference
												:GetPropertyChangedSignal("AbsolutePosition")
												:Connect(onRenderStepped)
										)
										table.insert(
											connections,
											reference:GetPropertyChangedSignal("AbsoluteSize"):Connect(onRenderStepped)
										)

										connection = {
											Disconnect = function()
												for _, connection2 in ipairs(connections) do
													pcall(function()
														connection2:Disconnect()
													end)
												end
											end,
										}
									else
										connection = runService.RenderStepped:Connect(onRenderStepped)
									end
								end
							elseif connection then
								connection:Disconnect()
								connection = nil
							end
						end)

						local flag19 = false

						local function fn24()
							if flag19 then
								return
							end
							flag19 = true
							v51:doCleanup()
						end

						local function onDestroying()
							flag19 = true

							if connection then
								connection:Disconnect()
								connection = nil
							end
						end

						v51:insert(onDestroying)
						v51:insert(v63.Destroying:Connect(onDestroying))

						return {
							instance = v63,
							set_visible = function(arg2)
								if not flag19 then
									v52:set(arg2)
								end
							end,
							destroy = fn24,
						}
					end
				end)()
			)
		end,
		[84] = function()
			local v, instance, v43 = fn23(84)

			return (
				(function()
					local utils = instance.Parent.Parent.Parent.utils
					local v44 = v43(utils.animate)
					local v45 = v43(utils.insertitem)
					local v46 = v43(utils.services)
					local v47 = v43(utils.perf)
					local v48 = v43(utils.controlRegistry)
					local packages = instance.Parent.Parent.Parent.packages
					local v49 = v43(packages.fusion)
					local v50 = v43(packages.snapdragon)
					local v51 = v43(packages.states)
					local v52 = v43(instance.Parent.Parent.Parent.Internal)
					local v53 = v43(instance.Parent.pages.pageManager)
					local v54 = v43(instance.Parent.pages.mainPage)
					local v55 = v43(instance.Parent.pages.pageContainer)
					local v56 = v43(instance.Parent.dialog)
					local v57 = v43(instance.Parent.category)
					local v58 = v43(instance.Parent.section)
					local v59 = v43(instance.Parent.Parent.Parent.storage.theme)
					local windowModules = instance.Parent.window_modules
					local v60 = v43(windowModules.constants)
					local v61 = v43(windowModules.statusLogic)
					local v62 = v43(windowModules.statusView)
					local v63 = v43(windowModules.view)
					local v64 = v43(windowModules.responsive)
					local v65 = v43(windowModules.interactions.cursor)
					local v66 = v43(windowModules.interactions.resize)
					local v67 = v43(windowModules.interactions.drag)
					local v68 = v43(windowModules.interactions.keybind)
					local v69 = v43(windowModules.interactions.viewport)
					local v70 = v43(windowModules.robloxTopbarToggle)
					local scope = v52.Scope
					local children = v49.Children
					local peek = v49.peek
					local onEvent = v49.OnEvent
					local currentCamera = v46.Workspace.CurrentCamera
					local userInputService = v46.UserInputService
					local guiService = v46.GuiService
					local v71 = v43(instance.Parent.Parent.Parent.utils.images)
					local parts = instance.Parent.parts

					return function(arg)
						local v72 = (arg.Scope or scope):innerScope()
						local v73 = peek(v51.Library)
						local connections = v73.Connections

						local tbl14 = {
							ActionButtons = {},
							Categorys = 1,
							ClientControlContainer = { Sections = v72:Value(table.freeze({})), nSections = 0 },
							_dialogInitialized = false,
							Scope = v72,
						}

						local v74 = v53.new(v72)
						local mouseIconEnabled = userInputService.MouseIconEnabled
						local v75 = v72:Value(false)
						local v76 = v72:Value(false)
						local v77 = v72:Value(UDim2.fromOffset(0, 0))
						local v78 = v72:Value()
						local v79 = v72:Value()
						local v80 = v72:Value()
						local v81 = v72:Value()
						local insetArea = guiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
						local viewportSize = insetArea.Max - insetArea.Min

						if viewportSize.X <= 0 or viewportSize.Y <= 0 then
							viewportSize = currentCamera.ViewportSize
						end

						local v82 = v72:Value(
							v64.fitWindowSize(v64.resolveSize(arg.Size, viewportSize), viewportSize, v60.Window)
						)
						local v83 = v72:Value(false)
						local v84 = v72:Value(false)
						local v85 = v72:Value(false)
						local v86 = v72:Value(false)
						local v87 = v72:Value(1)
						local v88 = v72:Value(Vector2.new(arg.Size.X.Offset, arg.Size.Y.Offset))

						local v89 = v72:Computed(function(arg2)
							return v64.isCompact(arg2(v82), v60.Window)
						end)

						local v90 = v72:Value(false)
						local v91 = v72:Value(false)

						local v92 = v72:Computed(function(arg2)
							if arg2(v89) then
								return not arg2(v91)
							end
							return arg2(v90)
						end)

						local v93 = v72:Value(false)
						local v94 = peek(v89)

						v72:Observer(v89):onChange(function()
							local v95 = peek(v89)

							if v95 and not v94 then
								v91:set(false)
							end

							v94 = v95
						end)

						local v95 =
							v61({ scope = v72, States = v51, peek = peek, validStatusTypes = v60.Status.ValidTypes })

						v74:RegisterPage("main", {
							title = "Main",
							component = function(arg2)
								return v54({
									Scope = arg2,
									Window = tbl14,
									isTablistCollapsed = v92,
									isCompact = v89,
									statuses = v95.statuses,
									CreateStatusIndicator = function(arg3, arg4, arg5)
										return v62.createStatusIndicator(arg3, v59, children, arg4, arg5)
									end,
								})
							end,
							showTablist = true,
							showContainers = true,
							breadcrumbPath = {},
						})

						v74:NavigateTo("main", false)
						local flag19 = false

						tbl14.Minimize = function()
							v47.mark("window:minimize")

							v47.profile("window:minimize", function()
								local flag20 = not peek(v75)
								v75:set(flag20)

								if not flag20 and not flag19 then
									flag19 = true
									local str7 = v73.MinimizeKeybind and v73.MinimizeKeybind.Value or nil
									local str8

									if userInputService.TouchEnabled then
										str8 =
											"Tap the Courage button in the Roblox topbar to toggle the interface again."
									elseif str7 and str7 ~= "" and str7 ~= "Unknown" then
										str8 = "Click the Courage button in the Roblox topbar or press "
											.. tostring(str7)
											.. " to toggle the interface again."
									else
										str8 =
											"Click the Courage button in the Roblox topbar to toggle the interface again."
									end

									v73:Notify({
										Title = "Interface Minimized",
										Description = str8,
										Duration = 6,
										Type = "info",
									})
								end
							end)
						end

						local resizeWindowToViewport = v69.createResizeWindowToViewport({
							props = arg,
							Camera = currentCamera,
							GuiService = guiService,
							Size = v82,
							peek = peek,
							constants = v60,
						})

						local v96 = v63({
							scope = v72,
							Theme = v59,
							Images = v71,
							Parts = parts,
							animate = v44,
							OnEvent = onEvent,
							Children = children,
							Window = tbl14,
							props = arg,
							openedState = v75,
							Size = v82,
							isCompact = v89,
							isDragging = v93,
							Resizing = v80,
							ResizePos = v81,
							InitialResizeSize = v88,
							TopbarRef = v78,
							ResizeRef = v79,
							MinimizeHovering = v83,
							MinimizeHeldDown = v84,
							CloseHovering = v85,
							CloseHeldDown = v86,
							isTablistCollapsed = v92,
							pageManager = v74,
							initialPosition = resizeWindowToViewport(),
							Library = v73,
							PageContainer = v55,
							peek = peek,
						})

						tbl14.Dialog = function(arg2, arg3)
							if not tbl14._dialogInitialized then
								tbl14._dialogInitialized = true
								v56:init(v96.Root, v72)
							end

							return (v56:Create(arg3))
						end

						tbl14.WindowContainer = v96.WindowContainer
						tbl14.RootFrame = v96.Root
						v51.add("Objects", v96.WindowContainer, arg.Title)

						v65({
							scope = v72,
							UserInputService = userInputService,
							openedState = v75,
							cursorVisible = v76,
							cursorPosition = v77,
							initialCursorState = mouseIconEnabled,
							WindowRoot = v96.Root,
							connections = connections,
							peek = peek,
							constants = v60,
							createCursor = function(arg2)
								v51.add(
									"Objects",
									arg2:New("ImageLabel")({
										Name = "Cursor",
										Image = v71.Cursor,
										ImageColor3 = v59.AccentPrimary,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Position = v77,
										Size = UDim2.fromOffset(v60.Cursor.Size.X, v60.Cursor.Size.Y),
										Visible = v76,
										ZIndex = v60.Cursor.ZIndex,
									}),
									"Cursor"
								)
							end,
						})

						v66({
							scope = v72,
							UserInputService = userInputService,
							Camera = currentCamera,
							GuiService = guiService,
							Resizing = v80,
							ResizePos = v81,
							InitialResizeSize = v88,
							Size = v82,
							peek = peek,
							constants = v60,
						})

						v69.bindViewportResize({
							Camera = currentCamera,
							WindowContainer = v96.WindowContainer,
							isDragging = v93,
							Resizing = v80,
							resizeWindowToViewport = resizeWindowToViewport,
							peek = peek,
							constants = v60,
							openedState = v75,
							scope = v72,
						})

						v67({
							scope = v72,
							Snapdragon = v50,
							TopbarRef = v78,
							WindowContainer = v96.WindowContainer,
							isDragging = v93,
							openedState = v75,
							peek = peek,
						})

						v68({
							UserInputService = userInputService,
							connections = connections,
							Library = v73,
							Window = tbl14,
						})
						local flag20 = false
						local v97 = nil

						tbl14.SetSilentMode = function(arg2, arg3)
							if v97 then
								v97:SetEnabled(userInputService.TouchEnabled or not arg3)
							end
						end

						tbl14.Init = function()
							local v98 = peek(v51.Library)

							if v98.SaveManager then
								v98.SaveManager:LoadAutoloadConfig()
							end

							if not flag20 then
								flag20 = true
								local ok, result = pcall(game.GetService, game, "CoreGui")
								local v99 = nil

								if not ok then
									result = v99
								end

								if result then
									v97 = v70({
										scope = v72,
										Theme = v59,
										Children = children,
										OnEvent = onEvent,
										CoreGui = result,
										openedState = v75,
										Window = tbl14,
									})
								end
							end

							tbl14:SetSilentMode(v98.SilentMode)

							if not v98.SilentMode then
								v75:set(true)
							end
						end

						tbl14.AddCategory = function(arg2, arg3)
							local v98 = v57({
								Title = arg3.Title,
								Order = tbl14.Categorys,
								Scope = v72,
								IsTablistCollapsed = v92,
								IsCompact = v89,
								OnTabSelected = function()
									if peek(v89) then
										v91:set(false)
									end
								end,
							})

							local v99 = v48.registerCategory({
								title = arg3.Title,
								order = tbl14.Categorys,
								windowTitle = arg.Title,
							})
							v98.AgentContext =
								{ windowTitle = arg.Title, categoryId = v99.id, categoryTitle = v99.title }
							v51.add("Categorys", v98.Root, arg3.Title)
							tbl14.Categorys += 1
							return v98
						end

						tbl14.SetScale = function(arg2, arg3)
							v87:set(arg3)
						end

						tbl14.SetConnectionStatus = function(arg2, arg3, arg4)
							v95.setConnectionStatus(arg3, arg4)
						end

						tbl14.ToggleTablist = function()
							if peek(v89) then
								v91:set(not peek(v91))
							else
								v90:set(not peek(v90))
							end
						end

						tbl14.NavigateTo = function(arg2, arg3)
							return v74:NavigateTo(arg3)
						end

						tbl14.NavigateBack = function()
							return v74:NavigateBack()
						end

						tbl14.RegisterPage = function(arg2, arg3, arg4)
							return v74:RegisterPage(arg3, arg4)
						end

						tbl14.GetCurrentPage = function()
							return v74:GetCurrentPage()
						end

						tbl14.GetPageManager = function()
							return v74
						end

						tbl14.AddTag = function(arg2, arg3)
							local Frame = v72:New("Frame")

							local childrens = {
								Name = "TagHolder",
								AutomaticSize = Enum.AutomaticSize.X,
								BackgroundColor3 = v59.AccentPrimary,
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.fromOffset(0, 15),
							}

							local children2 = children
							local tbl15 = {}

							local v98 = v72:New("TextLabel")({
								Name = "TagTitle",
								FontFace = Font.new(
									"rbxassetid://12187365364",
									Enum.FontWeight.Medium,
									Enum.FontStyle.Normal
								),
								Text = arg3 or "TAG",
								TextColor3 = v59.FgTertiary,
								TextSize = 12,
								AutomaticSize = Enum.AutomaticSize.X,
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 1),
							})

							local v99 = v72:New("UIPadding")({
								Name = "UIPadding",
								PaddingLeft = UDim.new(0, 5),
								PaddingRight = UDim.new(0, 5),
							})
							local v100 = v72:New("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 4) })
							local v101 = table.pack(
								v72:New("UIStroke")({ Name = "UIStroke", Color = v59.BgTertiary, Thickness = 1.75 })
							)

							tbl15[1] = v98
							tbl15[2] = v99
							tbl15[3] = v100

							do
								local values = table.pack(table.unpack(v101, 1, v101.n))
								table.move(values, 1, values.n, 4, tbl15)
							end

							childrens[children2] = tbl15
							local instance2 = Frame(childrens)
							instance2.Parent = peek(v78).TextHolder
							return instance2
						end

						tbl14.AddStatus = function(arg2, arg3, arg4, arg5)
							return v95.addStatus(arg3, arg4, arg5)
						end

						tbl14.AddClientControlSection = function(arg2, arg3)
							local v98 = v48.registerSection({
								title = arg3.Title,
								order = tbl14.ClientControlContainer.nSections,
								kind = "client_control",
								windowTitle = arg.Title,
							})

							local tbl15 = {
								Component = v58({
									Title = arg3.Title,
									Order = tbl14.ClientControlContainer.nSections,
									Scope = v72,
								}),
							}
							tbl15.Container = tbl15.Component.Components
							tbl15.Scope = tbl15.Component.Scope
							tbl15.AgentContext = {
								windowTitle = arg.Title,
								sectionId = v98.id,
								sectionTitle = v98.title,
								sectionKind = v98.kind,
							}
							local v99 = tbl15.Component:Render(v72)
							v45(tbl14.ClientControlContainer.Sections, v99)
							local clientControlContainer = tbl14.ClientControlContainer
							clientControlContainer.nSections += 1
							local v100 = peek(v51.Elements)
							setmetatable(tbl15, v100)
							return tbl15
						end

						v52.Maid:GiveTask(function()
							pcall(function()
								userInputService.MouseIconEnabled = mouseIconEnabled
							end)
						end)

						return tbl14
					end
				end)()
			)
		end,
		[86] = function()
			fn23(86)

			return (function()
				local freeze = table.freeze

				return table.freeze({
					Status = table.freeze({
						ValidTypes = table.freeze({ success = true, info = true, warning = true, danger = true }),
					}),
					Window = table.freeze({
						MinSize = Vector2.new(400, 300),
						ResizeMax = Vector2.new(2048, 2048),
						ViewportScale = 0.85,
						ViewportMargin = 12,
						CompactBreakpoint = 640,
						SidebarWidth = 200,
						CompactSidebarWidth = 180,
						CompactAuxSidebarWidth = 136,
						ResizeThrottle = 0.1,
					}),
					Cursor = freeze({ Offset = Vector2.new(7, 0), Size = Vector2.new(24, 24), ZIndex = 9999 }),
				})
			end)()
		end,
		[88] = function()
			local v, instance, v43 = fn23(88)

			return (
				(function()
					return function(arg)
						local scope = arg.scope
						local userInputService = arg.UserInputService
						local openedState = arg.openedState
						local cursorVisible = arg.cursorVisible
						local cursorPosition = arg.cursorPosition
						local initialCursorState = arg.initialCursorState
						local windowRoot = arg.WindowRoot
						local connections = arg.connections
						local peek = arg.peek
						local constants = arg.constants
						local createCursor = arg.createCursor
						local v44 = v43(instance.Parent.Parent.Parent.Parent.Parent.utils.perf)
						local v45 = v43(instance.Parent.Parent.Parent.Parent.Parent.utils.pendingTasks)
						local connection = nil
						local v46 = nil

						local function fn24()
							if connection then
								connection:Disconnect()
								connection = nil
							end
						end

						local function fn25()
							if connection then
								return
							end

							connection = userInputService.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement then
									if not peek(openedState) or not peek(cursorVisible) then
										return
									end
									v44.mark("input:cursor")
									local mouseLocation = userInputService:GetMouseLocation()
									cursorPosition:set(
										UDim2.fromOffset(
											mouseLocation.X - constants.Cursor.Offset.X,
											mouseLocation.Y - constants.Cursor.Offset.Y
										)
									)
								end
							end)
						end

						scope:Observer(openedState):onChange(function()
							if not peek(openedState) then
								fn24()

								if v46 then
									v46:doCleanup()
									v46 = nil
								end

								v45.defer(function()
									pcall(function()
										userInputService.MouseIconEnabled = initialCursorState
									end)
								end)

								cursorVisible:set(false)
							else
								if not v46 then
									v46 = scope:innerScope()
									createCursor(v46)
								end

								fn25()
							end
						end)

						table.insert(
							connections,
							windowRoot.MouseEnter:Connect(function()
								if peek(openedState) then
									pcall(function()
										userInputService.MouseIconEnabled = false
									end)

									cursorVisible:set(true)
								end
							end)
						)

						table.insert(
							connections,
							windowRoot.MouseLeave:Connect(function()
								pcall(function()
									userInputService.MouseIconEnabled = initialCursorState
								end)

								cursorVisible:set(false)
							end)
						)

						table.insert(scope, function()
							fn24()

							if v46 then
								v46:doCleanup()
								v46 = nil
							end
						end)
					end
				end)()
			)
		end,
		[89] = function()
			fn23(89)

			return (
				(function()
					return function(arg)
						local scope = arg.scope
						local snapdragon = arg.Snapdragon
						local topbarRef = arg.TopbarRef
						local windowContainer = arg.WindowContainer
						local isDragging = arg.isDragging
						local openedState = arg.openedState
						local peek = arg.peek
						local connections = {}
						local dragController = nil

						local function fn24(arg2)
							if typeof(arg2) == "table" and arg2.type == "State" then
								return peek(arg2)
							end
							return arg2
						end

						local function fn25()
							if dragController then
								dragController:Disconnect()
								dragController = nil
							end

							for _, connection in ipairs(connections) do
								pcall(function()
									connection:Disconnect()
								end)
							end

							connections = {}
							isDragging:set(false)
						end

						local function fn26()
							if dragController then
								return
							end
							local v = fn24(topbarRef)
							local v43 = fn24(windowContainer)
							if not v or not v43 then
								return
							end
							dragController = snapdragon.createDragController(v, { DragGui = v43, SnapEnabled = true })
							dragController:Connect()

							table.insert(
								connections,
								dragController.DragBegan:Connect(function()
									isDragging:set(true)
								end)
							)

							table.insert(
								connections,
								dragController.DragEnded:Connect(function()
									isDragging:set(false)
								end)
							)
						end

						scope:Observer(openedState):onChange(function()
							if peek(openedState) then
								fn26()
							else
								fn25()
							end
						end)

						if peek(openedState) then
							fn26()
						end

						table.insert(scope, function()
							fn25()
						end)
					end
				end)()
			)
		end,
		[90] = function()
			fn23(90)

			return (
				(function()
					return function(arg)
						local userInputService = arg.UserInputService
						local library = arg.Library
						local window = arg.Window

						table.insert(
							arg.connections,
							userInputService.InputEnded:Connect(function(input)
								if
									type(library.MinimizeKeybind) == "table"
									and library.MinimizeKeybind.Type == "Keybind"
									and not userInputService:GetFocusedTextBox()
								then
									if input.KeyCode.Name == library.MinimizeKeybind.Value then
										window:Minimize()
									end
								elseif
									input.KeyCode == library.MinimizeKey and not userInputService:GetFocusedTextBox()
								then
									window:Minimize()
								end
							end)
						)
					end
				end)()
			)
		end,
		[91] = function()
			local v, instance, v43 = fn23(91)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.responsive)

					return function(e)
						local M = e.scope
						local x = e.UserInputService
						local O = e.Camera
						local R = e.GuiService
						local d = e.Resizing
						local p = e.ResizePos
						local I = e.InitialResizeSize
						local E = e.Size
						local w = e.peek
						local S = e.constants
						local e = v43(instance.Parent.Parent.Parent.Parent.Parent.utils.perf)
						local f, a, n

						local function Q()
							if a then
								a:Disconnect()
								a = nil
							end

							if n then
								n:Disconnect()
								n = nil
							end

							f = nil
						end

						local function Z()
							if a or n then
								return
							end

							a = x.InputChanged:Connect(function(a)
								if
									(a.UserInputType == Enum.UserInputType.MouseMovement)
									or (a.UserInputType == Enum.UserInputType.Touch)
								then
									e.mark("input:resize")
									local e, t = w(I), w(p)
									local p = a.Position - t
									local I, a =
										e + Vector2.new(p.X, p.Y), R:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
									e = a.Max - a.Min
									local R = e.X <= 0
									a = v44.clampResizeSize(I, if R or (e.Y <= 0) then O.ViewportSize else e, S.Window)

									if ((f == nil) or (a.X ~= f.X)) or (a.Y ~= f.Y) then
										f = a
										E:set(a)
									end
								end
							end)

							n = x.InputEnded:Connect(function(g)
								if
									(g.UserInputType == Enum.UserInputType.MouseButton1)
									or (g.UserInputType == Enum.UserInputType.Touch)
								then
									d:set(false)
								end
							end)
						end

						M:Observer(d):onChange(function()
							if w(d) then
								Z()
							else
								Q()
							end
						end)

						if w(d) then
							Z()
						end

						table.insert(M, function()
							Q()
						end)
					end
				end)()
			)
		end,
		[92] = function()
			local v, instance, v43 = fn23(92)

			return (function()
				local v44 = v43(instance.Parent.Parent.responsive)

				return table.freeze({
					createResizeWindowToViewport = function(e)
						local M, x, O, R, d, p = e.props, e.Camera, e.GuiService, e.Size, e.peek, e.constants

						return function()
							local e = O:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
							local O = e.Max - e.Min
							O = if (O.X <= 0) or (O.Y <= 0) then x.ViewportSize else O
							e = v44.resolveSize(M.Size, O)
							local M, x = v44.fitWindowSize(e, O, p.Window), d(R)

							if (x.X ~= M.X) or (x.Y ~= M.Y) then
								R:set(M)
							end

							return UDim2.fromOffset((O.X / 2) - (M.X / 2), (O.Y / 2) - (M.Y / 2))
						end
					end,
					bindViewportResize = function(g)
						local e, M, x, O, R, d, p, I, E, w, S =
							g.Camera,
							g.WindowContainer,
							g.isDragging,
							g.Resizing,
							g.resizeWindowToViewport,
							g.peek,
							g.constants,
							g.openedState,
							g.scope,
							0
						local function g()
							if S then
								S:Disconnect()
								S = nil
							end
						end
						local function f()
							if S then
								return
							end
							S = e:GetPropertyChangedSignal("ViewportSize"):Connect(function()
								local e = os.clock()
								if e - w < p.Window.ResizeThrottle then
									return
								end
								w = e
								if not d(x) and not d(O) then
									M.Position = R()
								end
							end)
						end
						E:Observer(I):onChange(function()
							if d(I) then
								f()
							else
								g()
							end
						end)
						f()
						table.insert(E, function()
							g()
						end)
					end,
				})
			end)()
		end,
		[93] = function()
			fn23(93)

			return (function()
				local tbl14

				tbl14 = {
					resolveSize = function(arg, arg2)
						return Vector2.new(arg.X.Scale * arg2.X + arg.X.Offset, arg.Y.Scale * arg2.Y + arg.Y.Offset)
					end,
					getAvailableSize = function(arg, arg2)
						local n = math.max(0, arg2 or 0) * 2
						return Vector2.new(math.max(1, arg.X - n), math.max(1, arg.Y - n))
					end,
					fitWindowSize = function(arg, arg2, arg3)
						local availableSize = tbl14.getAvailableSize(arg2, arg3.ViewportMargin)
						local minSize = arg3.MinSize
						local viewportScale = arg3.ViewportScale
						local n = math.min(minSize.X, availableSize.X)
						local n27 = math.min(minSize.Y, availableSize.Y)
						local n28 = math.min(arg.X, arg2.X * viewportScale)
						local n29 = math.min(arg.Y, arg2.Y * viewportScale)
						local n30 = math.max(n, math.min(availableSize.X, n28))
						local n31 = math.max(n27, math.min(availableSize.Y, n29))
						return Vector2.new(math.clamp(arg.X, n, n30), math.clamp(arg.Y, n27, n31))
					end,
					clampResizeSize = function(arg, arg2, arg3)
						local availableSize = tbl14.getAvailableSize(arg2, arg3.ViewportMargin)
						local minSize = arg3.MinSize
						local resizeMax = arg3.ResizeMax
						local n = math.min(minSize.X, availableSize.X)
						local n27 = math.min(minSize.Y, availableSize.Y)
						local n28 = math.max(n, math.min(resizeMax.X, availableSize.X))
						local n29 = math.max(n27, math.min(resizeMax.Y, availableSize.Y))
						return Vector2.new(math.clamp(arg.X, n, n28), math.clamp(arg.Y, n27, n29))
					end,
					isCompact = function(arg, arg2)
						return arg.X < arg2.CompactBreakpoint
					end,
				}

				return table.freeze(tbl14)
			end)()
		end,
		[94] = function()
			local v, instance, v43 = fn23(94)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.Parent.utils.pendingTasks)
					local font = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
					local font2 = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
					local n = 32
					local v45 = 72
					local n27 = 140

					local function getStackedElements(instance2)
						local topBarApp = instance2:FindFirstChild("TopBarApp")
						topBarApp = topBarApp and topBarApp:FindFirstChild("TopBarApp")
						local unibarLeftFrame = topBarApp and topBarApp:FindFirstChild("UnibarLeftFrame")
						return unibarLeftFrame and unibarLeftFrame:FindFirstChild("StackedElements")
					end

					local function getStackedElements2(instance2)
						local topBarApp = instance2:WaitForChild("TopBarApp", 8)
						if not topBarApp then
							return nil
						end
						local topBarApp2 = topBarApp:WaitForChild("TopBarApp", 8)
						local unibarLeftFrame = topBarApp2 and topBarApp2:WaitForChild("UnibarLeftFrame", 8)
						return unibarLeftFrame and unibarLeftFrame:WaitForChild("StackedElements", 8)
					end

					local function fn24(instance2)
						if
							(instance2:IsA("TextLabel") or instance2:IsA("TextButton"))
							and instance2.Visible
							and instance2.Text ~= ""
						then
							return true
						end

						for _, descendant in ipairs(instance2:GetDescendants()) do
							if
								(descendant:IsA("TextLabel") or descendant:IsA("TextButton"))
								and descendant.Visible
								and descendant.Text ~= ""
							then
								return true
							end
						end

						return false
					end

					local function fn25(instance2)
						local n28 = 0
						local parent2 = nil
						local child = nil

						for _, descendant in ipairs(instance2:GetDescendants()) do
							if not descendant:IsA("UIListLayout") then
								continue
							end
							local parent = descendant.Parent
							if not (parent and parent:IsA("GuiObject") and parent.AbsoluteSize.X >= n27) then
								continue
							end
							local children = {}

							for _, child2 in ipairs(parent:GetChildren()) do
								if
									child2:IsA("GuiObject")
									and child2.Name ~= "CourageSuiteMenuItem"
									and child2.Visible
									and child2.AbsoluteSize.Y >= n
									and child2.AbsoluteSize.Y <= v45
									and fn24(child2)
								then
									table.insert(children, child2)
								end
							end

							if #children >= 2 then
								local n29 = #children * 100 + math.min(parent.AbsoluteSize.X, 400)

								if n29 > n28 then
									child = children[#children]
									n28 = n29
									parent2 = parent
								end
							end
						end

						return parent2, child
					end

					local function createTextButton(parent, guiObject, window)
						local courageSuiteMenuItem = Instance.new("TextButton")
						courageSuiteMenuItem.Name = "CourageSuiteMenuItem"
						courageSuiteMenuItem.Active = true
						courageSuiteMenuItem.AutoButtonColor = true
						courageSuiteMenuItem.BackgroundColor3 = Color3.fromRGB(28, 29, 34)
						courageSuiteMenuItem.BackgroundTransparency = 0
						courageSuiteMenuItem.BorderSizePixel = 0
						courageSuiteMenuItem.LayoutOrder = 1
						courageSuiteMenuItem.Size = UDim2.new(1, 0, 0, guiObject.AbsoluteSize.Y)
						courageSuiteMenuItem.Text = ""
						courageSuiteMenuItem.ZIndex = guiObject.ZIndex

						local uiCorner = Instance.new("UICorner")
						uiCorner.CornerRadius = UDim.new(0, 6)
						uiCorner.Parent = courageSuiteMenuItem

						local courageMark = Instance.new("TextLabel")
						courageMark.Name = "CourageMark"
						courageMark.AnchorPoint = Vector2.new(0, 0.5)
						courageMark.BackgroundTransparency = 1
						courageMark.FontFace = font
						courageMark.Position = UDim2.new(0, 12, 0.5, 0)
						courageMark.Size = UDim2.fromOffset(24, 24)
						courageMark.Text = "C"
						courageMark.TextColor3 = Color3.fromRGB(245, 245, 250)
						courageMark.TextSize = 20
						courageMark.ZIndex = courageSuiteMenuItem.ZIndex + 1
						courageMark.Parent = courageSuiteMenuItem

						local courageMenuLabel = Instance.new("TextLabel")
						courageMenuLabel.Name = "CourageMenuLabel"
						courageMenuLabel.BackgroundTransparency = 1
						courageMenuLabel.FontFace = font2
						courageMenuLabel.Position = UDim2.fromOffset(48, 0)
						courageMenuLabel.Size = UDim2.new(1, -60, 1, 0)
						courageMenuLabel.Text = "Courage Hub"
						courageMenuLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
						courageMenuLabel.TextTransparency = 0
						courageMenuLabel.TextSize = 16
						courageMenuLabel.TextXAlignment = Enum.TextXAlignment.Left
						courageMenuLabel.ZIndex = courageSuiteMenuItem.ZIndex + 1
						courageMenuLabel.Parent = courageSuiteMenuItem

						courageSuiteMenuItem.Activated:Connect(function()
							window:Minimize()
						end)

						courageSuiteMenuItem.Parent = parent
						return courageSuiteMenuItem
					end

					return function(arg)
						local v46 = arg.scope:innerScope()
						local theme = arg.Theme
						local children = arg.Children
						local onEvent = arg.OnEvent
						local openedState = arg.openedState
						local window = arg.Window
						local flag19 = true
						local flag20 = false
						local visible = true
						local flag21 = false
						local instance2 = nil
						local courageSuiteMenuItem2 = nil

						v46:insert(function()
							flag19 = false

							if courageSuiteMenuItem2 and courageSuiteMenuItem2.Parent then
								courageSuiteMenuItem2:Destroy()
							end
						end)

						local function fn26(topBarApp)
							if not flag19 then
								return
							end

							if not visible then
								if courageSuiteMenuItem2 and courageSuiteMenuItem2.Parent then
									courageSuiteMenuItem2:Destroy()
								end

								courageSuiteMenuItem2 = nil
								return
							end

							if courageSuiteMenuItem2 and courageSuiteMenuItem2.Parent then
								return
							end
							local instance3, v47 = fn25(topBarApp)
							if not instance3 or not v47 then
								return
							end
							local courageSuiteMenuItem = instance3:FindFirstChild("CourageSuiteMenuItem")
							if courageSuiteMenuItem then
								courageSuiteMenuItem2 = courageSuiteMenuItem
								return
							end
							courageSuiteMenuItem2 = createTextButton(instance3, v47, window)

							courageSuiteMenuItem2.Destroying:Connect(function()
								if courageSuiteMenuItem2 == instance3 then
									courageSuiteMenuItem2 = nil
								end
							end)
						end

						local function fn27(topBarApp)
							if flag21 or not flag19 or not visible then
								return
							end
							flag21 = true

							v44.defer(function()
								flag21 = false

								if flag19 then
									fn26(topBarApp)
								end
							end)
						end

						local function fn28(instance3)
							if flag20 or not flag19 or not instance3 or instance3.Parent == nil then
								return
							end
							flag20 = true

							local v47 = v46:New("TextButton")({
								Name = "CourageUIToggleButton",
								Active = true,
								AutoButtonColor = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = v46:Computed(function(arg2)
									if arg2(openedState) then
										return arg2(theme.AccentPrimary)
									end
									return arg2(theme.BgTertiary)
								end),
								BackgroundTransparency = v46:Computed(function(arg2)
									local n28

									if arg2(openedState) then
										n28 = 0.05
									else
										n28 = 0.12
									end

									return n28
								end),
								BorderSizePixel = 0,
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromOffset(36, 36),
								Text = "",
								ZIndex = 20,
								[onEvent("Activated")] = function()
									window:Minimize()
								end,
								[children] = {
									v46:New("UICorner")({ CornerRadius = UDim.new(0, 9) }),
									v46:New("UIStroke")({
										Color = v46:Computed(function(arg2)
											local v47

											if arg2(openedState) then
												v47 = arg2(theme.FgPrimary)
											else
												v47 = arg2(theme.AccentPrimary)
											end

											return v47
										end),
										Thickness = 1.25,
										Transparency = 0.2,
									}),
									v46:New("TextLabel")({
										Name = "CourageMark",
										BackgroundTransparency = 1,
										FontFace = font,
										Position = UDim2.fromOffset(0, 2),
										Size = UDim2.new(1, 0, 0, 22),
										Text = "C",
										TextColor3 = v46:Computed(function(arg2)
											local v47

											if arg2(openedState) then
												v47 = arg2(theme.FgPrimary)
											else
												v47 = arg2(theme.AccentPrimary)
											end

											return v47
										end),
										TextSize = 18,
										ZIndex = 21,
									}),
									v46:New("TextLabel")({
										Name = "ToggleLabel",
										BackgroundTransparency = 1,
										FontFace = font2,
										Position = UDim2.fromOffset(0, 22),
										Size = UDim2.new(1, 0, 0, 10),
										Text = "UI",
										TextColor3 = theme.FgSecondary,
										TextSize = 8,
										ZIndex = 21,
									}),
								},
							})

							instance2 = v46:New("Frame")({
								Name = "CourageUIToggle",
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								LayoutOrder = 1000,
								Size = UDim2.fromOffset(44, 44),
								Visible = visible,
								ZIndex = 20,
								Parent = instance3,
								[children] = { v47 },
							})

							local topBarApp = arg.CoreGui:FindFirstChild("TopBarApp")

							if topBarApp then
								v46:insert(topBarApp.DescendantAdded:Connect(function(descendant)
									if descendant.Name ~= "CourageSuiteMenuItem" then
										fn27(topBarApp)
									end
								end))

								fn27(topBarApp)
							end
						end

						local tbl14 = {
							SetEnabled = function(arg2, arg3)
								visible = arg3 == true

								if instance2 and instance2.Parent then
									instance2.Visible = visible
								end

								if not visible then
									if courageSuiteMenuItem2 and courageSuiteMenuItem2.Parent then
										courageSuiteMenuItem2:Destroy()
									end

									courageSuiteMenuItem2 = nil
									return
								end

								local topBarApp = arg.CoreGui:FindFirstChild("TopBarApp")

								if topBarApp then
									fn27(topBarApp)
								end
							end,
						}

						local stackedElements = getStackedElements(arg.CoreGui)
						if stackedElements then
							fn28(stackedElements)
							return tbl14
						end

						v44.spawn(function()
							local stackedElements2 = getStackedElements2(arg.CoreGui)

							if flag19 then
								fn28(stackedElements2)
							end
						end)

						return tbl14
					end
				end)()
			)
		end,
		[95] = function()
			local v, instance, v43 = fn23(95)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.Parent.utils.perf)
					local v45 = v43(instance.Parent.Parent.Parent.Parent.utils.pendingTasks)

					return function(arg)
						local scope = arg.scope
						local states = arg.States
						local peek = arg.peek
						local validStatusTypes = arg.validStatusTypes
						local v46 = scope:Value(table.freeze({}))
						local Disconnected = scope:Value("Disconnected")
						local danger = scope:Value("danger")
						local str7 = "Disconnected"
						local str8 = "danger"

						local function fn24()
							v44.profile("window:status:updateConnectionStatus", function()
								local str9, str10

								if peek(states.ServerConnected) then
									str9 = "Connected"
									str10 = "success"
								elseif peek(states.ServerAuthenticating) then
									str9 = "Authenticating..."
									str10 = "info"
								elseif peek(states.ServerConnecting) then
									str10 = "info"
									str9 = "Connecting..."
								else
									str9 = "Disconnected"
									str10 = "danger"
								end

								if str9 == str7 and str10 == str8 then
									return
								end
								str7 = str9
								str8 = str10
								Disconnected:set(str9)
								danger:set(str10)
								local v47 = peek(v46)
								local serverConnection = v47.server_connection
								if
									serverConnection
									and serverConnection.text == Disconnected
									and serverConnection.stateType == danger
								then
									return
								end
								local v48 = table.clone(v47)
								v48.server_connection = { text = Disconnected, stateType = danger }
								v46:set(table.freeze(v48))
							end)
						end

						scope:Observer(states.ServerConnected):onChange(fn24)
						scope:Observer(states.ServerAuthenticating):onChange(fn24)
						scope:Observer(states.ServerConnecting):onChange(fn24)
						local n = 0
						local v47 = nil

						local function fn25()
							if v47 then
								v45.cancel(v47)
							end

							v47 = v45.spawn(function()
								while peek(states.ServerConnecting) do
									v44.mark("window:status:connectingLoopWake")

									v44.profile("window:status:connectingAnimate", function()
										n = (n + 1) % 4
										Disconnected:set("Connecting" .. string.rep(".", n))
									end)

									task.wait(0.5)
								end

								v47 = nil
							end)
						end

						local function fn26()
							if v47 then
								v45.cancel(v47)
								v47 = nil
							end
						end

						scope:Observer(states.ServerConnecting):onChange(function()
							if peek(states.ServerConnecting) then
								fn25()
							else
								fn26()
							end
						end)

						table.insert(scope, function()
							fn26()
						end)

						local v48 = table.freeze({ server_connection = { text = Disconnected, stateType = danger } })
						v46:set(v48)

						return {
							statuses = v46,
							connectionStatusText = Disconnected,
							connectionStatusType = danger,
							addStatus = function(arg2, arg3, arg4)
								assert(
									type(arg2) == "string" and arg2 ~= "",
									"AddStatus requires a non-empty string key."
								)
								assert(type(arg3) == "string", "AddStatus requires initialText string.")
								local v49 = string.lower(arg4 or "info")
								assert(
									validStatusTypes[v49],
									("AddStatus received invalid stateType: %s. Valid types: success, info, warning, danger."):format(
										tostring(arg4)
									)
								)
								local v50 = peek(v46)

								if v50[arg2] then
									warn(
										("Status with key '%s' already exists. Overwriting is not directly supported, returning existing controls."):format(
											arg2
										)
									)
									local v51 = v50[arg2]

									return {
										SetText = function(arg5, arg6)
											v51.text:set(arg6)
										end,
										SetState = function(arg5, arg6)
											local v52 = string.lower(arg6 or "info")

											if validStatusTypes[v52] then
												v51.stateType:set(v52)
											else
												warn(("SetState received invalid stateType: %s"):format(tostring(arg6)))
											end
										end,
									}
								end

								local v51 = scope:Value(arg3)
								local v52 = scope:Value(v49)
								local v53 = table.clone(v50)
								v53[arg2] = { text = v51, stateType = v52 }
								v46:set(table.freeze(v53))

								return {
									SetText = function(arg5, arg6)
										assert(type(arg6) == "string", "SetText requires a string.")
										v51:set(arg6)
									end,
									SetState = function(arg5, arg6)
										local v54 = string.lower(arg6 or "info")
										assert(
											validStatusTypes[v54],
											("SetState received invalid stateType: %s. Valid types: success, info, warning, danger."):format(
												tostring(arg6)
											)
										)
										v52:set(v54)
									end,
									Destroy = function()
										local v54 = peek(v46)

										if v54[arg2] then
											local tbl14 = {}

											for k, v55 in pairs(v54) do
												if k ~= arg2 then
													tbl14[k] = v55
												end
											end

											v46:set(table.freeze(tbl14))
										end
									end,
								}
							end,
							setConnectionStatus = function(arg2, arg3)
								Disconnected:set(arg2)
								danger:set(arg3)
							end,
						}
					end
				end)()
			)
		end,
		[96] = function()
			fn23(96)

			return (function()
				local function fn24(arg, arg2, arg3)
					local v = string.lower(arg3 or "")
					if v == "success" then
						return arg(arg2.Success)
					end

					if v == "info" then
						return arg(arg2.AccentPrimary)
					end

					if v == "warning" then
						return arg(arg2.AccentCaution)
					end

					if v == "danger" then
						return arg(arg2.AccentDestructive)
					end
					return arg(arg2.FgTertiary)
				end

				return table.freeze({
					createStatusIndicator = function(arg, arg2, arg3, arg4, arg5)
						return arg:New("Frame")({
							Name = arg4,
							LayoutOrder = 0,
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.fromScale(0, 1),
							[arg3] = {
								arg:New("Frame")({
									Name = "IconStatus",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = UDim2.new(0, 5, 1, 0),
									[arg3] = {
										[arg3] = {
											arg:New("UIPadding")({ Name = "UIPadding", PaddingTop = UDim.new(0, 2) }),
										},
										arg:New("Frame")({
											Name = "IndicatorDot",
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = arg:Computed(function(arg6)
												return fn24(arg6, arg2, arg6(arg5.stateType))
											end),
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Position = UDim2.new(0.5, 0, 0.5, -1),
											Size = UDim2.fromOffset(6, 6),
											[arg3] = {
												arg:New("UICorner")({
													Name = "UICorner",
													CornerRadius = UDim.new(1, 0),
												}),
											},
										}),
									},
								}),
								arg:New("UIListLayout")({
									Name = "UIListLayout",
									FillDirection = Enum.FillDirection.Horizontal,
									SortOrder = Enum.SortOrder.LayoutOrder,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = UDim.new(0, 10),
								}),
								arg:New("TextLabel")({
									Name = "StatusText",
									FontFace = Font.new(
										"rbxassetid://12187365364",
										Enum.FontWeight.Medium,
										Enum.FontStyle.Normal
									),
									Text = arg5.text,
									TextColor3 = arg2.FgSecondary,
									TextSize = 12,
									AutomaticSize = Enum.AutomaticSize.X,
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = UDim2.fromScale(0, 1),
									[arg3] = {
										arg:New("UIPadding")({ Name = "UIPadding", PaddingTop = UDim.new(0, 1) }),
									},
								}),
								arg:New("Frame")({
									Name = "Seperator",
									BackgroundColor3 = arg2.BgTertiary,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = UDim2.new(0, -1, 1, 0),
								}),
							},
						})
					end,
				})
			end)()
		end,
		[97] = function()
			local v, v43, v44 = fn23(97)

			return (
				(function()
					return function(arg)
						local scope = arg.scope
						local theme = arg.Theme
						local images = arg.Images
						local parts = arg.Parts
						local animate = arg.animate
						local onEvent = arg.OnEvent
						local children = arg.Children
						local window = arg.Window
						local props = arg.props
						local openedState = arg.openedState
						local size = arg.Size
						local isDragging = arg.isDragging
						local resizing = arg.Resizing
						local resizePos = arg.ResizePos
						local initialResizeSize = arg.InitialResizeSize
						local topbarRef = arg.TopbarRef
						local resizeRef = arg.ResizeRef
						local minimizeHovering = arg.MinimizeHovering
						local minimizeHeldDown = arg.MinimizeHeldDown
						local closeHovering = arg.CloseHovering
						local closeHeldDown = arg.CloseHeldDown
						local isTablistCollapsed = arg.isTablistCollapsed
						local isCompact = arg.isCompact
						local pageManager = arg.pageManager
						local initialPosition = arg.initialPosition
						local library = arg.Library
						local pageContainer = arg.PageContainer
						local peek = arg.peek

						local parent = scope:New("Frame")({
							Name = "WindowContainer",
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = initialPosition,
							Size = scope:Computed(function(arg2)
								return UDim2.fromOffset(arg2(size).X, arg2(size).Y)
							end),
							Visible = openedState,
							[children] = { v44(parts.dropshadow)({ Scope = scope }) },
						})

						window.Root = scope:New("Frame")({
							Name = "GUI",
							BackgroundColor3 = theme.BgPrimary,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromOffset(0, 0),
							Size = UDim2.fromScale(1, 1),
							Visible = true,
							Active = false,
							Interactable = true,
							[children] = {
								scope:New("UICorner")({ Name = "UICorner", CornerRadius = UDim.new(0, 4) }),
								scope:New("UIStroke")({
									Name = "UIStroke",
									Color = theme.BgTertiary,
									Thickness = 2.5,
									Transparency = animate(function(arg2)
										if not arg2(openedState) then
											return 1
										end
										return arg2(isDragging) and 0.7 or 0.6
									end, 30, 1.2, scope),
								}),
								resizeRef:set(v44(parts.resizeHandle)({
									scope = scope,
									OnEvent = onEvent,
									Resizing = resizing,
									ResizePos = resizePos,
									InitialResizeSize = initialResizeSize,
									Size = size,
									peek = peek,
									IsCompact = isCompact,
								})),
								topbarRef:set(v44(parts.topbar)({
									scope = scope,
									Theme = theme,
									Images = images,
									animate = animate,
									Window = window,
									MinimizeHovering = minimizeHovering,
									MinimizeHeldDown = minimizeHeldDown,
									peek = peek,
									OnEvent = onEvent,
									Title = props.Title,
									Tag = props.Tag,
									CloseHovering = closeHovering,
									CloseHeldDown = closeHeldDown,
									Library = library,
									IsTablistCollapsed = isTablistCollapsed,
									IsCompact = isCompact,
									pageManager = pageManager,
								})),
								scope:New("Frame")({
									Name = "PageContent",
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Position = UDim2.fromOffset(0, 45),
									Size = UDim2.new(1, 0, 1, -45),
									ClipsDescendants = true,
									[children] = { pageContainer({ Scope = scope, pageManager = pageManager }) },
								}),
							},
						})

						window.Root.Parent = parent
						return { WindowContainer = parent, Root = window.Root }
					end
				end)()
			)
		end,
		[99] = function()
			local v, instance, v43 = fn23(99)

			return (
				(function()
					local parent = instance.Parent.Parent
					local httpService = v43(parent.utils.services).HttpService
					local v44 = v43(parent.utils.controlRegistry)
					local n = 0.25
					local str7 = "auto_save.txt"
					local v45 = table.freeze({
						"SaveManager_ConfigList",
						"SaveManager_AutoloadConfig",
						"SaveManager_AccountAutoloadConfig",
					})
					local tbl14

					tbl14 = {
						Options = {},
						_folder = "Courage Hub",
						_ignore = {},
						_currentLoadedConfig = nil,
						_configList = {},
						_autoSaveEnabled = false,
						_autoSaveGeneration = 0,
						_autoSaveChangeDisconnect = nil,
						_isLoadingConfig = false,
						_suppressAutoSaveUntil = 0,
						_applyConfigListToDropdowns = function(arg, arg2)
							local options = arg.Options
							if type(options) ~= "table" then
								return
							end

							for i = 1, #v45 do
								local option = options[v45[i]]

								if option and option.SetValues then
									option:SetValues(arg2)
								end
							end
						end,
						GetFolder = function(arg)
							return arg._folder
						end,
						GetCurrentLoadedConfig = function(arg)
							return arg._currentLoadedConfig
						end,
						GetConfigList = function(arg)
							return table.clone(arg._configList)
						end,
						GetAutoSaveEnabled = function(arg)
							local path = arg._folder .. "/settings/" .. str7
							if not isfile or not readfile or not isfile(path) then
								return false
							end
							local ok, result = pcall(readfile, path)
							return ok and result == "true"
						end,
						SetAutoSaveEnabled = function(arg, arg2)
							local autoSaveEnabled = arg2 == true
							arg._autoSaveEnabled = autoSaveEnabled
							arg._autoSaveGeneration += 1
							if not writefile then
								return false, "file writing is unavailable"
							end
							arg:BuildFolderTree()
							local str8 = arg._folder .. "/settings/" .. str7
							local v46 = pcall
							local v47 = writefile
							local str9

							if autoSaveEnabled then
								str9 = "true"
							else
								str9 = "false"
							end

							local v48, v49 = v46(v47, str8, str9)
							if not v48 then
								return false, tostring(v49)
							end
							return true
						end,
						SetCurrentLoadedConfig = function(arg, currentLoadedConfig)
							arg._currentLoadedConfig = currentLoadedConfig

							if arg.ConfigStatus then
								local configStatus = arg.ConfigStatus
								local setDescription = configStatus.SetDescription
								local str8

								if currentLoadedConfig then
									str8 = string.format("Current config: %s", currentLoadedConfig)
								else
									str8 = "No config loaded"
								end

								setDescription(configStatus, str8)
							end

							local saveManagerConfigList = arg.Options and arg.Options.SaveManager_ConfigList

							if saveManagerConfigList and saveManagerConfigList.SetValue then
								saveManagerConfigList:SetValue(currentLoadedConfig)
							end
						end,
						_scheduleAutoSave = function(arg)
							local currentLoadedConfig = arg:GetCurrentLoadedConfig()
							if not arg._autoSaveEnabled or not currentLoadedConfig then
								return
							end
							arg._autoSaveGeneration += 1
							local autoSaveGeneration = arg._autoSaveGeneration

							task.delay(0.5, function()
								if
									autoSaveGeneration ~= arg._autoSaveGeneration
									or not arg._autoSaveEnabled
									or arg._isLoadingConfig
									or os.clock() < arg._suppressAutoSaveUntil
								then
									return
								end

								if arg:GetCurrentLoadedConfig() ~= currentLoadedConfig then
									return
								end
								local v46, v47 = arg:Save(currentLoadedConfig)

								if not v46 and arg.Library then
									arg.Library:Notify({
										Title = "Auto Save Error",
										Description = "Unable to auto save config: " .. tostring(v47),
										Duration = 7,
										Type = "error",
									})
								end
							end)
						end,
						_handleControlChanged = function(arg, arg2)
							if
								not arg._autoSaveEnabled
								or arg._isLoadingConfig
								or os.clock() < arg._suppressAutoSaveUntil
								or arg:IsIgnored(arg2)
							then
								return
							end
							arg:_scheduleAutoSave()
						end,
						_bindAutoSaveChanges = function(arg)
							if arg._autoSaveChangeDisconnect then
								arg._autoSaveChangeDisconnect()
							end

							arg._autoSaveChangeDisconnect = v44.onControlChanged(function(arg2)
								arg:_handleControlChanged(arg2)
							end)
						end,
						Parser = {
							Toggle = {
								Save = function(arg, arg2)
									return { type = "Toggle", idx = arg, value = arg2.Value }
								end,
								Load = function(arg, arg2)
									if tbl14.Options[arg] and arg2 ~= nil then
										tbl14.Options[arg]:SetValue(arg2.value)
									end
								end,
							},
							Slider = {
								Save = function(arg, arg2)
									return { type = "Slider", idx = arg, value = tonumber(arg2.Value) }
								end,
								Load = function(arg, arg2)
									if tbl14.Options[arg] and arg2 ~= nil then
										local num = tonumber(arg2.value)

										if num ~= nil then
											tbl14.Options[arg]:SetValue(num)
										end
									end
								end,
							},
							Dropdown = {
								Save = function(arg, arg2)
									return { type = "Dropdown", idx = arg, value = arg2.Value, multi = arg2.Multi }
								end,
								Load = function(arg, arg2)
									if tbl14.Options[arg] and arg2 ~= nil then
										tbl14.Options[arg]:SetValue(arg2.value)
									end
								end,
							},
							Colorpicker = {
								Save = function(arg, arg2)
									return {
										type = "Colorpicker",
										idx = arg,
										value = typeof(arg2.Value) == "Color3" and arg2.Value:ToHex() or nil,
									}
								end,
								Load = function(arg, arg2)
									local option = tbl14.Options[arg]

									if option and arg2 ~= nil and type(arg2.value) == "string" then
										local ok, result = pcall(function()
											return Color3.fromHex(arg2.value)
										end)

										if ok and result and option.SetValueRGB then
											option:SetValueRGB(result)
										end
									end
								end,
							},
							Keybind = {
								Save = function(arg, arg2)
									return { type = "Keybind", idx = arg, mode = arg2.Mode, key = arg2.Value }
								end,
								Load = function(arg, arg2)
									if tbl14.Options[arg] and arg2 ~= nil then
										tbl14.Options[arg]:SetValue(arg2.key, arg2.mode)
									end
								end,
							},
							Input = {
								Save = function(arg, arg2)
									return { type = "Input", idx = arg, text = arg2.Value }
								end,
								Load = function(arg, arg2)
									if tbl14.Options[arg] and type(arg2.text) == "string" then
										tbl14.Options[arg]:SetValue(arg2.text)
									end
								end,
							},
						},
						SetIgnoreIndexes = function(arg, arg2)
							local ignore = table.clone(arg._ignore)

							for _, v46 in next, arg2 do
								ignore[v46] = true
							end

							arg._ignore = ignore
						end,
						IsIgnored = function(arg, arg2)
							return arg._ignore[arg2] == true
						end,
						SetFolder = function(arg, folder)
							arg._folder = folder
							arg:BuildFolderTree()
						end,
						ValidateConfigName = function(arg, arg2)
							if type(arg2) ~= "string" then
								return false,
									"config names must begin and end with a letter or number and contain only letters, numbers, spaces, hyphens, and underscores"
							end

							if not arg2:match("^[A-Za-z0-9][A-Za-z0-9 _%-]*$") or not arg2:match("[A-Za-z0-9]$") then
								return false,
									"config names must begin and end with a letter or number and contain only letters, numbers, spaces, hyphens, and underscores"
							end
							return true
						end,
						GetConfigPath = function(arg, arg2)
							local v46, v47 = arg:ValidateConfigName(arg2)
							if not v46 then
								return nil, v47
							end
							return arg._folder .. "/settings/" .. arg2 .. ".json"
						end,
						BuildFolderTree = function(arg)
							local folder = arg._folder
							local tbl15 = { folder, folder .. "/settings" }

							for i = 1, #tbl15 do
								local path = tbl15[i]

								if not isfolder or not isfolder(path) then
									if makefolder then
										makefolder(path)
									end
								end
							end
						end,
						Save = function(arg, arg2)
							local configPath, v46 = arg:GetConfigPath(arg2)
							if not configPath then
								return false, v46
							end
							local flag19 = isfile and isfile(configPath) and true or false
							local tbl15 = { objects = {} }

							for k, v47 in next, tbl14.Options do
								if v47 and v47.Type and arg.Parser[v47.Type] then
									if not arg:IsIgnored(k) then
										table.insert(tbl15.objects, arg.Parser[v47.Type].Save(k, v47))
									end
								end
							end

							local ok, result = pcall(httpService.JSONEncode, httpService, tbl15)
							if not ok then
								return false, "failed to encode data"
							end

							if writefile then
								writefile(configPath, result)
							end

							if not flag19 then
								arg:RefreshConfigList()
							end

							return true
						end,
						Import = function(arg, arg2, content)
							local configPath, v46 = arg:GetConfigPath(arg2)
							if not configPath then
								return false, v46
							end

							if type(content) ~= "string" or content == "" then
								return false, "config data is empty"
							end
							local ok, result = pcall(httpService.JSONDecode, httpService, content)
							if not ok or type(result) ~= "table" or type(result.objects) ~= "table" then
								return false, "invalid config data"
							end

							if not writefile then
								return false, "file writing is unavailable"
							end
							arg:BuildFolderTree()
							local ok2, result2 = pcall(writefile, configPath, content)
							if not ok2 then
								return false, tostring(result2)
							end
							arg:RefreshConfigList()
							return true
						end,
						Read = function(arg, arg2)
							local configPath, v46 = arg:GetConfigPath(arg2)
							if not configPath then
								return false, v46
							end

							if not isfile or not isfile(configPath) then
								return false, "invalid file"
							end

							if not readfile then
								return false, "file reading is unavailable"
							end
							local ok, result = pcall(readfile, configPath)
							if not ok or type(result) ~= "string" then
								return false, tostring(result)
							end
							return true, result
						end,
						Delete = function(arg, arg2)
							local configPath, v46 = arg:GetConfigPath(arg2)
							if not configPath then
								return false, v46
							end

							if not isfile or not isfile(configPath) then
								return false, "invalid file"
							end

							if not delfile then
								return false, "file deletion is unavailable"
							end
							local ok, result = pcall(delfile, configPath)
							if not ok then
								return false, tostring(result)
							end
							arg:RefreshConfigList()
							return true
						end,
						GetAutoload = function(arg)
							local path = arg._folder .. "/settings/autoload.txt"
							if not isfile or not readfile or not isfile(path) then
								return nil
							end
							local ok, result = pcall(readfile, path)

							if not (ok and arg:ValidateConfigName(result)) then
								result = nil
							end

							return result
						end,
						SetAutoload = function(arg, content)
							local path = arg._folder .. "/settings/autoload.txt"

							if content == nil then
								if isfile and isfile(path) then
									if not delfile then
										return false, "file deletion is unavailable"
									end
									local ok, result = pcall(delfile, path)
									if not ok then
										return false, tostring(result)
									end
								end

								return true
							end

							local v46, v47 = arg:ValidateConfigName(content)
							if not v46 then
								return false, v47
							end

							if not writefile then
								return false, "file writing is unavailable"
							end
							arg:BuildFolderTree()
							local ok, result = pcall(writefile, path, content)
							if not ok then
								return false, tostring(result)
							end
							return true
						end,
						GetAccountAutoload = function(arg)
							local localPlayer = game.Players.LocalPlayer
							local userId = localPlayer and localPlayer.UserId
							if not userId then
								return nil
							end
							local path = arg._folder .. "/settings/account_autoloads.txt"
							if not isfile or not readfile or not isfile(path) then
								return nil
							end
							local ok, result = pcall(readfile, path)
							if not ok or type(result) ~= "string" then
								return nil
							end
							local ok2, result2 = pcall(httpService.JSONDecode, httpService, result)
							local v46

							if ok2 and type(result2) == "table" then
								v46 = result2[tostring(userId)]
							else
								v46 = nil
							end

							if not arg:ValidateConfigName(v46) then
								v46 = nil
							end

							return v46
						end,
						SetAccountAutoload = function(arg, arg2)
							local localPlayer = game.Players.LocalPlayer
							local userId = localPlayer and localPlayer.UserId
							if not userId then
								return false, "local player is unavailable"
							end

							if arg2 ~= nil then
								local v46, v47 = arg:ValidateConfigName(arg2)
								if not v46 then
									return false, v47
								end
							end

							local path = arg._folder .. "/settings/account_autoloads.txt"
							local tbl15 = {}

							if isfile and readfile and isfile(path) then
								local ok, result = pcall(readfile, path)
								local v46 = pcall
								local jsonDecode = httpService.JSONDecode

								if not ok then
									result = ""
								end

								local v47, v48 = v46(jsonDecode, httpService, result)

								if v47 and type(v48) == "table" then
									tbl15 = v48
								end
							end

							tbl15[tostring(userId)] = arg2

							if arg2 == nil and next(tbl15) == nil then
								if isfile and isfile(path) and delfile then
									local ok, result = pcall(delfile, path)
									if not ok then
										return false, tostring(result)
									end
								end

								return true
							end

							if not writefile then
								return false, "file writing is unavailable"
							end
							local ok, result = pcall(httpService.JSONEncode, httpService, tbl15)
							if not ok then
								return false, "failed to encode account autoloads"
							end
							arg:BuildFolderTree()
							local ok2, result2 = pcall(writefile, path, result)
							if not ok2 then
								return false, tostring(result2)
							end
							return true
						end,
						Load = function(arg, arg2)
							local configPath, v46 = arg:GetConfigPath(arg2)
							if not configPath then
								return false, v46
							end

							if not isfile or not isfile(configPath) then
								return false, "invalid file"
							end
							local ok, result =
								pcall(httpService.JSONDecode, httpService, readfile and readfile(configPath) or "")
							if not ok or type(result) ~= "table" then
								return false, "decode error"
							end
							arg._autoSaveGeneration += 1
							arg._isLoadingConfig = true
							arg._suppressAutoSaveUntil = os.clock() + n

							local ok2, result2 = pcall(function()
								local objects = result.objects or {}

								for _, v47 in next, objects do
									if v47 and v47.type and arg.Parser[v47.type] then
										arg.Parser[v47.type].Load(v47.idx, v47)
									end
								end
							end)

							arg._isLoadingConfig = false
							arg._suppressAutoSaveUntil = os.clock() + n
							if not ok2 then
								return false, tostring(result2)
							end
							arg:SetCurrentLoadedConfig(arg2)
							return true
						end,
						RefreshConfigList = function(arg)
							local path = arg._folder .. "/settings"
							local configList = {}

							if listfiles then
								local v46 = listfiles(path)

								for i = 1, #v46 do
									local v47 = v46[i]

									if type(v47) == "string" and v47:sub(-5) == ".json" then
										local match = v47:match("([^/\\]+)%.json$")

										if match and arg:ValidateConfigName(match) then
											table.insert(configList, match)
										end
									end
								end
							end

							arg._configList = configList
							arg:_applyConfigListToDropdowns(configList)
							return configList
						end,
						SetLibrary = function(arg, library)
							if arg._autoSaveChangeDisconnect then
								arg._autoSaveChangeDisconnect()
								arg._autoSaveChangeDisconnect = nil
							end

							arg.Library = library
							arg.Options = library.Options
							arg._initialLoadComplete = false
							arg._autoSaveEnabled = false
							arg._autoSaveGeneration += 1
							arg._isLoadingConfig = false
							arg._suppressAutoSaveUntil = 0
						end,
						cleanup = function(arg)
							if arg._autoSaveChangeDisconnect then
								arg._autoSaveChangeDisconnect()
								arg._autoSaveChangeDisconnect = nil
							end

							arg.Library = nil
							arg.Options = {}
							arg.ConfigStatus = nil
							arg._initialLoadComplete = false
							arg._autoSaveEnabled = false
							arg._autoSaveGeneration += 1
							arg._isLoadingConfig = false
							arg._suppressAutoSaveUntil = 0
						end,
						IgnoreThemeSettings = function(arg)
							arg:SetIgnoreIndexes({ "InterfaceTheme", "MenuKeybind" })
						end,
						BuildConfigSection = function(arg, arg2)
							assert(arg.Library, "Must set SaveManager.Library")
							arg:_bindAutoSaveChanges()
							local autoSaveEnabled = arg:GetAutoSaveEnabled()
							arg._autoSaveEnabled = autoSaveEnabled
							local v46 = arg2:AddSection({ Title = "STATUS" })
							local configStatus =
								v46:AddText({ Title = "Current Config", Description = "No config loaded" })
							arg.ConfigStatus = configStatus
							local currentLoadedConfig = arg:GetCurrentLoadedConfig()

							if currentLoadedConfig then
								configStatus:SetDescription(string.format("Current config: %s", currentLoadedConfig))
							end

							local v47 = arg:RefreshConfigList()

							v46:AddDropdown("SaveManager_AutoloadConfig", {
								Title = "Autoload Config",
								Description = "Select a config to autoload on startup",
								Values = v47,
								AllowNull = true,
								Default = arg:GetAutoload(),
								Callback = function(autoloadConfig)
									if arg:SetAutoload(autoloadConfig) and arg._initialLoadComplete then
										if autoloadConfig then
											arg.Library:Notify({
												Title = "Autoload Set",
												Description = string.format(
													"Config %q will now load automatically on startup",
													autoloadConfig
												),
												Duration = 5,
												Type = "success",
											})
										else
											arg.Library:Notify({
												Title = "Autoload Reset",
												Description = "Autoload has been disabled",
												Duration = 5,
												Type = "success",
											})
										end
									end
								end,
							})

							v46:AddDropdown("SaveManager_AccountAutoloadConfig", {
								Title = "Account Autoload Config",
								Description = "Select a specific config to autoload for this account",
								Values = v47,
								AllowNull = true,
								Default = arg:GetAccountAutoload(),
								Callback = function(accountAutoloadConfig)
									if
										arg:SetAccountAutoload(accountAutoloadConfig)
										and accountAutoloadConfig
										and arg._initialLoadComplete
									then
										arg.Library:Notify({
											Title = "Account Autoload Set",
											Description = string.format(
												"Config %q will autoload for this account",
												accountAutoloadConfig
											),
											Duration = 5,
											Type = "success",
										})
									end
								end,
							})

							local v48 = arg2:AddSection({ Title = "MANAGE CONFIGS" })

							v48:AddDropdown("SaveManager_ConfigList", {
								Title = "Saved Configurations",
								Description = "Select a configuration to manage",
								Values = v47,
								AllowNull = true,
								Default = arg:GetCurrentLoadedConfig(),
							})

							v48:AddToggle("SaveManager_AutoSaveConfig", {
								Title = "Auto Save Config",
								Description = "Automatically save changes to the currently loaded config",
								Default = autoSaveEnabled,
								Callback = function(autoSaveConfig)
									arg:SetAutoSaveEnabled(autoSaveConfig)
								end,
							})

							v48:AddButton({
								Title = "Load Config",
								Description = "Load the selected configuration",
								Type = "primary",
								Callback = function()
									local value = tbl14.Options.SaveManager_ConfigList
										and tbl14.Options.SaveManager_ConfigList.Value
									local v49, v50 = arg:Load(value)

									if not v49 then
										arg.Library:Notify({
											Title = "Configuration Error",
											Description = "Failed to load selected config: " .. tostring(v50),
											Duration = 7,
											Type = "error",
										})

										return
									end

									arg.Library:Notify({
										Title = "Configuration Loaded",
										Description = string.format("Successfully loaded config: %q", value),
										Duration = 7,
										Type = "success",
									})
								end,
							})

							v48:AddButton({
								Title = "Update Config",
								Description = "Update selected config with current settings",
								Type = "default",
								Callback = function()
									local value = tbl14.Options.SaveManager_ConfigList
										and tbl14.Options.SaveManager_ConfigList.Value
									local v49, v50 = arg:Save(value)

									if not v49 then
										arg.Library:Notify({
											Title = "Configuration Error",
											Description = "Unable to save changes to config: " .. tostring(v50),
											Duration = 7,
											Type = "error",
										})

										return
									end

									arg.Library:Notify({
										Title = "Configuration Updated",
										Description = string.format("Successfully saved changes to config: %q", value),
										Duration = 7,
										Type = "success",
									})
								end,
							})

							local v49 = arg2:AddSection({ Title = "CREATE NEW CONFIG" })
							v49:AddInput(
								"SaveManager_ConfigName",
								{ Title = "New Config Name", Description = "Enter a name for your new configuration", Default = "Courage Config" }
							)

							v49:AddButton({
								Title = "Create New Config",
								Description = "Save current settings as a new configuration",
								Type = "primary",
								Callback = function()
									local str8 = tbl14.Options.SaveManager_ConfigName
											and tbl14.Options.SaveManager_ConfigName.Value
										or ""

									if str8:gsub(" ", "") == "" then
										arg.Library:Notify({
											Title = "Configuration Error",
											Description = "Please enter a valid config name",
											Duration = 7,
											Type = "error",
										})

										return
									end

									local v50, v51 = arg:Save(str8)

									if not v50 then
										arg.Library:Notify({
											Title = "Configuration Error",
											Description = "Unable to create new config: " .. tostring(v51),
											Duration = 7,
											Type = "error",
										})

										return
									end

									arg.Library:Notify({
										Title = "Configuration Created",
										Description = string.format("Successfully created new config: %q", str8),
										Duration = 7,
										Type = "success",
									})

									arg:RefreshConfigList()
									arg:SetCurrentLoadedConfig(str8)
								end,
							})

							local v50 = arg2:AddSection({ Title = "UTILITIES" })

							v50:AddButton({
								Title = "Refresh Config List",
								Description = "Update the list of saved configurations",
								Type = "default",
								Callback = function()
									arg:RefreshConfigList()

									if tbl14.Options.SaveManager_ConfigList then
										tbl14.Options.SaveManager_ConfigList:SetValue(arg:GetCurrentLoadedConfig())
									end
								end,
							})

							v50:AddButton({
								Title = "Reset Autoload",
								Description = "Remove the autoload setting",
								Type = "danger",
								Callback = function()
									if arg:GetAutoload() then
										if not arg:SetAutoload(nil) then
											return
										end

										if tbl14.Options.SaveManager_AutoloadConfig then
											tbl14.Options.SaveManager_AutoloadConfig:SetValue(nil)
										end

										arg.Library:Notify({
											Title = "Autoload Reset",
											Description = "Autoload has been disabled",
											Duration = 7,
											Type = "success",
										})
									else
										arg.Library:Notify({
											Title = "Autoload Reset",
											Description = "No autoload was set",
											Duration = 7,
											Type = "info",
										})
									end
								end,
							})

							v50:AddButton({
								Title = "Reset Account Autoload",
								Description = "Remove account-specific autoload for this account",
								Type = "danger",
								Callback = function()
									if arg:GetAccountAutoload() then
										if not arg:SetAccountAutoload(nil) then
											return
										end

										if tbl14.Options.SaveManager_AccountAutoloadConfig then
											tbl14.Options.SaveManager_AccountAutoloadConfig:SetValue(nil)
										end

										arg.Library:Notify({
											Title = "Account Autoload Reset",
											Description = "Account-specific autoload config cleared",
											Duration = 7,
											Type = "success",
										})
									else
										arg.Library:Notify({
											Title = "Account Autoload Reset",
											Description = "No account-specific autoload was set",
											Duration = 7,
											Type = "info",
										})
									end
								end,
							})

							arg2:AddSection({ Title = "HELP & GUIDE" }):AddAccordion("SaveManager_HelpAccordion", {
								Items = {
									{
										id = "getting_started",
										title = "Getting Started",
										open = false,
										content = [[1. Configure your UI elements (toggles, sliders, etc.)
	2. Enter a name in 'New Config Name'
	3. Click 'Create New Config' to save
	4. Use 'Load Config' to restore saved settings
	5. Set an 'Autoload Config' for automatic loading on startup]],
										},
										{
											id = "autoload_system",
											title = "Autoload System",
											open = false,
											content = [[â€¢ Global Autoload: Loads the same config across all roblox accounts when script is executed
	â€¢ Account Autoload: Loads a specific config for current roblox account only when script is executed
	â€¢ Account autoload takes priority over global autoload
	â€¢ Use 'Reset' buttons to disable autoload features]],
										},
										{
											id = "troubleshooting",
											title = "Troubleshooting",
											open = false,
											content = [[â€¢ Settings not saving? Your exploit is probably trash
	â€¢ Missing configs? Use 'Refresh Config List' to update
	â€¢ For persistent issues, try recreating the config]],
										},
										{
											id = "file_storage",
											title = "File Storage",
											open = false,
											content = string.format(
												[[â€¢ Configs: %s/settings/*.json
	â€¢ Autoload: %s/settings/autoload.txt
	â€¢ Account Autoloads: %s/settings/account_autoloads.txt
	â€¢ Files are automatically created when needed]],
												arg._folder,
												arg._folder,
												arg._folder
											),
									},
									{
										id = "tips",
										title = "Tips & Best Practices",
										open = false,
										content = [[â€¢ Use descriptive names for your configs (e.g., 'PvP Setup', 'Farming Config')
	â€¢ Update existing configs instead of creating duplicates
	â€¢ Use account autoload so configs don't apply to other accounts]],
									},
								},
								AllowMultiple = true,
							})

							tbl14:SetIgnoreIndexes({
								"SaveManager_ConfigList",
								"SaveManager_ConfigName",
								"SaveManager_AutoSaveConfig",
								"SaveManager_AccountAutoloadConfig",
								"SaveManager_AutoloadConfig",
								"SaveManager_HelpAccordion",
							})
						end,
						LoadAutoloadConfig = function(arg)
							if arg._initialLoadComplete then
								return true
							end
							local accountAutoload = arg:GetAccountAutoload() or arg:GetAutoload()

							if accountAutoload then
								local v46, v47 = arg:Load(accountAutoload)

								if not v46 then
									if arg.Library then
										arg.Library:Notify({
											Title = "Configuration Error",
											Description = "Unable to load startup config: " .. tostring(v47),
											Type = "error",
											Duration = 7,
										})
									end

									return false, v47
								end

								arg:SetCurrentLoadedConfig(accountAutoload)

								if arg.Library then
									arg.Library:Notify({
										Title = "Configuration Loaded",
										Description = string.format(
											"Successfully loaded startup config: %q",
											accountAutoload
										),
										Duration = 7,
										Type = "success",
									})
								end
							end

							arg._initialLoadComplete = true
							return true
						end,
					}

					tbl14:BuildFolderTree()
					return tbl14
				end)()
			)
		end,
		[101] = function()
			fn23(101)

			return (
				(function()
					return {
						Sounds = {
							Key = "rbxassetid://8566613627",
							Enter = "rbxassetid://8566613567",
							Backspace = "rbxassetid://8566613459",
							NoType = "rbxassetid://8567221828",
						},
						Play = function(arg, arg2)
							assert(arg.Sounds[arg2], "Invalid sound name")
							local sound = Instance.new("Sound")
							sound.SoundId = arg.Sounds[arg2]
							sound.Parent = game.CoreGui
							sound:Play()

							sound.Ended:Connect(function()
								sound:Destroy()
							end)
						end,
					}
				end)()
			)
		end,
		[102] = function()
			local v, instance, v43 = fn23(102)

			return (function()
				local tbl14 = {}

				for _, instance2 in instance.Parent:GetChildren() do
					if instance2.Name ~= "cmdr" and instance2.ClassName == "ModuleScript" then
						tbl14[instance2.Name] = v43(instance2)
					end
				end

				local peek = v43(instance.Parent.Parent.packages.fusion).peek
				local tbl15 = {}

				for _, instance2 in instance.Parent.Parent.utils:GetChildren() do
					if instance2.ClassName == "ModuleScript" then
						tbl15[instance2.Name] = v43(instance2)
					end
				end

				local handlers2 = {
					string = function(arg)
						return arg
					end,
					number = function(arg)
						return tonumber(arg) or 0
					end,
					integer = function(arg)
						return math.floor(tonumber(arg) or 0)
					end,
					bool = function(arg)
						local v44 = string.lower(arg)
						return v44 == "on" or v44 == "true" or v44 == "yes" or v44 == "1" or false
					end,
					url = function(arg)
						return string.match(arg, "^%a+://%S+")
					end,
					player = function(arg)
						return arg:lower()
					end,
					hex = function(arg)
						return string.match(arg, "^[A-Fa-f0-9]+$")
					end,
				}

				local tbl16 = {
					charAt = function(arg, arg2)
						return string.sub(arg, arg2, arg2)
					end,
					startsWith = function(arg, arg2)
						return string.sub(arg, 1, #arg2) == arg2
					end,
					trim = function(arg)
						return string.match(arg, "^%s*(.-)%s*$")
					end,
				}

				local index = {}
				index.__index = index

				index.new = function(arg)
					local obj = setmetatable({}, index)
					obj.prefix = arg.prefix or ""
					obj.commands = {}
					return obj
				end

				index.newCommand = function(arg, arg2)
					table.insert(arg.commands, {
						name = arg2.name,
						aliases = arg2.aliases,
						description = arg2.description,
						arguments = arg2.arguments,
						callback = arg2.callback,
					})
				end

				index.executeCommand = function(arg, arg2)
					if tbl16.startsWith(arg2, arg.prefix) then
						arg2 = arg2:sub(#arg.prefix + 1)
					end

					local tbl17 = {}
					local gmatch = string.gmatch
					local str7 = tbl16.trim(arg2) or ""

					for k in gmatch(str7, "%S+") do
						table.insert(tbl17, k)
					end

					local v44 = tbl17[1]
					local tbl18 = {}

					for i = 2, #tbl17 do
						table.insert(tbl18, tbl17[i])
					end

					local callback = nil
					local v45 = nil

					for _, v46 in arg.commands do
						if v46.name == v44 or table.find(v46.aliases, v44) then
							callback = v46.callback
							v45 = v46
						end
					end

					if callback == nil then
						peek(instance.Parent.states).Library:Notify({
							Title = "Error",
							Description = "Could not find command <b>" .. v44 .. "</b>",
							Duration = 5,
							Type = "error",
						})

						return
					end

					local tbl19 = {}

					for k, v46 in v45.arguments do
						local v47 = tbl18[k]

						if v47 then
							local v48 = handlers2[v46.type](v47)

							if v48 == nil then
								peek(instance.Parent.states).Library:Notify({
									Title = "Error",
									Description = "There was an error validating argument: <b>" .. v46.name .. "</b>",
									Duration = 5,
									Type = "error",
								})
							end

							tbl19[v46.name] = v48
						else
							peek(instance.Parent.states).Library:Notify({
								Title = "Error",
								Description = "Missing argument <b>" .. v46.name .. "</b>",
								Duration = 5,
								Type = "error",
							})
						end
					end

					local ok, result = pcall(callback, tbl14, tbl15, tbl19)

					if not ok then
						error(result)
					end
				end

				return table.freeze(index)
			end)()
		end,
		[103] = function()
			fn23(103)

			return (
				(function()
					local tbl14

					tbl14 = {
						raw = function(arg, arg2)
							if not (#arg2 < #arg) then
								local v = arg
								arg = arg2
								arg2 = v
							end

							local n = #arg2
							local n27 = #arg
							local tbl15 = {}
							local tbl16 = {}

							for i = 1, n27 + 1 do
								tbl15[i] = i - 1
								tbl16[i] = 0
							end

							for i = 1, n do
								tbl16[1] = i

								for i2 = 1, n27 do
									local n28

									if arg2:sub(i, i) == arg:sub(i2, i2) then
										n28 = 0
									else
										n28 = 1
									end

									tbl16[i2 + 1] = math.min(tbl15[i2 + 1] + 1, tbl16[i2] + 1, tbl15[i2] + n28)

									if
										i > 1
										and i2 > 1
										and arg2:sub(i, i) == arg:sub(i2 - 1, i2 - 1)
										and arg2:sub(i - 1, i - 1) == arg:sub(i2, i2)
									then
										tbl16[i2 + 1] = math.min(tbl16[i2 + 1], tbl15[i2 - 1] + n28)
									end
								end

								for i2 = 1, n27 + 1 do
									tbl15[i2] = tbl16[i2]
								end
							end

							return tbl16[n27 + 1]
						end,
						weighted = function(arg, arg2)
							local n = #arg
							local n27 = #arg2
							if n == 0 and n27 == 0 then
								return 0
							end
							return tbl14.raw(arg, arg2) / (n + n27)
						end,
					}

					return tbl14
				end)()
			)
		end,
		[104] = function()
			local v, v43, v44 = fn23(104)

			return (function()
				local function getInstance(instance)
					local instance2 = instance

					while instance2 do
						if instance2:FindFirstChild("packages") and instance2:FindFirstChild("utils") then
							return instance2
						end
						instance2 = instance2.Parent
					end

					error(("Unable to resolve library root from %s"):format(instance:GetFullName()))
				end

				local fn24 = nil
				local v45 = v44(getInstance(v43).utils.services)

				local tbl14 = {
					function()
						local e, e, M = fn24(1)

						return (
							(function(...)
								M(e.Types)
								local g, x = M(e.External), M(e.RobloxExternal)
								g.setExternalProvider(x)

								return (
									table.freeze({
										version = { major = 0, minor = 4, isRelease = false },
										cleanup = function()
											g.setExternalProvider(nil)
										end,
										Contextual = M(e.Utility.Contextual),
										Safe = M(e.Utility.Safe),
										deriveScope = M(e.Memory.deriveScope),
										doCleanup = M(e.Memory.doCleanup),
										innerScope = M(e.Memory.innerScope),
										insert = M(e.Memory.insert),
										scoped = M(e.Memory.scoped),
										Observer = M(e.Graph.Observer),
										Computed = M(e.State.Computed),
										ForKeys = M(e.State.ForKeys),
										ForPairs = M(e.State.ForPairs),
										ForValues = M(e.State.ForValues),
										peek = M(e.State.peek),
										Value = M(e.State.Value),
										Attribute = M(e.Instances.Attribute),
										AttributeChange = M(e.Instances.AttributeChange),
										AttributeOut = M(e.Instances.AttributeOut),
										Child = M(e.Instances.Child),
										Children = M(e.Instances.Children),
										Hydrate = M(e.Instances.Hydrate),
										New = M(e.Instances.New),
										OnChange = M(e.Instances.OnChange),
										OnEvent = M(e.Instances.OnEvent),
										Out = M(e.Instances.Out),
										Tag = M(e.Instances.Tag),
										Tween = M(e.Animation.Tween),
										Spring = M(e.Animation.Spring),
									})
								)
							end)()
						)
					end,
					[3] = function()
						local e, e, M = fn24(3)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R =
									M(g.External), M(g.Graph.change), M(g.Utility.nicknames), {
										type = "State",
										kind = "ExternalTime",
										timeliness = "lazy",
										dependencySet = table.freeze({}),
									}
								local g, M = table.freeze({ __index = R }), {}

								local function d(p)
									local I = setmetatable({
										createdAt = os.clock(),
										dependentSet = {},
										lastChange = nil,
										scope = p,
										validity = "invalid",
										_EXTREMELY_DANGEROUS_usedAsValue = e.lastUpdateStep(),
									}, g)

									local function g()
										I.scope = nil
										local E = table.find(M, I)

										if E ~= nil then
											table.remove(M, E)
										end
									end

									I.oldestTask = g
									O[I.oldestTask] = "ExternalTime"
									table.insert(p, g)
									table.insert(M, I)
									return I
								end

								R._evaluate = function(g)
									g._EXTREMELY_DANGEROUS_usedAsValue = e.lastUpdateStep()
									return true
								end

								e.bindToUpdateStep(function(g)
									for g, g in M, nil, nil do
										x(g)
									end
								end)

								return d
							end)()
						)
					end,
					[4] = function()
						local e, e, M = fn24(4)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d, p, I, E, w, S, f, a, n, Q, Z =
									M(g.External),
									M(g.Memory.checkLifetime),
									M(g.Graph.depend),
									M(g.Graph.change),
									M(g.Graph.evaluate),
									M(g.State.castToState),
									M(g.State.peek),
									M(g.Animation.ExternalTime),
									M(g.Animation.Stopwatch),
									M(g.Animation.packType),
									M(g.Animation.unpackType),
									M(g.Animation.springCoefficients),
									M(g.Utility.nicknames),
									1e-05,
									{ type = "State", kind = "Spring", timeliness = "eager" }
								local g = table.freeze({ __index = Z })

								local function M(t, z, L, l)
									local P, r = os.clock(), p(z)
									local D

									if r ~= nil then
										D = w(t, E(t))
										D:unpause()
									end

									local E, w = L or 10, l or 1
									local L = setmetatable({
										createdAt = P,
										dependencySet = {},
										dependentSet = {},
										lastChange = nil,
										scope = t,
										validity = "invalid",
										_activeDamping = -1,
										_activeGoal = nil,
										_activeLatestP = {},
										_activeLatestV = {},
										_activeNumSprings = 0,
										_activeSpeed = -1,
										_activeStartP = {},
										_activeStartV = {},
										_activeTargetP = {},
										_activeType = "",
										_damping = w,
										_EXTREMELY_DANGEROUS_usedAsValue = I(z),
										_goal = z,
										_speed = E,
										_stopwatch = D,
									}, g)

									local function g()
										L.scope = nil

										for l in pairs(L.dependencySet) do
											l.dependentSet[L] = nil
										end
									end

									L.oldestTask = g
									n[L.oldestTask] = "Spring"
									table.insert(t, g)

									if r ~= nil then
										x.bOutlivesA(t, L.oldestTask, r.scope, r.oldestTask, x.formatters.animationGoal)
									end

									D = p(E)

									if D ~= nil then
										x.bOutlivesA(
											t,
											L.oldestTask,
											D.scope,
											D.oldestTask,
											x.formatters.parameter,
											"speed"
										)
									end

									z = p(w)

									if z ~= nil then
										x.bOutlivesA(
											t,
											L.oldestTask,
											z.scope,
											z.oldestTask,
											x.formatters.parameter,
											"damping"
										)
									end

									d(L, true)
									return L
								end

								Z.addVelocity = function(g, x)
									d(g, false)
									local E = typeof(x)

									if E ~= g._activeType then
										e.logError("springTypeMismatch", nil, E, g._activeType)
									end

									local w = f(x, E)

									for x, E in g._activeLatestV, nil, nil do
										w[x] = w[x] + E
									end

									g._activeStartP = table.clone(g._activeLatestP)
									g._activeStartV = w
									g._stopwatch:zero()
									g._stopwatch:unpause()
									R(g)
								end

								Z.setPosition = function(g, x)
									d(g, false)
									local E = typeof(x)

									if E ~= g._activeType then
										e.logError("springTypeMismatch", nil, E, g._activeType)
									end

									g._activeStartP = f(x, E)
									g._activeStartV = table.clone(g._activeLatestV)
									g._stopwatch:zero()
									g._stopwatch:unpause()
									R(g)
								end

								Z.setVelocity = function(g, x)
									d(g, false)
									local d = typeof(x)

									if d ~= g._activeType then
										e.logError("springTypeMismatch", nil, d, g._activeType)
									end

									g._activeStartP = table.clone(g._activeLatestP)
									g._activeStartV = f(x, d)
									g._stopwatch:zero()
									g._stopwatch:unpause()
									R(g)
								end

								Z._evaluate = function(g)
									local x = p(g._goal)
									if x == nil then
										g._EXTREMELY_DANGEROUS_usedAsValue = g._goal
										return false
									end
									local R, d = O(g, x), g._stopwatch
									x = O(g, d)
									if R ~= R then
										e.logWarn("springNanGoal")
										return false
									end
									local O = typeof(R)
									local p, E = O ~= g._activeType

									if p then
										E = R
									else
										local w, n, t, z = a(x, g._activeDamping, g._activeSpeed)
										local a = false

										for L = 1, g._activeNumSprings, 1 do
											local l, P, r = g._activeStartP[L], g._activeTargetP[L], g._activeStartV[L]
											local D = l - P
											local l, W = (D * w) + (r * n), (D * t) + (r * z)

											if (l ~= l) or (W ~= W) then
												e.logWarn("springNanMotion")
												l, W = 0, 0
											end

											a = if (math.abs(l) > Q) or (math.abs(W) > Q) then true else a
											r = l + P
											g._activeLatestP[L] = r
											g._activeLatestV[L] = W
										end

										if not a and (d:isPlaying()) then
											g._activeLatestP = table.clone(g._activeTargetP)
											g._activeLatestV = table.create(g._activeNumSprings, 0)
											d:pause()
											d:zero()
										end

										E = (S(g._activeLatestP, g._activeType))
									end

									local e, w = I(g._speed), I(g._damping)

									if
										((p or (R ~= g._activeGoal)) or (e ~= g._activeSpeed))
										or (w ~= g._activeDamping)
									then
										g._activeTargetP = f(R, O)
										g._activeNumSprings = #g._activeTargetP

										if p then
											g._activeStartP = table.clone(g._activeTargetP)
											g._activeLatestP = table.clone(g._activeTargetP)
											g._activeStartV = table.create(g._activeNumSprings, 0)
											g._activeLatestV = table.create(g._activeNumSprings, 0)
										else
											g._activeStartP = table.clone(g._activeLatestP)
											g._activeStartV = table.clone(g._activeLatestV)
										end

										g._activeType = O
										g._activeGoal = R
										g._activeDamping = w
										g._activeSpeed = e
										d:zero()
										d:unpause()
									end

									x = g._EXTREMELY_DANGEROUS_usedAsValue
									g._EXTREMELY_DANGEROUS_usedAsValue = E
									return x ~= E
								end

								table.freeze(Z)
								return M
							end)()
						)
					end,
					[5] = function()
						local e, e, M = fn24(5)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d, p =
									M(g.Memory.checkLifetime),
									M(g.Graph.depend),
									M(g.Graph.change),
									M(g.State.peek),
									M(g.Utility.nicknames),
									{ type = "State", kind = "Stopwatch", timeliness = "lazy" }
								local g = table.freeze({ __index = p })

								local function M(I, E)
									local w = setmetatable({
										awake = true,
										createdAt = os.clock(),
										dependencySet = {},
										dependentSet = {},
										lastChange = nil,
										scope = I,
										validity = "invalid",
										_EXTREMELY_DANGEROUS_usedAsValue = 0,
										_measureTimeSince = 0,
										_playing = false,
										_zeroFlag = true,
										_timer = E,
									}, g)

									local function g()
										w.scope = nil
									end

									w.oldestTask = g
									d[w.oldestTask] = "Stopwatch"
									table.insert(I, g)
									e.bOutlivesA(
										I,
										w.oldestTask,
										E.scope,
										E.oldestTask,
										e.formatters.parameter,
										"timer"
									)
									x(w, E)
									return w
								end

								p.zero = function(g)
									g._zeroFlag = true
									g._measureTimeSince = R(g._timer)
									O(g)
								end

								p.pause = function(g)
									if g._playing == true then
										g._playing = false
										O(g)
									end
								end

								p.unpause = function(g)
									if g._playing == false then
										g._playing = true
										g._measureTimeSince = R(g._timer)
											- (if g._zeroFlag then 0 else g._EXTREMELY_DANGEROUS_usedAsValue)
										O(g)
									end
								end

								p.isPlaying = function(g)
									return g._playing
								end

								p._evaluate = function(g)
									if g._playing then
										g._zeroFlag = false
										local e, O = x(g, g._timer), g._EXTREMELY_DANGEROUS_usedAsValue
										local x = e - g._measureTimeSince
										g._EXTREMELY_DANGEROUS_usedAsValue = x
										return O ~= x
									else
										return false
									end
								end

								table.freeze(p)
								return M
							end)()
						)
					end,
					[6] = function()
						local e, e, M = fn24(6)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d, p, I, E, w, S, f, a, n =
									M(g.External),
									M(g.Memory.checkLifetime),
									M(g.Graph.depend),
									M(g.Graph.evaluate),
									M(g.State.castToState),
									M(g.State.peek),
									M(g.Animation.ExternalTime),
									M(g.Animation.Stopwatch),
									M(g.Animation.lerpType),
									M(g.Animation.getTweenRatio),
									M(g.Animation.getTweenDuration),
									M(g.Utility.nicknames),
									{ type = "State", kind = "Tween", timeliness = "eager" }
								local g = table.freeze({ __index = n })

								local function M(Q, Z, t)
									local z, L = os.clock(), d(Z)
									local l = setmetatable({
										createdAt = z,
										dependencySet = {},
										dependentSet = {},
										lastChange = nil,
										scope = Q,
										validity = "invalid",
										_activeDuration = nil,
										_activeElapsed = nil,
										_activeFrom = nil,
										_activeTo = nil,
										_activeTweenInfo = nil,
										_EXTREMELY_DANGEROUS_usedAsValue = p(Z),
										_goal = Z,
										_stopwatch = if L ~= nil then (E(Q, I(Q))) else nil,
										_tweenInfo = t or (TweenInfo.new()),
									}, g)

									local function g()
										l.scope = nil

										for I in pairs(l.dependencySet) do
											I.dependentSet[l] = nil
										end
									end

									l.oldestTask = g
									a[l.oldestTask] = "Tween"
									table.insert(Q, g)

									if L ~= nil then
										x.bOutlivesA(Q, l.oldestTask, L.scope, L.oldestTask, x.formatters.animationGoal)
									end

									z = d(t)

									if z ~= nil then
										x.bOutlivesA(
											Q,
											l.oldestTask,
											z.scope,
											z.oldestTask,
											x.formatters.parameter,
											"tween info"
										)
									end

									R(l, true)
									return l
								end

								n._evaluate = function(g)
									local x = d(g._goal)
									if x == nil then
										g._EXTREMELY_DANGEROUS_usedAsValue = g._goal
										return false
									end
									O(g, x)
									local R = p(x)
									if R ~= R then
										e.logWarn("tweenNanGoal")
										return false
									end
									local d, I = g._stopwatch, p(g._tweenInfo)

									if
										(g._activeTo ~= R)
										or ((g._activeElapsed < g._activeDuration) and (g._activeTweenInfo ~= I))
									then
										g._activeDuration = f(I)
										g._activeFrom = g._EXTREMELY_DANGEROUS_usedAsValue
										g._activeTo = R
										g._activeTweenInfo = I
										d:zero()
										d:unpause()
									end

									O(g, d)
									g._activeElapsed = p(d)

									if
										((g._activeFrom == g._activeTo) or (g._activeElapsed >= g._activeDuration))
										or (typeof(g._activeTo) ~= typeof(g._activeFrom))
									then
										g._activeFrom = g._activeTo
										g._activeElapsed = g._activeDuration
										d:pause()
									end

									d, x = S(I, g._activeElapsed), g._EXTREMELY_DANGEROUS_usedAsValue
									I = w(g._activeFrom, g._activeTo, d)

									if I ~= I then
										e.logWarn("tweenNanMotion")
										I = g._activeTo
									end

									g._EXTREMELY_DANGEROUS_usedAsValue = I
									return x ~= I
								end

								table.freeze(n)
								return M
							end)()
						)
					end,
					[7] = function()
						fn24(7)

						return (
							(function(...)
								local e = v45.TweenService

								return function(g)
									if g.RepeatCount <= -1 then
										return math.huge
									end
									local e = g.DelayTime + g.Time
									return (if g.Reverses then e + g.Time else e) * (g.RepeatCount + 1)
								end
							end)()
						)
					end,
					[8] = function()
						fn24(8)

						return (
							(function(...)
								local e = v45.TweenService

								return function(g, M)
									local x, O, R, d, p, I =
										g.DelayTime,
										g.Time,
										g.Reverses,
										1 + g.RepeatCount,
										g.EasingStyle,
										g.EasingDirection
									local E = x + O
									E = if R then E + O else E
									if M == math.huge then
										return 1
									end

									if (M >= (E * d)) and (g.RepeatCount > -1) then
										return 1
									end
									R = M % E
									if R <= x then
										return 0
									end
									M = (R - x) / O
									return (e:GetValue(if M > 1 then 2 - M else M, p, I))
								end
							end)()
						)
					end,
					[9] = function()
						local e, e, M = fn24(9)

						return (
							(function(...)
								local g = M(e.Parent.Parent.Colour.Oklab)

								return function(e, M, x)
									local O = typeof(e)

									if typeof(M) == O then
										if O == "number" then
											return ((M - e) * x) + e
										elseif O == "CFrame" then
											return e:Lerp(M, x)
										elseif O == "Color3" then
											local R, d = g.fromSRGB(e), g.fromSRGB(M)
											return g.toSRGB(R:Lerp(d, x), false)
										elseif O == "ColorSequenceKeypoint" then
											local R, d = g.fromSRGB(e.Value), g.fromSRGB(M.Value)
											return ColorSequenceKeypoint.new(
												((M.Time - e.Time) * x) + e.Time,
												g.toSRGB(R:Lerp(d, x), false)
											)
										elseif O == "DateTime" then
											return DateTime.fromUnixTimestampMillis(
												((M.UnixTimestampMillis - e.UnixTimestampMillis) * x)
													+ e.UnixTimestampMillis
											)
										elseif O == "NumberRange" then
											return NumberRange.new(
												((M.Min - e.Min) * x) + e.Min,
												((M.Max - e.Max) * x) + e.Max
											)
										elseif O == "NumberSequenceKeypoint" then
											return NumberSequenceKeypoint.new(
												((M.Time - e.Time) * x) + e.Time,
												((M.Value - e.Value) * x) + e.Value,
												((M.Envelope - e.Envelope) * x) + e.Envelope
											)
										elseif O == "PhysicalProperties" then
											return PhysicalProperties.new(
												((M.Density - e.Density) * x) + e.Density,
												((M.Friction - e.Friction) * x) + e.Friction,
												((M.Elasticity - e.Elasticity) * x) + e.Elasticity,
												((M.FrictionWeight - e.FrictionWeight) * x) + e.FrictionWeight,
												((M.ElasticityWeight - e.ElasticityWeight) * x) + e.ElasticityWeight
											)
										elseif O == "Ray" then
											return Ray.new(e.Origin:Lerp(M.Origin, x), e.Direction:Lerp(M.Direction, x))
										elseif O == "Rect" then
											return Rect.new(e.Min:Lerp(M.Min, x), e.Max:Lerp(M.Max, x))
										elseif O == "Region3" then
											local g, R =
												e.CFrame.Position:Lerp(M.CFrame.Position, x), e.Size:Lerp(M.Size, x) / 2
											return Region3.new(g - R, g + R)
										elseif O == "Region3int16" then
											return Region3int16.new(
												Vector3int16.new(
													((M.Min.X - e.Min.X) * x) + e.Min.X,
													((M.Min.Y - e.Min.Y) * x) + e.Min.Y,
													((M.Min.Z - e.Min.Z) * x) + e.Min.Z
												),
												Vector3int16.new(
													((M.Max.X - e.Max.X) * x) + e.Max.X,
													((M.Max.Y - e.Max.Y) * x) + e.Max.Y,
													((M.Max.Z - e.Max.Z) * x) + e.Max.Z
												)
											)
										elseif O == "UDim" then
											return UDim.new(
												((M.Scale - e.Scale) * x) + e.Scale,
												((M.Offset - e.Offset) * x) + e.Offset
											)
										elseif O == "UDim2" then
											return e:Lerp(M, x)
										elseif O == "Vector2" then
											return e:Lerp(M, x)
										elseif O == "Vector2int16" then
											return Vector2int16.new(((M.X - e.X) * x) + e.X, ((M.Y - e.Y) * x) + e.Y)
										elseif O == "Vector3" then
											return e:Lerp(M, x)
										elseif O == "Vector3int16" then
											return Vector3int16.new(
												((M.X - e.X) * x) + e.X,
												((M.Y - e.Y) * x) + e.Y,
												((M.Z - e.Z) * x) + e.Z
											)
										end
									end

									if x < 0.5 then
										return e
									else
										return M
									end
								end
							end)()
						)
					end,
					[10] = function()
						local e, e, M = fn24(10)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e = M(g.Colour.Oklab)

								return function(g, M)
									if M == "number" then
										return g[1]
									elseif M == "CFrame" then
										return CFrame.new(g[1], g[2], g[3])
											* CFrame.fromAxisAngle(Vector3.new(g[4], g[5], g[6]).Unit, g[7])
									elseif M == "Color3" then
										return e.toSRGB(Vector3.new(g[1], g[2], g[3]), false)
									elseif M == "ColorSequenceKeypoint" then
										return ColorSequenceKeypoint.new(
											g[4],
											e.toSRGB(Vector3.new(g[1], g[2], g[3]), false)
										)
									elseif M == "DateTime" then
										return DateTime.fromUnixTimestampMillis(g[1])
									elseif M == "NumberRange" then
										return NumberRange.new(g[1], g[2])
									elseif M == "NumberSequenceKeypoint" then
										return NumberSequenceKeypoint.new(g[2], g[1], g[3])
									elseif M == "PhysicalProperties" then
										return PhysicalProperties.new(g[1], g[2], g[3], g[4], g[5])
									elseif M == "Ray" then
										return Ray.new(Vector3.new(g[1], g[2], g[3]), Vector3.new(g[4], g[5], g[6]))
									elseif M == "Rect" then
										return Rect.new(g[1], g[2], g[3], g[4])
									elseif M == "Region3" then
										local e, x =
											Vector3.new(g[1], g[2], g[3]), Vector3.new(g[4] / 2, g[5] / 2, g[6] / 2)
										return Region3.new(e - x, e + x)
									elseif M == "Region3int16" then
										return Region3int16.new(
											Vector3int16.new(math.round(g[1]), math.round(g[2]), math.round(g[3])),
											Vector3int16.new(math.round(g[4]), math.round(g[5]), math.round(g[6]))
										)
									elseif M == "UDim" then
										return UDim.new(g[1], math.round(g[2]))
									elseif M == "UDim2" then
										return UDim2.new(g[1], math.round(g[2]), g[3], math.round(g[4]))
									elseif M == "Vector2" then
										return Vector2.new(g[1], g[2])
									elseif M == "Vector2int16" then
										return Vector2int16.new(math.round(g[1]), math.round(g[2]))
									elseif M == "Vector3" then
										return Vector3.new(g[1], g[2], g[3])
									elseif M == "Vector3int16" then
										return Vector3int16.new(math.round(g[1]), math.round(g[2]), math.round(g[3]))
									else
										return nil
									end
								end
							end)()
						)
					end,
					[11] = function()
						fn24(11)

						return (
							(function(...)
								return function(g, e, M)
									if (g == 0) or (M == 0) then
										return 1, 0, 0, 1
									end
									local x, O, R, d

									if e > 1 then
										local p = math.sqrt((e ^ 2) - 1)
										local I, E, w = -0.5 / (p * M), (M * (p + e)) * -1, M * (p - e)
										local p, S = math.exp(g * E), math.exp(g * w)
										x, O, R, d =
											((S * E) - (p * w)) * I,
											((p - S) * I) / M,
											((S - p) * I) * M,
											((p * E) - (S * w)) * I
									elseif e == 1 then
										local p = g * M
										local I = p * -1
										local E = math.exp(I)
										x, O, R, d = E * (p + 1), E * g, E * (I * M), E * (I + 1)
									else
										local p = M * math.sqrt(1 - (e ^ 2))
										local I, E, w, S =
											1 / p, math.exp(((-1 * g) * M) * e), math.sin(p * g), math.cos(p * g)
										local g, f = E * w, E * S
										E = ((g * M) * e) * I
										x, O, R, d = E + f, g * I, -1 * ((g * p) + ((M * e) * E)), f - E
									end

									return x, O, R, d
								end
							end)()
						)
					end,
					[12] = function()
						local e, e, M = fn24(12)

						return (
							(function(...)
								local g = M(e.Parent.Parent.Colour.Oklab)

								return function(e, M)
									if M == "number" then
										return { e }
									elseif M == "CFrame" then
										local x, O = e:ToAxisAngle()
										return { e.X, e.Y, e.Z, x.X, x.Y, x.Z, O }
									elseif M == "Color3" then
										local x = g.fromSRGB(e)
										return { x.X, x.Y, x.Z }
									elseif M == "ColorSequenceKeypoint" then
										local x = g.fromSRGB(e.Value)
										return { x.X, x.Y, x.Z, e.Time }
									elseif M == "DateTime" then
										return { e.UnixTimestampMillis }
									elseif M == "NumberRange" then
										return { e.Min, e.Max }
									elseif M == "NumberSequenceKeypoint" then
										return { e.Value, e.Time, e.Envelope }
									elseif M == "PhysicalProperties" then
										return {
											e.Density,
											e.Friction,
											e.Elasticity,
											e.FrictionWeight,
											e.ElasticityWeight,
										}
									elseif M == "Ray" then
										return {
											e.Origin.X,
											e.Origin.Y,
											e.Origin.Z,
											e.Direction.X,
											e.Direction.Y,
											e.Direction.Z,
										}
									elseif M == "Rect" then
										return { e.Min.X, e.Min.Y, e.Max.X, e.Max.Y }
									elseif M == "Region3" then
										return { e.CFrame.X, e.CFrame.Y, e.CFrame.Z, e.Size.X, e.Size.Y, e.Size.Z }
									elseif M == "Region3int16" then
										return { e.Min.X, e.Min.Y, e.Min.Z, e.Max.X, e.Max.Y, e.Max.Z }
									elseif M == "UDim" then
										return { e.Scale, e.Offset }
									elseif M == "UDim2" then
										return { e.X.Scale, e.X.Offset, e.Y.Scale, e.Y.Offset }
									elseif M == "Vector2" then
										return { e.X, e.Y }
									elseif M == "Vector2int16" then
										return { e.X, e.Y }
									elseif M == "Vector3" then
										return { e.X, e.Y, e.Z }
									elseif M == "Vector3int16" then
										return { e.X, e.Y, e.Z }
									else
										return {}
									end
								end
							end)()
						)
					end,
					[14] = function()
						local e, e, M = fn24(14)

						return (
							(function(...)
								local g = M(e.Parent.sRGB)
								local e

								e = {
									fromLinear = function(M)
										local x, O, R =
											((M.R * 0.4122214708) + (M.G * 0.5363325363)) + (M.B * 0.0514459929),
											((M.R * 0.2119034982) + (M.G * 0.6806995451)) + (M.B * 0.1073969566),
											((M.R * 0.0883024619) + (M.G * 0.2817188376)) + (M.B * 0.6299787005)
										local M, d, p =
											x ^ 0.3333333333333333, O ^ 0.3333333333333333, R ^ 0.3333333333333333
										return Vector3.new(
											((M * 0.2104542553) + (d * 0.793617785)) - (p * 0.0040720468),
											((M * 1.9779984951) - (d * 2.428592205)) + (p * 0.4505937099),
											((M * 0.0259040371) + (d * 0.7827717662)) - (p * 0.808675766)
										)
									end,
									fromSRGB = function(M)
										return e.fromLinear(g.toLinear(M))
									end,
									toLinear = function(M, x)
										local O, R, d =
											(M.X + (M.Y * 0.3963377774)) + (M.Z * 0.2158037573),
											(M.X - (M.Y * 0.1055613458)) - (M.Z * 0.0638541728),
											(M.X - (M.Y * 0.0894841775)) - (M.Z * 1.291485548)
										local p, I, E = O ^ 3, R ^ 3, d ^ 3
										O, R, M =
											((p * 4.0767416621) - (I * 3.3077115913)) + (E * 0.2309699292),
											((p * -1.2684380046) + (I * 2.6097574011)) - (E * 0.3413193965),
											((p * -0.0041960863) - (I * 0.7034186147)) + (E * 1.707614701)

										if not x then
											O, R, M = math.clamp(O, 0, 1), (math.clamp(R, 0, 1)), (math.clamp(M, 0, 1))
										end

										return Color3.new(O, R, M)
									end,
									toSRGB = function(M, x)
										return g.fromLinear(e.toLinear(M, x))
									end,
								}

								return e
							end)()
						)
					end,
					[15] = function()
						fn24(15)

						return (
							(function(...)
								local g = {}

								local function e(M)
									if M < 0.04045 then
										return M / 12.92
									end
									return ((M + 0.055) / 1.055) ^ 2.4
								end

								local function M(x)
									if x < 0.0031308 then
										return 12.92 * x
									end
									return (1.055 * (x ^ 0.4166666666666667)) - 0.055
								end

								g.fromLinear = function(x)
									return Color3.new(M(x.R), M(x.G), M(x.B))
								end

								g.toLinear = function(M)
									return Color3.new(e(M.R), e(M.G), e(M.B))
								end

								return g
							end)()
						)
					end,
					[16] = function()
						local e, e, M = fn24(16)

						return (
							(function(...)
								local g = e.Parent
								local e = M(g.Logging.formatError)
								M(g.Types)
								local g, M, x, O = { safetyTimerMultiplier = 1 }, {}, 0

								g.setExternalProvider = function(R)
									local d = O

									if d ~= nil then
										d.stopScheduler()
									end

									local p = d
									O = R

									if R ~= nil then
										R.startScheduler()
									end

									return p
								end

								g.doTaskImmediate = function(R)
									if O == nil then
										g.logError("noTaskScheduler")
									else
										O.doTaskImmediate(R)
									end
								end

								g.doTaskDeferred = function(R)
									if O == nil then
										g.logError("noTaskScheduler")
									else
										O.doTaskDeferred(R)
									end
								end

								g.logError = function(R, d, ...)
									error(e(O, R, d, ...), 0)
								end

								g.logErrorNonFatal = function(R, d, ...)
									local p = e(O, R, d, ...)

									if O ~= nil then
										O.logErrorNonFatal(p)
									else
										print(p)
									end
								end

								g.logWarn = function(R, ...)
									local d = e(O, R, debug.traceback(nil, 2), ...)

									if O ~= nil then
										O.logWarn(d)
									else
										print(d)
									end
								end

								g.bindToUpdateStep = function(e)
									local O = {}
									M[O] = e

									return function()
										M[O] = nil
									end
								end

								g.performUpdateStep = function(e)
									x = e

									for O, O in M, nil, nil do
										O(e)
									end
								end

								g.lastUpdateStep = function()
									return x
								end

								return g
							end)()
						)
					end,
					[17] = function()
						local e, e, M = fn24(17)

						return (
							(function(...)
								M(e.Parent.Types)

								return {
									setDebugger = function(g)
										local e = at

										if e ~= nil then
											e.stopDebugging()
										end

										local M = e
										at = g

										if g ~= nil then
											g.startDebugging()
										end

										return M
									end,
									trackScope = function(g)
										if at == nil then
											return
										end
										at.trackScope(g)
									end,
									untrackScope = function(g)
										if at == nil then
											return
										end
										at.trackScope(g)
									end,
								}
							end)()
						)
					end,
					[19] = function()
						local e, e, M = fn24(19)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d, p, I =
									M(g.External),
									M(g.Memory.checkLifetime),
									M(g.Graph.castToGraph),
									M(g.Graph.depend),
									M(g.Graph.evaluate),
									M(g.Utility.nicknames),
									{ type = "Observer", timeliness = "eager", dependentSet = table.freeze({}) }
								local g = table.freeze({ __index = I })

								local function M(E, w)
									local S = setmetatable({
										scope = E,
										createdAt = os.clock(),
										dependencySet = {},
										lastChange = nil,
										validity = "invalid",
										_watchingGraph = O(w),
										_changeListeners = {},
									}, g)

									local function g()
										S.scope = nil

										for O in pairs(S.dependencySet) do
											O.dependentSet[S] = nil
										end
									end

									S.oldestTask = g
									p[S.oldestTask] = "Observer"
									table.insert(E, g)

									if S._watchingGraph ~= nil then
										x.bOutlivesA(
											E,
											S.oldestTask,
											S._watchingGraph.scope,
											S._watchingGraph.oldestTask,
											x.formatters.observer
										)
									end

									d(S, true)
									return S
								end

								I.onBind = function(g, x)
									e.doTaskImmediate(x)
									return g:onChange(x)
								end

								I.onChange = function(g, x)
									local O = table.freeze({})
									g._changeListeners[O] = x

									return function()
										g._changeListeners[O] = nil
									end
								end

								I._evaluate = function(g)
									if g._watchingGraph ~= nil then
										R(g, g._watchingGraph)
									end

									for x, x in g._changeListeners, nil, nil do
										e.doTaskImmediate(x)
									end

									return true
								end

								table.freeze(I)
								return M
							end)()
						)
					end,
					[20] = function()
						local e, e, M = fn24(20)

						return (
							(function(...)
								M(e.Parent.Parent.Types)

								return function(g)
									if
										(
											(
												((typeof(g) == "table") and (typeof(g.validity) == "string"))
												and (typeof(g.timeliness) == "string")
											) and (typeof(g.dependencySet) == "table")
										) and (typeof(g.dependentSet) == "table")
									then
										return g
									else
										return nil
									end
								end
							end)()
						)
					end,
					[21] = function()
						local e, e, M = fn24(21)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O = M(g.External), M(g.Graph.evaluate), 1

								return function(g)
									if g.validity == "busy" then
										return e.logError("infiniteLoop")
									end

									if not x(g, true) then
										return
									end
									local M, R = {}, {}
									M[1] = g
									local g, d = os.clock() + (O * e.safetyTimerMultiplier), {}

									repeat
										local O
										if os.clock() > g then
											return e.logError("infiniteLoop")
										end
										O = true

										for g, g in M, nil, nil do
											for e in g.dependentSet, nil, nil do
												if e.validity == "valid" then
													table.insert(R, e)
													table.insert(d, e)
													O = false
												end
											end
										end

										table.clear(M)
										M, d = d, M
									until O

									d = {}

									for g, g in R, nil, nil do
										g.validity = "invalid"

										if g.timeliness == "eager" then
											table.insert(d, g)
										end
									end

									table.sort(d, function(g, e)
										return g.createdAt < e.createdAt
									end)

									for g, g in d, nil, nil do
										x(g, false)
									end
								end
							end)()
						)
					end,
					[22] = function()
						local e, e, M = fn24(22)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d =
									M(g.External),
									M(g.Graph.evaluate),
									M(g.Graph.castToGraph),
									M(g.State.castToState),
									M(g.Utility.nameOf)

								return function(g, M)
									if O(M) then
										x(M, false)

										if table.isfrozen(g.dependencySet) or (table.isfrozen(M.dependentSet)) then
											e.logError("cannotDepend", nil, d(g, "Dependent"), d(M, "dependency"))
										end

										M.dependentSet[g] = true
										g.dependencySet[M] = true

										if R(M) then
											return M._EXTREMELY_DANGEROUS_usedAsValue
										else
											return nil
										end
									end

									return M
								end
							end)()
						)
					end,
					[23] = function()
						local e, e, M = fn24(23)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e = M(g.External)

								local function g(M, x)
									if M.validity == "busy" then
										return e.logError("infiniteLoop")
									end
									local e = M.lastChange == nil

									if (e or (M.validity == "invalid")) or x then
										local O = e or x

										if not O then
											for x in M.dependencySet, nil, nil do
												g(x, false)
												if x.lastChange > M.lastChange then
													O = true
													break
												end
											end
										end

										local x = false

										if O then
											for O in M.dependencySet, nil, nil do
												O.dependentSet[M] = nil
												M.dependencySet[O] = nil
											end

											M.validity = "busy"
											x = M:_evaluate() or e
										end

										if x then
											M.lastChange = os.clock()
										end

										M.validity = "valid"
										return x
									else
										return false
									end
								end

								return g
							end)()
						)
					end,
					[25] = function()
						local e, e, M = fn24(25)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d =
									M(g.Memory.checkLifetime),
									M(g.Graph.Observer),
									M(g.State.castToState),
									M(g.State.peek),
									{}

								return function(g)
									local M = d[g]

									if M == nil then
										M = {
											type = "SpecialKey",
											kind = "Attribute",
											stage = "self",
											apply = function(p, p, I, E)
												if O(I) then
													local O = I
													e.bOutlivesA(
														p,
														E,
														O.scope,
														O.oldestTask,
														e.formatters.boundAttribute,
														g
													)

													x(p, O):onBind(function()
														E:SetAttribute(g, R(O))
													end)
												else
													E:SetAttribute(g, I)
												end
											end,
										}

										d[g] = M
									end

									return M
								end
							end)()
						)
					end,
					[26] = function()
						local e, e, M = fn24(26)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x = M(g.External), {}

								return function(g)
									local M = x[g]

									if M == nil then
										M = {
											type = "SpecialKey",
											kind = "AttributeChange",
											stage = "observer",
											apply = function(O, O, R, d)
												if typeof(R) ~= "function" then
													e.logError("invalidAttributeChangeHandler", nil, g)
												end

												local e, p = d:GetAttributeChangedSignal(g), R

												table.insert(
													O,
													e:Connect(function()
														p(d:GetAttribute(g))
													end)
												)
											end,
										}

										x[g] = M
									end

									return M
								end
							end)()
						)
					end,
					[27] = function()
						local e, e, M = fn24(27)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R = M(g.External), M(g.Memory.checkLifetime), M(g.State.castToState), {}

								return function(g)
									local M = R[g]

									if M == nil then
										M = {
											type = "SpecialKey",
											kind = "AttributeOut",
											stage = "observer",
											apply = function(d, p, I, E)
												d = E:GetAttributeChangedSignal(g)

												if not O(I) then
													e.logError("invalidAttributeOutType")
												end

												if I.kind ~= "Value" then
													e.logError("invalidAttributeOutType")
												end

												local e = I
												x.bOutlivesA(
													p,
													E,
													e.scope,
													e.oldestTask,
													x.formatters.attributeOutputsTo,
													g
												)
												e:set(E:GetAttribute(g))

												table.insert(
													p,
													d:Connect(function()
														e:set(E:GetAttribute(g))
													end)
												)
											end,
										}

										R[g] = M
									end

									return M
								end
							end)()
						)
					end,
					[28] = function()
						local e, e, M = fn24(28)

						return (
							(function(...)
								M(e.Parent.Parent.Types)

								return function(g)
									return g
								end
							end)()
						)
					end,
					[29] = function()
						local e, e, M = fn24(29)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d, p =
									M(g.External),
									M(g.Graph.Observer),
									M(g.State.peek),
									M(g.State.castToState),
									M(g.Memory.doCleanup),
									false

								return {
									type = "SpecialKey",
									kind = "Children",
									stage = "descendants",
									apply = function(g, g, M, I)
										local E, w, S, f = {}, {}, {}, {}

										local function a()
											w, E, f, S = E, w, S, f

											local function n(Q, Z)
												local t = typeof(Q)

												if t == "Instance" then
													E[Q] = true

													if w[Q] == nil then
														Q.Parent = I
													else
														w[Q] = nil
													end

													if p and (Z ~= nil) then
														Q.Name = Z
													end
												elseif R(Q) then
													local R = O(Q)

													if R ~= nil then
														n(R, Z)
													end

													R = f[Q]

													if R == nil then
														R = {}
														x(R, Q):onChange(a)
													else
														f[Q] = nil
													end

													S[Q] = R
												elseif t == "table" then
													for x, O in pairs(Q) do
														local R = typeof(x)
														n(
															O,
															if R == "string"
																then x
																else if (R == "number") and (Z ~= nil)
																	then Z .. ("_" .. x)
																	else nil
														)
													end
												else
													e.logWarn("unrecognisedChildType", t)
												end
											end

											if M ~= nil then
												n(M)
											end

											for e in pairs(w) do
												e.Parent = nil
											end

											table.clear(w)

											for e, e in pairs(f) do
												d(e)
											end

											table.clear(f)
										end

										table.insert(g, function()
											M = nil
											a()
										end)

										a()
									end,
								}
							end)()
						)
					end,
					[30] = function()
						local e, e, M = fn24(30)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e = M(g.Instances.applyInstanceProps)

								return function(g, M)
									return function(x)
										table.insert(g, M)
										e(g, x, M)
										return M
									end
								end
							end)()
						)
					end,
					[31] = function()
						local e, e, M = fn24(31)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O =
									M(g.External), M(g.Instances.defaultProps), M(g.Instances.applyInstanceProps)

								return function(g, M)
									return function(R)
										local d, p = pcall(Instance.new, M)

										if not d then
											e.logError("cannotCreateClass", nil, M)
										end

										d = x[M]

										if d ~= nil then
											for e, M in pairs(d) do
												p[e] = M
											end
										end

										table.insert(g, p)
										O(g, R, p)
										return p
									end
								end
							end)()
						)
					end,
					[32] = function()
						local e, e, M = fn24(32)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x = M(g.External), {}

								return function(g)
									local M = x[g]

									if M == nil then
										M = {
											type = "SpecialKey",
											kind = "OnChange",
											stage = "observer",
											apply = function(O, O, R, d)
												local p, I = pcall(d.GetPropertyChangedSignal, d, g)

												if not p then
													e.logError("cannotConnectChange", nil, d.ClassName, g)
												elseif typeof(R) ~= "function" then
													e.logError("invalidChangeHandler", nil, g)
												else
													local e = R

													table.insert(
														O,
														I:Connect(function()
															e(d[g])
														end)
													)
												end
											end,
										}

										x[g] = M
									end

									return M
								end
							end)()
						)
					end,
					[33] = function()
						local e, e, M = fn24(33)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x = M(g.External), {}

								local function g(M, O)
									return M[O]
								end

								return function(M)
									local O = x[M]

									if O == nil then
										O = {
											type = "SpecialKey",
											kind = "OnEvent",
											stage = "observer",
											apply = function(R, R, d, p)
												local I, E = pcall(g, p, M)

												if not I or (typeof(E) ~= "RBXScriptSignal") then
													e.logError("cannotConnectEvent", nil, p.ClassName, M)
												elseif typeof(d) ~= "function" then
													e.logError("invalidEventHandler", nil, M)
												else
													table.insert(R, E:Connect(d))
												end
											end,
										}

										x[M] = O
									end

									return O
								end
							end)()
						)
					end,
					[34] = function()
						local e, e, M = fn24(34)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R = M(g.External), M(g.Memory.checkLifetime), M(g.State.castToState), {}

								return function(g)
									local M = R[g]

									if M == nil then
										M = {
											type = "SpecialKey",
											kind = "Out",
											stage = "observer",
											apply = function(d, d, p, I)
												local E, w = pcall(I.GetPropertyChangedSignal, I, g)

												if not E then
													e.logError("invalidOutProperty", nil, I.ClassName, g)
												end

												if not O(p) then
													e.logError("invalidOutType")
												end

												if p.kind ~= "Value" then
													e.logError("invalidOutType")
												end

												local e = p
												x.bOutlivesA(
													d,
													I,
													e.scope,
													e.oldestTask,
													x.formatters.propertyOutputsTo,
													g
												)
												e:set(I[g])

												table.insert(
													d,
													w:Connect(function()
														e:set(I[g])
													end)
												)
											end,
										}

										R[g] = M
									end

									return M
								end
							end)()
						)
					end,
					[35] = function()
						local e, e, M = fn24(35)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d =
									M(g.Memory.checkLifetime),
									M(g.Graph.Observer),
									M(g.State.castToState),
									M(g.State.peek),
									{}

								return function(g)
									local M = d[g]

									if M == nil then
										M = {
											type = "SpecialKey",
											kind = "Tag",
											stage = "self",
											apply = function(p, p, I, E)
												if O(I) then
													local O = I
													e.bOutlivesA(p, E, O.scope, O.oldestTask, e.formatters.boundTag, g)

													x(p, O):onBind(function()
														if R(O) == true then
															E:AddTag(g)
														elseif E:HasTag(g) then
															E:RemoveTag(g)
														end
													end)
												elseif I == true then
													E:AddTag(g)
												end
											end,
										}

										d[g] = M
									end

									return M
								end
							end)()
						)
					end,
					[36] = function()
						local e, e, M = fn24(36)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d, p, I =
									M(g.External),
									M(g.Logging.parseError),
									M(g.Memory.checkLifetime),
									M(g.Graph.Observer),
									M(g.State.castToState),
									M(g.State.peek),
									M(g.Utility.xtypeof)

								local function g(M, E, w)
									M[E] = w
								end

								local function M(E, w)
									E[w] = E[w]
								end

								local function E(w, S, f)
									local a, n = xpcall(g, x, w, S, f)

									if not a then
										if not pcall(M, w, S) then
											e.logErrorNonFatal("cannotAssignProperty", nil, w.ClassName, S)
										else
											local g, M = typeof(f), typeof(w[S])

											if g == M then
												e.logErrorNonFatal("propertySetError", n)
											else
												e.logErrorNonFatal("invalidPropertyType", nil, w.ClassName, S, M, g)
											end
										end
									end
								end

								local function g(M, x, w, S)
									if d(S) then
										local d = S
										O.bOutlivesA(M, x, d.scope, d.oldestTask, O.formatters.boundProperty, w)

										R(M, d):onBind(function()
											E(x, w, p(d))
										end)
									else
										E(x, w, S)
									end
								end

								return function(M, x, O)
									local R = { self = {}, descendants = {}, ancestor = {}, observer = {} }

									for d, p in pairs(x) do
										local E = I(d)

										if E == "string" then
											if d ~= "Parent" then
												g(M, O, d, p)
											end
										elseif E == "SpecialKey" then
											local I = d.stage
											local w = R[I]

											if w == nil then
												e.logError("unrecognisedPropertyStage", nil, I)
											else
												w[d] = p
											end
										else
											e.logError("unrecognisedPropertyKey", nil, E)
										end
									end

									for e, d in pairs(R.self) do
										e:apply(M, d, O)
									end

									for e, d in pairs(R.descendants) do
										e:apply(M, d, O)
									end

									if x.Parent ~= nil then
										g(M, O, "Parent", x.Parent)
									end

									for g, e in pairs(R.ancestor) do
										g:apply(M, e, O)
									end

									for g, e in pairs(R.observer) do
										g:apply(M, e, O)
									end
								end
							end)()
						)
					end,
					[37] = function()
						fn24(37)

						return (
							(function(...)
								return {
									ScreenGui = { ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
									BillboardGui = {
										ResetOnSpawn = false,
										ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
										Active = true,
									},
									SurfaceGui = {
										ResetOnSpawn = false,
										ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
										SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
										PixelsPerStud = 50,
									},
									Frame = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
									},
									ScrollingFrame = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
										ScrollBarImageColor3 = Color3.new(0, 0, 0),
									},
									TextLabel = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
										Font = Enum.Font.SourceSans,
										Text = "",
										TextColor3 = Color3.new(0, 0, 0),
										TextSize = 14,
									},
									TextButton = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
										AutoButtonColor = false,
										Font = Enum.Font.SourceSans,
										Text = "",
										TextColor3 = Color3.new(0, 0, 0),
										TextSize = 14,
									},
									TextBox = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
										ClearTextOnFocus = false,
										Font = Enum.Font.SourceSans,
										Text = "",
										TextColor3 = Color3.new(0, 0, 0),
										TextSize = 14,
									},
									ImageLabel = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
									},
									ImageButton = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
										AutoButtonColor = false,
									},
									ViewportFrame = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
									},
									VideoFrame = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
									},
									CanvasGroup = {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BorderColor3 = Color3.new(0, 0, 0),
										BorderSizePixel = 0,
									},
									SpawnLocation = { Duration = 0 },
									BoxHandleAdornment = { ZIndex = 0 },
									ConeHandleAdornment = { ZIndex = 0 },
									CylinderHandleAdornment = { ZIndex = 0 },
									ImageHandleAdornment = { ZIndex = 0 },
									LineHandleAdornment = { ZIndex = 0 },
									SphereHandleAdornment = { ZIndex = 0 },
									WireframeHandleAdornment = { ZIndex = 0 },
									Part = {
										Anchored = true,
										Size = Vector3.one,
										FrontSurface = Enum.SurfaceType.Smooth,
										BackSurface = Enum.SurfaceType.Smooth,
										LeftSurface = Enum.SurfaceType.Smooth,
										RightSurface = Enum.SurfaceType.Smooth,
										TopSurface = Enum.SurfaceType.Smooth,
										BottomSurface = Enum.SurfaceType.Smooth,
									},
									TrussPart = {
										Anchored = true,
										Size = Vector3.one * 2,
										FrontSurface = Enum.SurfaceType.Smooth,
										BackSurface = Enum.SurfaceType.Smooth,
										LeftSurface = Enum.SurfaceType.Smooth,
										RightSurface = Enum.SurfaceType.Smooth,
										TopSurface = Enum.SurfaceType.Smooth,
										BottomSurface = Enum.SurfaceType.Smooth,
									},
									MeshPart = {
										Anchored = true,
										Size = Vector3.one,
										FrontSurface = Enum.SurfaceType.Smooth,
										BackSurface = Enum.SurfaceType.Smooth,
										LeftSurface = Enum.SurfaceType.Smooth,
										RightSurface = Enum.SurfaceType.Smooth,
										TopSurface = Enum.SurfaceType.Smooth,
										BottomSurface = Enum.SurfaceType.Smooth,
									},
									CornerWedgePart = {
										Anchored = true,
										Size = Vector3.one,
										FrontSurface = Enum.SurfaceType.Smooth,
										BackSurface = Enum.SurfaceType.Smooth,
										LeftSurface = Enum.SurfaceType.Smooth,
										RightSurface = Enum.SurfaceType.Smooth,
										TopSurface = Enum.SurfaceType.Smooth,
										BottomSurface = Enum.SurfaceType.Smooth,
									},
									VehicleSeat = {
										Anchored = true,
										Size = Vector3.one,
										FrontSurface = Enum.SurfaceType.Smooth,
										BackSurface = Enum.SurfaceType.Smooth,
										LeftSurface = Enum.SurfaceType.Smooth,
										RightSurface = Enum.SurfaceType.Smooth,
										TopSurface = Enum.SurfaceType.Smooth,
										BottomSurface = Enum.SurfaceType.Smooth,
									},
								}
							end)()
						)
					end,
					[39] = function()
						local e, e, M = fn24(39)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x =
									M(g.Logging.messages), "https://elttob.uk/Fusion/0.3/api-reference/general/errors/#"

								return function(g, M, O, ...)
									local R, d, p, I =
										if typeof(O) == "table" then O else nil,
										if typeof(O) == "table" then O.trace else O,
										e[M],
										M

									if p == nil then
										p, M = e.unknownMessage, "unknownMessage"
									else
										M = I
									end

									p = p:format(...)

									if R ~= nil then
										p = p:gsub("ERROR_MESSAGE", R.message)
										p = if R.context ~= nil then p .. (" (%*)"):format(R.context) else p
									else
										p = (p:gsub("ERROR_MESSAGE", I))
									end

									p = ("[Fusion] %* \nID: %*"):format(p, M)
									p = if (g ~= nil) and g.policies.allowWebLinks
										then p .. ("\nLearn more: %*%*"):format(x, M:lower())
										else p
									return (if d ~= nil then p .. (" \n---- Stack trace ----\n%*"):format(d) else p):gsub(
										"\n",
										"\n    "
									)
								end
							end)()
						)
					end,
					[40] = function()
						fn24(40)

						return (
							(function(...)
								return {
									callbackError = "Error in callback:\nERROR_MESSAGE",
									cannotAssignProperty = "The class type '%s' has no assignable property '%s'.",
									cannotConnectChange = "The %s class doesn't have a property called '%s'.",
									cannotConnectEvent = "The %s class doesn't have an event called '%s'.",
									cannotCreateClass = "Can't create a new instance of class '%s'.",
									cannotDepend = "%s can't depend on %s.",
									destroyedTwice = "`doCleanup()` was given something that it is already cleaning up. Unclear how to proceed.",
									forKeyCollision = "The key '%s' was returned multiple times simultaneously, which is not allowed in `For` objects.",
									infiniteLoop = "Detected an infinite loop. Consider adding an explicit breakpoint to your code to prevent a cyclic dependency.",
									invalidAttributeChangeHandler = "The change handler for the '%s' attribute must be a function.",
									invalidAttributeOutType = "[AttributeOut] properties must be given Value objects.",
									invalidChangeHandler = "The change handler for the '%s' property must be a function.",
									invalidEventHandler = "The handler for the '%s' event must be a function.",
									invalidOutProperty = "The %s class doesn't have a property called '%s'.",
									invalidOutType = "[Out] properties must be given Value objects.",
									invalidPropertyType = "'%s.%s' expected a '%s' type, but got a '%s' type.",
									invalidSpringDamping = "The damping ratio for a spring must be >= 0. (damping was %.2f)",
									invalidSpringSpeed = "The speed of a spring must be >= 0. (speed was %.2f)",
									mergeConflict = "Multiple definitions for '%s' found while merging.",
									mistypedSpringDamping = "The damping ratio for a spring must be a number. (got a %s)",
									mistypedSpringSpeed = "The speed of a spring must be a number. (got a %s)",
									mistypedTweenInfo = "The tween info of a tween must be a TweenInfo. (got a %s)",
									noTaskScheduler = "Fusion is not connected to an external task scheduler.",
									poisonedScope = "Attempted to use a scope after it's been destroyed; %s",
									propertySetError = "Error setting property:\nERROR_MESSAGE",
									springNanGoal = "A spring was given a NaN goal, so some simulation has been skipped. Ensure no springs have NaN goals.",
									springNanMotion = "A spring encountered NaN during motion, so has snapped to the goal position. Ensure no springs have NaN positions or velocities.",
									springTypeMismatch = "The type '%s' doesn't match the spring's type '%s'.",
									tweenNanGoal = "A tween was given a NaN goal, so some animation has been skipped. Ensure no tweens have NaN goals.",
									tweenNanMotion = "A tween encountered NaN during motion, so has snapped to the goal. Ensure no tweens have NaN in their tween infos.",
									unknownMessage = "Unknown error:\nERROR_MESSAGE",
									unrecognisedChildType = "'%s' type children aren't accepted by `[Children]`.",
									unrecognisedPropertyKey = "'%s' keys aren't accepted in property tables.",
									unrecognisedPropertyStage = "'%s' isn't a valid stage for a special key to be applied at.",
									useAfterDestroy = "%s is no longer valid - it was destroyed before %s. See discussion #292 on GitHub for advice.",
								}
							end)()
						)
					end,
					[41] = function()
						local e, e, M = fn24(41)

						return (
							(function(...)
								M(e.Parent.Parent.Types)

								return function(g)
									return {
										type = "Error",
										raw = g,
										message = g:gsub("^.+:%d+:%s*", ""),
										trace = debug.traceback(nil, 2),
									}
								end
							end)()
						)
					end,
					[43] = function()
						local e, e, M = fn24(43)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O = M(g.External), M(g.Utility.nameOf), { formatters = {} }

								O.formatters.useFunction = function(g, M)
									local R = x(g, "object")
									return ("The use()-d %*"):format((x(M, "object"))), (("the %*"):format(R))
								end

								O.formatters.boundProperty = function(g, M, R)
									local d = g.Name
									return ("The %* (bound to the %* property)"):format(x(M, "value"), R),
										(("the %* instance"):format(d))
								end

								O.formatters.boundAttribute = function(g, M, R)
									local d = g.Name
									return ("The %* (bound to the %* attribute)"):format(x(M, "value"), R),
										(("the %* instance"):format(d))
								end

								O.formatters.boundTag = function(g, M, R)
									local d = g.Name
									return ("The %* (bound to the %* CollectionService tag)"):format(x(M, "value"), R),
										(("the %* instance"):format(d))
								end

								O.formatters.propertyOutputsTo = function(g, M, R)
									local d = g.Name
									return ("The %* (which the %* property outputs to)"):format(x(M, "object"), R),
										(("the %* instance"):format(d))
								end

								O.formatters.attributeOutputsTo = function(g, M, R)
									local d = g.Name
									return ("The %* (which the %* attribute outputs to)"):format(x(M, "object"), R),
										(("the %* instance"):format(d))
								end

								O.formatters.refOutputsTo = function(g, M)
									local R = g.Name
									return ("The %* (which the Ref key outputs to)"):format((x(M, "object"))),
										(("the %* instance"):format(R))
								end

								O.formatters.animationGoal = function(g, M)
									local R = x(g, "object")
									return ("The goal %*"):format((x(M, "object"))),
										(("the %* that is following it"):format(R))
								end

								O.formatters.parameter = function(g, M, R)
									local d, p = x(g, "object"), x(M, "object")

									if R == false then
										return ("The %* parameter"):format(p),
											(("the %* that it was used for"):format(d))
									else
										return ("The %* representing the %* parameter"):format(p, R),
											(("the %* that it was used for"):format(d))
									end
								end

								O.formatters.observer = function(g, M)
									local R = x(g, "object")
									return ("The watched %*"):format((x(M, "object"))),
										(("the %* that's observing it for changes"):format(R))
								end

								O.bOutlivesA = function(g, g, M, x, R, ...)
									if M == nil then
										e.logError("useAfterDestroy", nil, R(g, x, ...))
									end
								end

								return O
							end)()
						)
					end,
					[44] = function()
						local e, e, M = fn24(44)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x = M(g.ExternalDebug), M(g.Memory.deriveScopeImpl)

								return function(...)
									local g = x(...)
									e.trackScope(g)
									return g
								end
							end)()
						)
					end,
					[45] = function()
						local e, e, M = fn24(45)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e = M(g.Utility.merge)

								return function(g, M, ...)
									local x = getmetatable(g)

									if M ~= nil then
										x = table.clone(x)
										x.__index = e(true, {}, x.__index, e(false, {}, M, ...))
									end

									return setmetatable({}, x)
								end
							end)()
						)
					end,
					[46] = function()
						local e, e, M = fn24(46)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O = M(g.External), M(g.ExternalDebug), {}

								local function g(M)
									if O[M] then
										return e.logError("destroyedTwice")
									end
									O[M] = true

									local e, R = pcall(function()
										if typeof(M) == "Instance" then
											M:Destroy()
										elseif typeof(M) == "RBXScriptConnection" then
											M:Disconnect()
										elseif typeof(M) == "function" then
											M()
										elseif typeof(M) == "table" then
											if typeof(M.destroy) == "function" then
												M:destroy()
											elseif typeof(M.Destroy) == "function" then
												M:Destroy()
											elseif M[1] ~= nil then
												for d = #M, 1, -1 do
													g(M[d])
													M[d] = nil
												end

												x.untrackScope(M)
											end
										end
									end)

									O[M] = nil

									if not e then
										error(R, 0)
									end
								end

								return g
							end)()
						)
					end,
					[47] = function()
						local e, e, M = fn24(47)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x = M(g.ExternalDebug), M(g.Memory.deriveScopeImpl)

								return function(g, ...)
									local M = x(g, ...)
									table.insert(g, M)

									table.insert(M, function()
										local x = table.find(g, M)

										if x ~= nil then
											table.remove(g, x)
										end
									end)

									e.trackScope(M)
									return M
								end
							end)()
						)
					end,
					[48] = function()
						local e, e, M = fn24(48)

						return (
							(function(...)
								M(e.Parent.Parent.Types)

								return function(g, ...)
									for e = 1, select("#", ...), 1 do
										table.insert(g, select(e, ...))
									end

									return ...
								end
							end)()
						)
					end,
					[49] = function()
						fn24(49)

						return (
							(function(...)
								return function(g)
									return typeof(g) == "Instance"
								end
							end)()
						)
					end,
					[50] = function()
						local e, e, M = fn24(50)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x = M(g.ExternalDebug), M(g.Utility.merge)

								return function(...)
									local g = setmetatable({}, { __index = x(false, {}, ...) })
									e.trackScope(g)
									return g
								end
							end)()
						)
					end,
					[51] = function()
						local e, e, M = fn24(51)

						return (
							(function(...)
								local x, O, R = v45.RunService, v45.HttpService, M(e.Parent.External)

								local g = {
									policies = { allowWebLinks = x:IsStudio() },
									doTaskImmediate = function(e)
										task.spawn(e)
									end,
									doTaskDeferred = function(e)
										task.defer(e)
									end,
									logErrorNonFatal = function(e)
										task.spawn(error, e, 0)
									end,
									logWarn = warn,
								}

								local function e()
									R.performUpdateStep(os.clock())
								end

								local M

								g.startScheduler = function()
									if M ~= nil then
										return
									end

									if x:IsClient() then
										local R = "FusionUpdateStep_" .. O:GenerateGUID()
										x:BindToRenderStep(R, Enum.RenderPriority.First.Value, e)

										function M()
											x:UnbindFromRenderStep(R)
										end
									else
										local O = x.Heartbeat:Connect(e)

										function M()
											O:Disconnect()
										end
									end
								end

								g.stopScheduler = function()
									if M ~= nil then
										M()
										M = nil
									end
								end

								return g
							end)()
						)
					end,
					[53] = function()
						local e, e, M = fn24(53)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d, p, I, E, w, S, f =
									M(g.External),
									M(g.Logging.parseError),
									M(g.Utility.isSimilar),
									M(g.Graph.depend),
									M(g.State.castToState),
									M(g.State.peek),
									M(g.Memory.doCleanup),
									M(g.Memory.deriveScope),
									M(g.Memory.checkLifetime),
									M(g.Utility.nicknames),
									{ type = "State", kind = "Computed", timeliness = "lazy" }
								local g = table.freeze({ __index = f })

								local function M(a, n)
									local Q = setmetatable({
										createdAt = os.clock(),
										dependencySet = {},
										dependentSet = {},
										lastChange = nil,
										scope = a,
										validity = "invalid",
										_EXTREMELY_DANGEROUS_usedAsValue = nil,
										_innerScope = nil,
										_processor = n,
									}, g)

									local function g()
										Q.scope = nil

										for n in pairs(Q.dependencySet) do
											n.dependentSet[Q] = nil
										end

										if Q._innerScope ~= nil then
											I(Q._innerScope)
											Q._innerScope = nil
										end
									end

									Q.oldestTask = g
									S[Q.oldestTask] = "Computed"
									table.insert(a, g)
									return Q
								end

								f._evaluate = function(g)
									if g.scope == nil then
										return false
									end
									local S = g.scope
									local a = E(S)

									local E, n = xpcall(g._processor, x, function(x)
										local Q = d(x)

										if Q ~= nil then
											w.bOutlivesA(
												S,
												g.oldestTask,
												Q.scope,
												Q.oldestTask,
												w.formatters.useFunction
											)
											R(g, Q)
										end

										return p(x)
									end, a)

									if E then
										local x = O(g._EXTREMELY_DANGEROUS_usedAsValue, n)

										if g._innerScope ~= nil then
											I(g._innerScope)
											g._innerScope = nil
										end

										g._innerScope = a
										g._EXTREMELY_DANGEROUS_usedAsValue = n
										return not x
									else
										I(a)
										e.logErrorNonFatal("callbackError", n)
										return false
									end
								end

								table.freeze(f)
								return M
							end)()
						)
					end,
					[54] = function()
						local e, e, M = fn24(54)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O = M(g.Graph.depend), M(g.State.peek), M(g.State.castToState)
								M(g.State.For.ForTypes)
								local R, d, p =
									M(g.Utility.nicknames),
									M(g.State.For.Disassembly),
									{ type = "State", kind = "For", timeliness = "lazy" }
								local g = table.freeze({ __index = p })

								local function M(I, E, w)
									local S = setmetatable({
										createdAt = os.clock(),
										dependencySet = {},
										dependentSet = {},
										scope = I,
										validity = "invalid",
										_EXTREMELY_DANGEROUS_usedAsValue = {},
										_disassembly = d(I, E, w),
									}, g)

									local function g()
										S.scope = nil

										for d in pairs(S.dependencySet) do
											d.dependentSet[S] = nil
										end
									end

									S.oldestTask = g
									R[S.oldestTask] = "For"
									table.insert(I, g)
									return S
								end

								p._evaluate = function(g)
									if g.scope == nil then
										return false
									end
									local R = g.scope
									e(g, g._disassembly)
									table.clear(g._EXTREMELY_DANGEROUS_usedAsValue)

									g._disassembly:populate(function(R)
										local d = O(R)

										if d ~= nil then
											e(g, d)
										end

										return x(R)
									end, g._EXTREMELY_DANGEROUS_usedAsValue)

									return true
								end

								table.freeze(p)
								return M
							end)()
						)
					end,
					[55] = function()
						local e, e, M = fn24(55)

						return (
							(function(...)
								local g = e.Parent.Parent.Parent
								M(g.Types)
								local e, x, O, R =
									M(g.External), M(g.Graph.depend), M(g.State.peek), M(g.State.castToState)
								M(g.State.For.ForTypes)
								local d, p, I, E, w =
									M(g.Memory.doCleanup),
									M(g.Memory.deriveScope),
									M(g.Utility.nameOf),
									M(g.Utility.nicknames),
									{ type = "Graph", kind = "For.Disassembly", timeliness = "lazy" }
								local g = table.freeze({ __index = w })

								local function M(S, f, a)
									local n = setmetatable({
										createdAt = os.clock(),
										dependencySet = {},
										dependentSet = {},
										scope = S,
										validity = "invalid",
										_inputTable = f,
										_constructor = a,
										_subObjects = {},
									}, g)

									local function g()
										n.scope = nil

										for f in pairs(n.dependencySet) do
											f.dependentSet[n] = nil
										end

										for f in n._subObjects, nil, nil do
											if f.maybeScope ~= nil then
												d(f.maybeScope)
												f.maybeScope = nil
											end
										end
									end

									n.oldestTask = g
									E[n.oldestTask] = "For (internal disassembler)"
									table.insert(S, g)
									return n
								end

								w.populate = function(g, E, S)
									local f, a, n = false, math.huge, -math.huge

									for Q in g._subObjects, nil, nil do
										local Z, t = Q:useOutputPair(E)

										if (Z == nil) or (t == nil) then
											f = true
											continue
										elseif S[Z] ~= nil then
											e.logErrorNonFatal("forKeyCollision", nil, tostring(Z))
											continue
										end

										S[Z] = t

										if typeof(Z) == "number" then
											a, n = (math.min(a, Z)), (math.max(n, Z))
										end
									end

									if f and (n > a) then
										E = a

										for f = a, n, 1 do
											g = S[f]
											if g == nil then
												continue
											end
											S[f] = nil
											S[E] = g
											E += 1
										end
									end
								end

								w._evaluate = function(g)
									local E, S = g.scope, R(g._inputTable)

									if S ~= nil then
										if S.scope == nil then
											e.logError(
												"useAfterDestroy",
												nil,
												("The input %*"):format(I(S, "table")),
												"the For object that is watching it"
											)
										end

										x(g, S)
									end

									S = {}

									for e, x in O(g._inputTable) do
										S[e] = x
									end

									local e = {}

									for x in g._subObjects, nil, nil do
										local O, R, I, f = false, x.inputKey, x.inputValue

										if not x.roamKeys and (S[R] ~= nil) then
											O, f = true, R
										else
											for a, n in S, nil, nil do
												O = true
												if x.roamValues then
													f = a
													break
												end

												if n == I then
													f = a
													break
												end
												f = a
											end
										end

										if O then
											local O = S[f]
											e[x] = true

											if f ~= R then
												x.inputKey = f
												x:invalidateInputKey()
											end

											if O ~= I then
												x.inputValue = O
												x:invalidateInputValue()
											end

											S[f] = nil
										elseif x.maybeScope ~= nil then
											d(x.maybeScope)
											x.maybeScope = nil
										end
									end

									for x, O in S, nil, nil do
										e[g._constructor(p(E), x, O)] = true
									end

									g._subObjects = e
									return true
								end

								table.freeze(w)
								return M
							end)()
						)
					end,
					[56] = function()
						local e, e, M = fn24(56)

						return ((function(...)
							M(e.Parent.Parent.Parent.Types)
							return nil
						end)())
					end,
					[57] = function()
						local e, e, M = fn24(57)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R, d =
									M(g.External),
									M(g.Memory.doCleanup),
									M(g.State.For),
									M(g.State.Value),
									M(g.State.Computed)
								M(g.State.For.ForTypes)

								local p, I =
									M(g.Logging.parseError), { __index = {
										roamKeys = false,
										roamValues = true,
										invalidateInputKey = function(g)
											g._inputKeyState:set(g.inputKey)
										end,
										invalidateInputValue = function(g) end,
										useOutputPair = function(g, M)
											return M(g._outputKeyState), g.inputValue
										end,
									} }

								local function g(M, E, w, S)
									local f

									f = {
										maybeScope = M,
										inputKey = E,
										inputValue = w,
										_inputKeyState = R(M, E),
										_processor = S,
										_outputKeyState = d(M, function(M, R)
											local d = M(f._inputKeyState)
											local E, w = xpcall(f._processor, p, M, R, d)

											if E then
												return w
											else
												w.context = ("while processing key %*"):format(tostring(d))
												e.logErrorNonFatal("callbackError", w)
												x(R)
												table.clear(R)
												return nil
											end
										end),
									}

									return (setmetatable(f, I))
								end

								return function(e, M, x)
									return O(e, M, function(e, M, O)
										return g(e, M, O, x)
									end)
								end
							end)()
						)
					end,
					[58] = function()
						local e, e, M = fn24(58)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R = M(g.External), M(g.State.For), M(g.State.Value), M(g.State.Computed)
								M(g.State.For.ForTypes)

								local d, p, I =
									M(g.Logging.parseError), M(g.Memory.doCleanup), { __index = {
										roamKeys = false,
										roamValues = false,
										invalidateInputKey = function(g)
											g._inputKeyState:set(g.inputKey)
										end,
										invalidateInputValue = function(g)
											g._inputValueState:set(g.inputValue)
										end,
										useOutputPair = function(g, M)
											local E = M(g._outputPairState)
											return E.key, E.value
										end,
									} }

								local function g(M, E, w, S)
									local f

									f = {
										maybeScope = M,
										inputKey = E,
										inputValue = w,
										_inputKeyState = O(M, E),
										_inputValueState = O(M, w),
										_processor = S,
										_outputPairState = R(M, function(M, O)
											local R, E = M(f._inputKeyState), M(f._inputValueState)
											local w, S, a = xpcall(f._processor, d, M, O, R, E)

											if w then
												return { key = S, value = a }
											else
												S.context = ("while processing key %* and value %*"):format(
													tostring(E),
													tostring(E)
												)
												e.logErrorNonFatal("callbackError", S)
												p(O)
												table.clear(O)
												return { key = nil, value = nil }
											end
										end),
									}

									return (setmetatable(f, I))
								end

								return function(e, M, O)
									return x(e, M, function(e, M, x)
										return g(e, M, x, O)
									end)
								end
							end)()
						)
					end,
					[59] = function()
						local e, e, M = fn24(59)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R = M(g.External), M(g.State.For), M(g.State.Value), M(g.State.Computed)
								M(g.State.For.ForTypes)

								local d, p, I =
									M(g.Logging.parseError), M(g.Memory.doCleanup), { __index = {
										roamKeys = true,
										roamValues = false,
										invalidateInputKey = function(g) end,
										invalidateInputValue = function(g)
											g._inputValueState:set(g.inputValue)
										end,
										useOutputPair = function(g, M)
											return g.inputKey, M(g._outputValueState)
										end,
									} }

								local function g(M, E, w, S)
									local f

									f = {
										maybeScope = M,
										inputKey = E,
										inputValue = w,
										_inputValueState = O(M, w),
										_processor = S,
										_outputValueState = R(M, function(M, O)
											local R = M(f._inputValueState)
											local E, w = xpcall(f._processor, d, M, O, R)

											if E then
												return w
											else
												w.context = ("while processing value %*"):format(tostring(R))
												e.logErrorNonFatal("callbackError", w)
												p(O)
												table.clear(O)
												return nil
											end
										end),
									}

									return (setmetatable(f, I))
								end

								return function(e, M, O)
									return x(e, M, function(e, M, x)
										return g(e, M, x, O)
									end)
								end
							end)()
						)
					end,
					[60] = function()
						local e, e, M = fn24(60)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O, R =
									M(g.Graph.change),
									M(g.Utility.isSimilar),
									M(g.Utility.nicknames),
									{
										type = "State",
										kind = "Value",
										timeliness = "lazy",
										dependencySet = table.freeze({}),
									}
								local g = table.freeze({ __index = R })

								local function M(d, p)
									local I = setmetatable({
										createdAt = os.clock(),
										dependentSet = {},
										lastChange = os.clock(),
										scope = d,
										validity = "valid",
										_EXTREMELY_DANGEROUS_usedAsValue = p,
									}, g)

									local function g()
										I.scope = nil
									end

									I.oldestTask = g
									O[I.oldestTask] = "Value"
									table.insert(d, g)
									return I
								end

								R.set = function(g, O)
									if not x(g._EXTREMELY_DANGEROUS_usedAsValue, O) then
										g._EXTREMELY_DANGEROUS_usedAsValue = O
										e(g)
									end

									return O
								end

								R._evaluate = function(g)
									return true
								end

								table.freeze(R)
								return M
							end)()
						)
					end,
					[61] = function()
						local e, e, M = fn24(61)

						return (
							(function(...)
								M(e.Parent.Parent.Types)

								return function(g)
									if (typeof(g) == "table") and (g.type == "State") then
										return g
									else
										return nil
									end
								end
							end)()
						)
					end,
					[62] = function()
						local e, e, M = fn24(62)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x = M(g.State.castToState), M(g.Graph.evaluate)

								return function(g)
									local M = e(g)

									if M ~= nil then
										x(M, false)
										return M._EXTREMELY_DANGEROUS_usedAsValue
									else
										return g
									end
								end
							end)()
						)
					end,
					[63] = function()
						fn24(63)

						return ((function(...)
							return nil
						end)())
					end,
					[64] = function()
						fn24(64)

						return ((function(...)
							return nil
						end)())
					end,
					[72] = function()
						fn24(72)

						return (function(...)
							return setmetatable({}, { __mode = "k" })
						end)()
					end,
					[66] = function()
						local e, e, M = fn24(66)

						return (
							(function(...)
								local g = e.Parent.Parent
								M(g.Types)
								local e, x, O = M(g.External), M(g.Logging.parseError), { type = "Contextual" }
								local g, M = table.freeze({ __index = O }), table.freeze({ __mode = "k" })

								local function R(d)
									return (setmetatable({ _valuesNow = setmetatable({}, M), _defaultValue = d }, g))
								end

								O.now = function(g)
									local M = coroutine.running()
									local d = g._valuesNow[M]

									if typeof(d) ~= "table" then
										return g._defaultValue
									else
										return d.value
									end
								end

								O.is = function(g, M)
									return {
										during = function(d, p, ...)
											d = coroutine.running()
											local I = g._valuesNow[d]
											g._valuesNow[d] = { value = M }
											local M, E = xpcall(p, x, ...)
											g._valuesNow[d] = I

											if not M then
												e.logError("callbackError", E)
											end

											return E
										end,
									}
								end

								table.freeze(O)
								return R
							end)()
						)
					end,
					[69] = function()
						local e, e, M = fn24(69)

						return (
							(function(...)
								local g = M(e.Parent.Parent.External)

								return function(e, M, ...)
									local x = { ... }

									if #x < 1 then
										return M
									else
										for O, O in x, nil, nil do
											for x, R in O, nil, nil do
												if e or (M[x] == nil) then
													M[x] = R
												elseif not e then
													g.logError("mergeConflict", nil, tostring(x))
												end
											end
										end

										return M
									end
								end
							end)()
						)
					end,
					[68] = function()
						fn24(68)

						return (
							(function(...)
								return function(g, e)
									local M = typeof(g)
									local x, O = M == "table", M == "userdata"
									return if not (x or O)
										then (g == e) or ((g ~= g) and (e ~= e))
										else if (M == typeof(e))
												and ((O or (table.isfrozen(g))) or (getmetatable(g) ~= nil))
											then g == e
											else false
								end
							end)()
						)
					end,
					[71] = function()
						fn24(71)

						return (
							(function(...)
								return function()
									error("This codepath should not be reachable")
								end
							end)()
						)
					end,
					[73] = function()
						fn24(73)

						return (
							(function(...)
								return function(g)
									local e = typeof(g)

									if e == "table" then
										if typeof(g.type) == "string" then
											return g.type
										end
									end

									return e
								end
							end)()
						)
					end,
					[67] = function()
						local e, e = fn24(67)

						return (
							(function(...)
								local g = e.Parent.Parent

								return function(g)
									local e, e = xpcall(g.try, g.fallback)
									return e
								end
							end)()
						)
					end,
					[70] = function()
						local e, e, M = fn24(70)

						return (
							(function(...)
								local g = M(e.Parent.Parent.Utility.nicknames)

								return function(e, M)
									local x = g[e]
									if typeof(x) == "string" then
										return x
									end

									if typeof(e) == "table" then
										if typeof(e.name) == "string" then
											return e.name
										elseif typeof(e.kind) == "string" then
											return e.kind
										elseif typeof(e.type) == "string" then
											return e.type
										end
									end

									return M
								end
							end)()
						)
					end,
				}

				local tbl15 = {
					{
						1,
						2,
						{ "Fusion" },
						{
							{ 16, 2, { "External" } },
							{ 17, 2, { "ExternalDebug" } },
							{
								65,
								1,
								{ "Utility" },
								{
									{ 73, 2, { "xtypeof" } },
									{ 69, 2, { "merge" } },
									{ 72, 2, { "nicknames" } },
									{ 67, 2, { "Safe" } },
									{ 66, 2, { "Contextual" } },
									{ 71, 2, { "never" } },
									{ 70, 2, { "nameOf" } },
									{ 68, 2, { "isSimilar" } },
								},
							},
							{ 64, 2, { "Types" } },
							{
								42,
								1,
								{ "Memory" },
								{
									{ 46, 2, { "doCleanup" } },
									{ 47, 2, { "innerScope" } },
									{ 50, 2, { "scoped" } },
									{ 45, 2, { "deriveScopeImpl" } },
									{ 43, 2, { "checkLifetime" } },
									{ 48, 2, { "insert" } },
									{ 44, 2, { "deriveScope" } },
									{ 49, 2, { "needsDestruction" } },
								},
							},
							{
								2,
								1,
								{ "Animation" },
								{
									{ 8, 2, { "getTweenRatio" } },
									{ 11, 2, { "springCoefficients" } },
									{ 6, 2, { "Tween" } },
									{ 9, 2, { "lerpType" } },
									{ 7, 2, { "getTweenDuration" } },
									{ 12, 2, { "unpackType" } },
									{ 4, 2, { "Spring" } },
									{ 3, 2, { "ExternalTime" } },
									{ 5, 2, { "Stopwatch" } },
									{ 10, 2, { "packType" } },
								},
							},
							{
								38,
								1,
								{ "Logging" },
								{
									{ 40, 2, { "messages" } },
									{ 39, 2, { "formatError" } },
									{ 41, 2, { "parseError" } },
								},
							},
							{
								18,
								1,
								{ "Graph" },
								{
									{ 23, 2, { "evaluate" } },
									{ 21, 2, { "change" } },
									{ 22, 2, { "depend" } },
									{ 19, 2, { "Observer" } },
									{ 20, 2, { "castToGraph" } },
								},
							},
							{
								52,
								1,
								{ "State" },
								{
									{ 59, 2, { "ForValues" } },
									{ 63, 2, { "updateAll" } },
									{
										54,
										2,
										{ "For" },
										{ { 56, 2, { "ForTypes" } }, { 55, 2, { "Disassembly" } } },
									},
									{ 61, 2, { "castToState" } },
									{ 62, 2, { "peek" } },
									{ 58, 2, { "ForPairs" } },
									{ 60, 2, { "Value" } },
									{ 57, 2, { "ForKeys" } },
									{ 53, 2, { "Computed" } },
								},
							},
							{
								24,
								1,
								{ "Instances" },
								{
									{ 30, 2, { "Hydrate" } },
									{ 27, 2, { "AttributeOut" } },
									{ 37, 2, { "defaultProps" } },
									{ 31, 2, { "New" } },
									{ 33, 2, { "OnEvent" } },
									{ 32, 2, { "OnChange" } },
									{ 29, 2, { "Children" } },
									{ 35, 2, { "Tag" } },
									{ 28, 2, { "Child" } },
									{ 25, 2, { "Attribute" } },
									{ 34, 2, { "Out" } },
									{ 26, 2, { "AttributeChange" } },
									{ 36, 2, { "applyInstanceProps" } },
								},
							},
							{ 51, 2, { "RobloxExternal" } },
							{ 13, 1, { "Colour" }, { { 15, 2, { "sRGB" } }, { 14, 2, { "Oklab" } } } },
						},
					},
				}

				local str7 = "0.4.2"
				local str8 = "WaxRuntime"
				local v46 = string
				local v47 = task
				local v48 = setmetatable
				local v49 = error
				local v50 = next
				local v51 = table
				local v52 = unpack
				local v53 = coroutine
				local v54 = v43
				local v55 = type
				local v56 = v44
				local v57 = pcall
				local v58 = tostring
				local v59 = tonumber
				local v60 = _VERSION
				local v61 = nil
				local insert = v51.insert
				local remove = v51.remove

				local freeze = v51.freeze or function(arg)
					return arg
				end

				local wrap = v53.wrap
				local sub = v46.sub
				local match = v46.match
				local gmatch = v46.gmatch
				local v62

				if v60 and sub(v60, 1, 4) == "Lune" then
					local v63, v64 = v57(v56, "@lune/task")

					if v63 and v64 then
						v62 = v64
					else
						v62 = v47
					end
				else
					v62 = v47
				end

				local defer = v62 and v62.defer or function(arg, ...)
					wrap(arg)(...)
				end

				local tbl16 = { "Folder", "ModuleScript", "Script", [4] = "LocalScript", [5] = "StringValue" }
				local tbl17 = {}
				local instances = {}
				local instances2 = {}
				local instances3 = {}
				local tbl18 = {}
				local tbl19 = {}
				local tbl20 = {}
				local tbl21 = {}

				for k, v63 in
					v50,
					{
						GetFullName = {
							{},
							function(instance)
								local name = instance.Name
								local parent = instance.Parent

								while parent do
									name = parent.Name .. "." .. name
									parent = parent.Parent
								end

								return name
							end,
						},
						GetChildren = {
							{},
							function(arg)
								local tbl22 = {}

								for k in v50, tbl20[arg] do
									insert(tbl22, k)
								end

								return tbl22
							end,
						},
						GetDescendants = {
							{},
							function(arg)
								local tbl22 = {}

								for k in v50, tbl20[arg] do
									insert(tbl22, k)

									for _, v63 in v50, k:GetDescendants() do
										insert(tbl22, v63)
									end
								end

								return tbl22
							end,
						},
						FindFirstChild = {
							{ "string", "boolean?" },
							function(arg, name, arg2)
								local v63 = tbl20[arg]

								for k in v50, v63 do
									if k.Name == name then
										return k
									end
								end

								if arg2 then
									local v64 = table.pack(b_1())
									if v64[1] then
										return (v64[2]):FindFirstChild(name, true)
									end
								end
							end,
						},
						FindFirstAncestor = {
							{ "string" },
							function(instance, arg)
								local parent = instance.Parent

								while parent do
									if parent.Name == arg then
										return parent
									end
									parent = parent.Parent
								end
							end,
						},
						WaitForChild = {
							{ "string", "number?" },
							function(instance, name)
								return instance:FindFirstChild(name)
							end,
						},
					}
				do
					local v64 = v63[2]
					local tbl22 = {}

					for k2, v65 in v50, v63[1] do
						local v66, v67 = match(v65, "^([^%?]+)(%??)")
						tbl22[k2] = { v66, v67 }
					end

					tbl21[k] = function(arg, ...)
						local v65 = table.pack(...)

						if not tbl20[arg] then
							v49("Expected ':' not '.' calling member function " .. k, 2)
						end

						local tbl23 = { ... }

						for k2, v66 in v50, tbl22 do
							local v67 = tbl23[k2]
							local v68 = v55(v67)
							local v69 = v66[1]
							local v70 = v66[2]

							if v67 == nil and not v70 then
								v49("Argument " .. v67 .. " missing or nil", 3)
							end

							if v69 ~= "any" and v68 ~= v69 and not (v68 == "nil" and v70) then
								v49("Argument " .. k2 .. ' expects type "' .. v69 .. '", got "' .. v68 .. '"', 2)
							end
						end

						return v64(arg, table.unpack(v65, 1, v65.n))
					end
				end

				local function fn25(arg, arg2, arg3)
					local v63 = v48({}, { __mode = "k" })
					local v64 = nil

					local function fn26(arg4)
						v49(arg4 .. " is not a valid (virtual) member of " .. arg .. ' "' .. arg2 .. '"', 3)
					end

					local function fn27(arg4)
						v49("Unable to assign (virtual) property " .. arg4 .. ". Property is read only", 3)
					end

					local tbl22 = {}

					v48(tbl22, {
						__metatable = false,
						__index = function(arg4, arg5)
							if arg5 == "ClassName" then
								return arg
							end

							if arg5 == "Name" then
								return arg2
							end

							if arg5 == "Parent" then
								return arg3
							end

							if arg == "StringValue" and arg5 == "Value" then
								return v64
							end
							local v65 = tbl21[arg5]
							if v65 then
								return v65
							end

							for k in v50, v63 do
								if k.Name == arg5 then
									return k
								end
							end

							fn26(arg5)
						end,
						__newindex = function(arg4, arg5, arg6)
							if arg5 == "ClassName" then
								fn27(arg5)
							elseif arg5 == "Name" then
								arg2 = arg6
							elseif arg5 == "Parent" then
								if arg6 == tbl22 then
									return
								end

								if arg3 ~= nil then
									tbl20[arg3][tbl22] = nil
								end

								arg3 = arg6

								if arg6 ~= nil then
									tbl20[arg6][tbl22] = true
								end
							elseif arg == "StringValue" and arg5 == "Value" then
								v64 = arg6
							else
								fn26(arg5)
							end
						end,
						__tostring = function()
							return arg2
						end,
					})

					tbl20[tbl22] = v63

					if arg3 ~= nil then
						tbl20[arg3][tbl22] = true
					end

					return tbl22
				end

				local function fn26(arg, arg2)
					local v63 = arg[1]
					local v64 = arg[2]
					local v65 = arg[3]
					local v66 = arg[4]
					local v67 = tbl16[v64]
					local v68 = fn25(v67, v65 and remove(v65, 1) or v67, arg2)
					tbl17[v63] = v68

					if v65 then
						for k, v69 in v50, v65 do
							v68[k] = v69
						end
					end

					if v66 then
						for _, v69 in v50, v66 do
							fn26(v69, v68)
						end
					end

					return v68
				end

				local Folder = fn25("Folder", "[" .. str8 .. "]")

				for _, v63 in v50, tbl15 do
					fn26(v63, Folder)
				end

				for k, v63 in v50, tbl14 do
					local instance = tbl17[k]
					instances[instance] = v63
					instances2[instance] = k
					local className = instance.ClassName

					if className == "LocalScript" or className == "Script" then
						insert(tbl18, instance)
					end
				end

				local function fn27(instance)
					local className = instance.ClassName
					local instance2 = instances3[instance]
					if instance2 and className == "ModuleScript" then
						return v52(instance2)
					end
					local instance3 = instances[instance]

					local function fn28(arg)
						local v63 = v58(arg)
						local fullName = instance:GetFullName()
						local v64, v65 = match(v63, "[^:]+:(%d+): (.+)")
						if not v64 or not v61 then
							v65 = v65 or v63
							return fullName .. ":*: " .. v65
						end
						local n = v59(v64) - v61[instances2[instance]] + 1

						if n < 0 then
							n = "?"
						end

						return fullName .. ":" .. n .. ": " .. v65
					end

					if className == "LocalScript" or className == "Script" then
						local v63, v64 = v57(instance3)

						if not v63 then
							v49(fn28(v64), 0)
						end

						return
					end

					local tbl22 = { v57(instance3) }

					if not remove(tbl22, 1) then
						local v63 = remove(tbl22, 1)
						v49(fn28(v63), 0)
					end

					instances3[instance] = tbl22
					return v52(tbl22)
				end

				fn24 = function(arg)
					local v63 = tbl17[arg]

					local function fn28(arg2, ...)
						local v64 = table.pack(...)
						local v65 = v57
						v64.n = 2 + v64.n - 1
						table.move(v64, 1, v64.n, 2, v64)
						v64[1] = arg2
						local tbl22 = { v65(table.unpack(v64, 1, v64.n)) }

						if not remove(tbl22, 1) then
							v49(tbl22[1], 3)
						end

						return v52(tbl22)
					end

					return freeze({
						version = str7,
						envname = str8,
						shared = freeze(v48({}, {
							__index = tbl19,
							__newindex = function(arg2, arg3, arg4)
								tbl19[arg3] = arg4
							end,
							__len = function()
								return #tbl19
							end,
							__iter = function()
								return v50, tbl19
							end,
						})),
						script = v54,
						require = v56,
					}),
						v63,
						function(instance, ...)
							local v64 = v55(instance)

							if v64 == "table" and tbl20[instance] then
								if instance.ClassName ~= "ModuleScript" then
									v49("Attempted to call require with a non-ModuleScript", 2)
								elseif instance == v63 then
									v49("Attempted to call require with self", 2)
								end

								return fn27(instance)
							end

							if v64 == "string" and sub(instance, 1, 1) ~= "@" then
								if #instance == 0 then
									v49("Attempted to call require with empty string", 2)
								end

								local Folder2

								if sub(instance, 1, 1) == "/" then
									Folder2 = Folder
								else
									Folder2 = v63

									if sub(instance, 1, 2) == "./" then
										Folder2 = v63
										instance = sub(instance, 3)
									end
								end

								local v65 = nil

								for k in gmatch(instance, "([^/]*)/?") do
									local name

									if k ~= ".." then
										name = k
									else
										name = "Parent"
									end

									if name == "" then
										v65 = k
										continue
									end
									local child = Folder2:FindFirstChild(name)

									if not child then
										local parent = Folder2.Parent

										if parent then
											child = parent:FindFirstChild(name)
										end
									end

									if child then
										Folder2 = child
										v65 = k
									elseif k ~= v65 and k ~= "init" and k ~= "init.server" and k ~= "init.client" then
										v49('Virtual script path "' .. instance .. '" not found', 2)
										v65 = k
									else
										v65 = k
									end
								end

								if Folder2.ClassName ~= "ModuleScript" then
									v49("Attempted to call require with a non-ModuleScript", 2)
								elseif Folder2 == v63 then
									v49("Attempted to call require with self", 2)
								end

								return fn27(Folder2)
							end

							return fn28(v56, instance, ...)
						end
				end

				for _, v63 in v50, tbl18 do
					defer(fn27, v63)
				end

				return fn27(Folder:GetChildren()[1])
			end)()
		end,
		[105] = function()
			local v, instance, v43 = fn23(105)

			return (
				(function()
					local parent = instance.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.packages.states)
					local userInputService = v43(parent.utils.services).UserInputService
					local peek = v44.peek

					local tbl14 = {
						isKeyMatch = function(input, arg)
							if arg == "None" then
								return false
							end

							if arg == "MouseLeft" then
								return input.UserInputType == Enum.UserInputType.MouseButton1
							end

							if arg == "MouseRight" then
								return input.UserInputType == Enum.UserInputType.MouseButton2
							end

							if input.UserInputType == Enum.UserInputType.Keyboard then
								return input.KeyCode.Name == arg
							end
							return false
						end,
						normalizeInputToKey = function(input)
							if input.UserInputType == Enum.UserInputType.Keyboard then
								return input.KeyCode.Name
							end

							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								return "MouseLeft"
							end

							if input.UserInputType == Enum.UserInputType.MouseButton2 then
								return "MouseRight"
							end
							return nil
						end,
					}

					local tbl15 = {}
					local flag19 = false
					local connection = nil
					local connection2 = nil

					local function fn24()
						if connection then
							connection:Disconnect()
							connection = nil
						end

						if connection2 then
							connection2:Disconnect()
							connection2 = nil
						end

						flag19 = false
					end

					local function onInputBegan(input, gameProcessed)
						if gameProcessed then
							return
						end

						if userInputService:GetFocusedTextBox() then
							return
						end

						for k, v46 in pairs(tbl15) do
							local v47 = peek(v45.Keybinds)[k]

							if v47 and tbl14.isKeyMatch(input, v47.key) then
								if v46.onInputBegan then
									v46.onInputBegan(input)
								end
							end
						end
					end

					local function onInputEnded(input, gameProcessed)
						if gameProcessed then
							return
						end

						for k, v46 in pairs(tbl15) do
							local v47 = peek(v45.Keybinds)[k]

							if v47 and tbl14.isKeyMatch(input, v47.key) then
								if v46.onInputEnded then
									v46.onInputEnded(input)
								end
							end
						end
					end

					local function fn25()
						if flag19 then
							return
						end
						flag19 = true
						connection = userInputService.InputBegan:Connect(onInputBegan)
						connection2 = userInputService.InputEnded:Connect(onInputEnded)
					end

					tbl14.addKeybind = function(arg, arg2, arg3)
						local v46 = peek(v45.Keybinds)
						local v47 = table.clone(v46)
						v47[arg] = { key = arg2, feature = arg3 }
						v45.Keybinds:set(v47)
					end

					tbl14.removeKeybind = function(arg)
						local v46 = peek(v45.Keybinds)
						local v47 = table.clone(v46)
						v47[arg] = nil
						v45.Keybinds:set(v47)
					end

					tbl14.updateKeybind = function(arg, key, feature)
						if key == nil and feature == nil then
							tbl14.removeKeybind(arg)
						else
							local v46 = peek(v45.Keybinds)
							local v47 = table.clone(v46)

							if v47[arg] then
								local v48 = v47[arg]
								key = key or v47[arg].key
								v48.key = key
								local v49 = v47[arg]
								feature = feature or v47[arg].feature
								v49.feature = feature
							else
								v47[arg] = { key = key or "None", feature = feature or "Unknown" }
							end

							v45.Keybinds:set(v47)
						end
					end

					tbl14.registerKeybindHandler = function(arg, arg2)
						tbl15[arg] = arg2
						fn25()
					end

					tbl14.unregisterKeybindHandler = function(arg)
						tbl15[arg] = nil

						if next(tbl15) == nil then
							fn24()
						end
					end

					tbl14.cleanup = function()
						fn24()
						tbl15 = {}
						v45.Keybinds:set({})
						v45.ActiveKeybinds:set({})
					end

					return tbl14
				end)()
			)
		end,
		[106] = function()
			fn23(106)

			return (
				(function()
					local tbl14

					tbl14 = {
						ClassName = "Maid",
						new = function()
							return setmetatable({ _tasks = {} }, tbl14)
						end,
						isMaid = function(instance)
							return type(instance) == "table" and instance.ClassName == "Maid"
						end,
						__index = function(arg, arg2)
							if tbl14[arg2] then
								return tbl14[arg2]
							end
							return arg._tasks[arg2]
						end,
						__newindex = function(arg, arg2, arg3)
							if tbl14[arg2] ~= nil then
								error(("'%s' is reserved"):format(tostring(arg2)), 2)
							end

							local tasks = arg._tasks
							local task_ = tasks[arg2]
							if task_ == arg3 then
								return
							end
							tasks[arg2] = arg3
							if not task_ then
								return
							end

							if type(task_) == "function" then
								task_()
							elseif typeof(task_) == "RBXScriptConnection" then
								task_:Disconnect()
							elseif task_.Destroy then
								task_:Destroy()
							end
						end,
						GiveTask = function(arg, arg2)
							if not arg2 then
								error("Task cannot be false or nil", 2)
							end

							local n = #arg._tasks + 1
							arg[n] = arg2
							return n
						end,
						GivePromise = function(arg, arg2)
							if not arg2:IsPending() then
								return arg2
							end
							local v = arg2:resolved()
							local v43 = arg:GiveTask(v)

							v:Finally(function()
								arg[v43] = nil
							end)

							return v
						end,
						DoCleaning = function(arg)
							local tasks = arg._tasks
							local tbl15 = {}
							local v = nil

							local function fn24(arg2, connection)
								tbl15[arg2] = connection

								local ok, result = pcall(function()
									if type(connection) == "function" then
										connection()
									elseif typeof(connection) == "RBXScriptConnection" then
										connection:Disconnect()
									elseif connection.Destroy then
										connection:Destroy()
									end
								end)

								if ok then
									if tasks[arg2] == connection then
										tasks[arg2] = nil
									end
								elseif v == nil then
									v = result
								end
							end

							for k, task_ in pairs(tasks) do
								if typeof(task_) == "RBXScriptConnection" then
									fn24(k, task_)
								end
							end

							while true do
								local flag19 = false

								for k, task_ in pairs(tasks) do
									if tbl15[k] ~= task_ then
										fn24(k, task_)
										flag19 = true
									end
								end

								if not flag19 then
									break
								end
							end

							if v ~= nil then
								error(v, 0)
							end
						end,
					}

					tbl14.Destroy = tbl14.DoCleaning
					return tbl14
				end)()
			)
		end,
		[107] = function()
			local v, v43, v44 = fn23(107)

			return (
				(function()
					local v45 = v44(v43.SnapdragonController)
					local v46 = v44(v43.SnapdragonRef)

					local default = {
						createDragController = function(...)
							return v45.new(...)
						end,
						SnapdragonController = v45,
						createRef = function(arg)
							return v46.new(arg)
						end,
					}

					default.default = default
					return default
				end)()
			)
		end,
		[108] = function()
			fn23(108)

			return (
				(function()
					local tbl14

					tbl14 = {
						ClassName = "Maid",
						new = function()
							return setmetatable({ _tasks = {} }, tbl14)
						end,
						__index = function(arg, arg2)
							if tbl14[arg2] then
								return tbl14[arg2]
							end
							return arg._tasks[arg2]
						end,
						__newindex = function(arg, arg2, arg3)
							if tbl14[arg2] ~= nil then
								error(("'%s' is reserved"):format(tostring(arg2)), 2)
							end

							local tasks = arg._tasks
							local task_ = tasks[arg2]
							tasks[arg2] = arg3
							if not task_ then
								return
							end

							if type(task_) == "function" then
								task_()
							elseif typeof(task_) == "RBXScriptConnection" then
								task_:Disconnect()
							elseif task_.Destroy then
								task_:Destroy()
							end
						end,
						GiveTask = function(arg, arg2)
							assert(arg2, "Task cannot be false or nil")
							local n = #arg._tasks + 1
							arg[n] = arg2

							if type(arg2) == "table" and not arg2.Destroy then
								warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback())
							end

							return n
						end,
						GivePromise = function(arg, arg2)
							if not arg2:IsPending() then
								return arg2
							end
							local v = arg2:resolved()
							local v43 = arg:GiveTask(v)

							v:Finally(function()
								arg[v43] = nil
							end)

							return v
						end,
						DoCleaning = function(arg)
							local tasks = arg._tasks

							for k, task_ in pairs(tasks) do
								if typeof(task_) == "RBXScriptConnection" then
									tasks[k] = nil
									task_:Disconnect()
								end
							end

							local key, connection = next(tasks)

							while connection ~= nil do
								tasks[key] = nil

								if type(connection) == "function" then
									connection()
								elseif typeof(connection) == "RBXScriptConnection" then
									connection:Disconnect()
								elseif connection.Destroy then
									connection:Destroy()
								end

								key, connection = next(tasks)
							end
						end,
					}

					tbl14.Destroy = tbl14.DoCleaning
					return tbl14
				end)()
			)
		end,
		[109] = function()
			fn23(109)

			return (
				(function()
					local index = {}
					index.__index = index

					index.new = function()
						return setmetatable({ Bindable = Instance.new("BindableEvent") }, index)
					end

					index.Connect = function(g, e)
						return g.Bindable.Event:Connect(function(g)
							e(g())
						end)
					end
					index.Fire = function(g, ...)
						local e, M = { ... }, select("#", ...)
						g.Bindable:Fire(function()
							return unpack(e, 1, M)
						end)
					end
					index.Wait = function(g)
						return g.Bindable.Event:Wait()()
					end
					index.Destroy = function(g)
						g.Bindable:Destroy()
					end
					return index
				end)()
			)
		end,
		[110] = function()
			local v, instance, v43 = fn23(110)

			return (
				(function()
					local userInputService = v43(instance.Parent.Parent.Parent.utils.services).UserInputService
					local v44 = v43(instance.Parent.Maid)
					local v45 = v43(instance.Parent.Signal)
					local v46 = v43(instance.Parent.SnapdragonRef)
					local v47 = v43(instance.Parent.objectAssign)

					local function fn24(arg)
						if type(arg) ~= "table" then
							return false
						end
						return (arg.Vertical == nil or typeof(arg.Vertical) == "Vector2")
							and (arg.Horizontal == nil or typeof(arg.Horizontal) == "Vector2")
					end

					local function fn25(arg)
						return arg == "XY" or arg == "X" or arg == "Y"
					end

					local function getIsGuiObject(instance2)
						return typeof(instance2) == "Instance" and instance2:IsA("GuiObject") or v46.is(instance2)
					end

					local function fn26(arg)
						return type(arg) == "table"
							and getIsGuiObject(arg.DragGui)
							and type(arg.DragThreshold) == "number"
							and type(arg.DragGridSize) == "number"
							and fn24(arg.SnapMargin)
							and fn24(arg.SnapMarginThreshold)
							and fn25(arg.SnapAxis)
							and fn25(arg.DragAxis)
							and (arg.DragRelativeTo == "LayerCollector" or arg.DragRelativeTo == "Parent")
							and type(arg.SnapEnabled) == "boolean"
							and type(arg.Debugging) == "boolean"
							and (arg.DragPositionMode == "Offset" or arg.DragPositionMode == "Scale")
					end

					local index = {}
					index.__index = index
					local obj = setmetatable({}, { __mode = "k" })

					index.new = function(gui, arg)
						local v48 = v47({
							DragGui = gui,
							DragThreshold = 0,
							DragGridSize = 0,
							SnapMargin = {},
							SnapMarginThreshold = {},
							SnapEnabled = true,
							DragEndedResetsPosition = false,
							SnapAxis = "XY",
							DragAxis = "XY",
							Debugging = false,
							DragRelativeTo = "LayerCollector",
							DragPositionMode = "Scale",
						}, arg)

						assert(fn26(v48))
						local obj2 = setmetatable({}, index)
						local dragGui = v48.DragGui
						obj2.dragGui = dragGui
						obj2.gui = gui
						obj2.debug = v48.Debugging
						obj2.originPosition = dragGui.Position
						obj2.canDrag = v48.CanDrag
						obj2.dragEndedResetsPosition = v48.DragEndedResetsPosition
						obj2.snapEnabled = v48.SnapEnabled
						obj2.snapAxis = v48.SnapAxis
						obj2.dragAxis = v48.DragAxis
						obj2.dragThreshold = v48.DragThreshold
						obj2.dragRelativeTo = v48.DragRelativeTo
						obj2.dragGridSize = v48.DragGridSize
						obj2.dragPositionMode = v48.DragPositionMode
						obj2._useAbsoluteCoordinates = false

						local dragEnded = v45.new()
						local dragChanged = v45.new()
						local dragBegan = v45.new()

						obj2.DragEnded = dragEnded
						obj2.DragBegan = dragBegan
						obj2.DragChanged = dragChanged
						obj2.maid = v44.new()
						obj2:SetSnapEnabled(v48.SnapEnabled)
						obj2:SetSnapMargin(v48.SnapMargin)
						obj2:SetSnapThreshold(v48.SnapMarginThreshold)
						return obj2
					end

					index.SetSnapEnabled = function(arg, snapEnabled)
						assert(type(snapEnabled) == "boolean")
						arg.snapEnabled = snapEnabled
					end

					index.SetSnapMargin = function(arg, arg2)
						assert(fn24(arg2))
						local vertical = arg2.Vertical or Vector2.new()
						local horizontal = arg2.Horizontal or Vector2.new()
						arg.snapVerticalMargin = vertical
						arg.snapHorizontalMargin = horizontal
					end

					index.SetSnapThreshold = function(arg, arg2)
						assert(fn24(arg2))
						local vertical = arg2.Vertical or Vector2.new()
						local horizontal = arg2.Horizontal or Vector2.new()
						arg.snapThresholdVertical = vertical
						arg.snapThresholdHorizontal = horizontal
					end

					index.GetDragGui = function(arg)
						local dragGui = arg.dragGui
						if v46.is(dragGui) then
							return dragGui:Get(), dragGui
						end
						return dragGui, dragGui
					end

					index.GetGui = function(arg)
						local gui = arg.gui
						if v46.is(gui) then
							return gui:Get()
						end
						return gui
					end

					index.ResetPosition = function(arg)
						arg.dragGui.Position = arg.originPosition
					end

					index.__bindControllerBehaviour = function(e)
						local M, x, O, R, d, p, I, E, w, S, f, a, n, Q, Z, t, z, L, l, P =
							e.maid,
							e.debug,
							e:GetGui(),
							e:GetDragGui(),
							e.snapEnabled,
							e.DragEnded,
							e.DragBegan,
							e.DragChanged,
							e.snapAxis,
							e.dragAxis,
							e.dragRelativeTo,
							e.dragGridSize,
							e.dragPositionMode,
							e._useAbsoluteCoordinates

						local function r(D)
							local W, F, _, k, N, s =
								e.snapHorizontalMargin,
								e.snapVerticalMargin,
								e.snapThresholdVertical,
								e.snapThresholdHorizontal,
								workspace.CurrentCamera.ViewportSize,
								D.Position - L
							s, O, Z =
								if S == "X"
									then (Vector3.new(s.X, 0, 0))
									else if S == "Y" then (Vector3.new(0, s.Y, 0)) else s,
								R or O,
								{ X = "Float", Y = "Float" }
							local S, q =
								O:FindFirstAncestorOfClass("ScreenGui") or (O:FindFirstAncestorOfClass("PluginGui")),
								Vector2.new()
							D = S and (f == "LayerCollector")

							if D then
								N = S.AbsoluteSize
							elseif f == "Parent" then
								assert(
									O.Parent:IsA("GuiObject"),
									"DragRelativeTo is set to Parent, but the parent is not a GuiObject!"
								)
								N = O.Parent.AbsoluteSize
							end

							if d then
								local d, f, U, B, A, V =
									N.X * l.X.Scale,
									N.Y * l.Y.Scale,
									l.X.Offset + s.X,
									l.Y.Offset + s.Y,
									O.AbsoluteSize + Vector2.new(W.Y, F.Y + q.Y),
									Vector2.new(O.AbsoluteSize.X * O.AnchorPoint.X, O.AbsoluteSize.Y * O.AnchorPoint.Y)

								if (w == "XY") or (w == "X") then
									S, D = W.X + V.X, (N.X - A.X) + V.X

									if (U + d) > (D - k.Y) then
										U = D - d
										Z.X = "Max"
									elseif (U + d) < (S + k.X) then
										U = -d + S
										Z.X = "Min"
									end
								end

								if (w == "XY") or (w == "Y") then
									local d, S = F.X + V.Y, (N.Y - A.Y) + V.Y

									if (B + f) > (S - _.Y) then
										B = S - f
										Z.Y = "Max"
									elseif (B + f) < (d + _.X) then
										B = -f + d
										Z.Y = "Min"
									end
								end

								if a > 0 then
									U, B = math.floor(U / a) * a, math.floor(B / a) * a
								end

								if n == "Offset" then
									f = UDim2.new(l.X.Scale, U, l.Y.Scale, B)
									O.Position = f
									E:Fire({ GuiPosition = f })
								else
									V = UDim2.new(l.X.Scale + (U / N.X), 0, l.Y.Scale + (B / N.Y), 0)
									O.Position = V
									E:Fire({ SnapAxis = w, GuiPosition = V, DragPositionMode = n })
								end
							else
								s = if a > 0 then (Vector2.new(math.floor(s.X / a) * a, math.floor(s.Y / a) * a)) else s
								local d = UDim2.new(l.X.Scale, l.X.Offset + s.X, l.Y.Scale, l.Y.Offset + s.Y)
								O.Position = d
								E:Fire({ GuiPosition = d })
							end
						end

						M.guiInputBegan = O.InputBegan:Connect(function(d)
							if
								(
									(d.UserInputType == Enum.UserInputType.MouseButton1)
									or (d.UserInputType == Enum.UserInputType.Touch)
								) and (if type(e.canDrag) == "function" then (e.canDrag()) else true)
							then
								t = true
								L = d.Position
								local E = R or O
								l = (Q and (UDim2.new(0, E.AbsolutePosition.X, 0, E.AbsolutePosition.Y))) or E.Position
								P = E.Position
								I:Fire({
									AbsolutePosition = (R or O).AbsolutePosition,
									InputPosition = L,
									GuiPosition = l,
								})

								if x then
									print("[snapdragon]", "Drag began", d.Position)
								end
							end
						end)

						M.guiInputEnded = O.InputEnded:Connect(function(d)
							if
								(t and (d.UserInputState == Enum.UserInputState.End))
								and (
									(d.UserInputType == Enum.UserInputType.MouseButton1)
									or (d.UserInputType == Enum.UserInputType.Touch)
								)
							then
								t = false
								local I = R or O
								local E = I.Position
								p:Fire({
									InputPosition = d.Position,
									GuiPosition = E,
									ReachedExtents = Z,
									DraggedGui = R or O,
								})

								if x then
									print("[snapdragon]", "Drag ended", d.Position)
								end

								if e.dragEndedResetsPosition then
									I.Position = P
								end
							end
						end)

						M.guiInputChanged = O.InputChanged:Connect(function(e)
							local x = (e.UserInputType == Enum.UserInputType.MouseMovement)
								or (e.UserInputType == Enum.UserInputType.Touch)

							if x then
								z = e
							end
						end)

						M.uisInputChanged = userInputService.InputChanged:Connect(function(g)
							if (g == z) and t then
								r(g)
							end
						end)
					end

					index.Connect = function(arg)
						if arg.locked then
							error("[SnapdragonController] Cannot connect locked controller!", 2)
						end

						local dragGui, v48 = arg:GetDragGui()

						if not obj[v48] or obj[v48] == arg then
							obj[v48] = arg
							arg:__bindControllerBehaviour()
						else
							error("[SnapdragonController] This object is already bound to a controller")
						end

						return arg
					end

					index.Disconnect = function(arg)
						if arg.locked then
							error("[SnapdragonController] Cannot disconnect locked controller!", 2)
						end

						local dragGui, v48 = arg:GetDragGui()

						if obj[v48] then
							arg.maid:DoCleaning()
							obj[v48] = nil
						end
					end

					index.Destroy = function(connection)
						connection:Disconnect()
						connection.DragEnded:Destroy()
						connection.DragBegan:Destroy()
						connection.DragEnded = nil
						connection.DragBegan = nil
						connection.locked = true
					end

					return index
				end)()
			)
		end,
		[111] = function()
			fn23(111)

			return (
				(function()
					local obj = setmetatable({}, { __mode = "k" })
					local index = {}
					index.__index = index

					index.new = function(e)
						local M = setmetatable({ current = e }, index)
						obj[M] = M
						return M
					end

					index.Update = function(g, e)
						g.current = e
					end
					index.Get = function(g)
						return g.current
					end

					index.is = function(e)
						return obj[e] ~= nil
					end

					return index
				end)()
			)
		end,
		[112] = function()
			fn23(112)

			return (
				(function()
					return {
						named = function(arg)
							assert(type(arg) == "string", "Symbols must be created using a string name!")
							local proxy = newproxy(true)
							local str7 = ("Symbol(%s)"):format(arg)

							getmetatable(proxy).__tostring = function()
								return str7
							end

							return proxy
						end,
					}
				end)()
			)
		end,
		[113] = function()
			fn23(113)

			return (
				(function()
					return function(arg, ...)
						for _, v in pairs({ ... }) do
							for k, v43 in pairs(v) do
								arg[k] = v43
							end
						end

						return arg
					end
				end)()
			)
		end,
		[114] = function()
			local v, instance, v43 = fn23(114)

			return (
				(function()
					local parent = instance.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.Internal)
					local scope = v45.Scope
					local peek = v44.peek
					local noGlobalStateNameds

					noGlobalStateNameds = {
						DashboardScope = v45.Scope:innerScope(),
						Theme = scope:Value("obsidian"),
						Objects = scope:Value({}),
						Categorys = scope:Value({}),
						Tabs = scope:Value({}),
						Containers = scope:Value({}),
						Elements = scope:Value(),
						Library = scope:Value(),
						Notifications = scope:Value({}),
						CommandBarOpened = scope:Value(false),
						CommandBarPrefix = scope:Value(Enum.KeyCode.Semicolon),
						ToExecute = scope:Value(""),
						Suggestions = scope:Value({}),
						CommandBarText = scope:Value(""),
						ChatMessages = scope:Value({}),
						ChatOpen = scope:Value(false),
						HasUnreadMessages = scope:Value(false),
						ServerConnected = scope:Value(false),
						ServerConnecting = scope:Value(false),
						ServerAuthenticating = scope:Value(false),
						AIAgentConnected = scope:Value(false),
						AIAgentRunState = scope:Value("disconnected"),
						AIAgentSessions = scope:Value({}),
						AIAgentSelectedSessionId = scope:Value(nil),
						AIAgentSelectedDetail = scope:Value(nil),
						AIAgentCommandStatus = scope:Value({}),
						AIAgentThroughSequence = scope:Value(0),
						AIAgentDraft = scope:Value(""),
						AIAgentModel = scope:Value(nil),
						AIAgentThinkingLevel = scope:Value(nil),
						AIAgentConversationHistory = scope:Value({}),
						AIAgentInputRequests = scope:Value({}),
						AIAgentPendingAuthorizations = scope:Value({}),
						AIAgentUserMessage = scope:Value(""),
						AIAgentConversationVisible = scope:Value(false),
						AIAgentConnectionStatus = scope:Value({
							connected = false,
							authenticated = false,
							reconnecting = false,
							lastError = nil,
							connectionAttempts = 0,
						}),
						AIAgentLastError = scope:Value(nil),
						AIAgentRetrySubmissionAvailable = scope:Value(false),
						HasSelected = scope:Value(false),
						AnimationsEnabled = scope:Value(true),
						isCustomContainerToggled = scope:Value(false),
						isDashboardToggled = scope:Value(false),
						isAIChatToggled = scope:Value(false),
						AgentNeedsAttention = scope:Value(false),
						Keybinds = scope:Value({}),
						ActiveKeybinds = scope:Value({}),
						KeybindViewerVisible = scope:Value(false),
						add = function(noGlobalStateNamed, arg, arg2)
							if not noGlobalStateNameds[noGlobalStateNamed] then
								error("No global state named: " .. noGlobalStateNamed)
							end

							local noGlobalStateNamed2 = noGlobalStateNameds[noGlobalStateNamed]
							local v46 = peek(noGlobalStateNamed2)

							if type(v46) ~= "table" then
								error(
									"Cannot add to state '"
										.. noGlobalStateNamed
										.. "' because its value is not a table"
								)
							end

							local v47 = table.clone(v46)
							v47[arg2] = arg
							noGlobalStateNamed2:set(v47)
						end,
						remove = function(noGlobalStateNamed, arg)
							if not noGlobalStateNameds[noGlobalStateNamed] then
								error("No global state named: " .. noGlobalStateNamed)
							end

							local noGlobalStateNamed2 = noGlobalStateNameds[noGlobalStateNamed]
							local v46 = peek(noGlobalStateNamed2)

							if type(v46) ~= "table" then
								error(
									"Cannot remove from state '"
										.. noGlobalStateNamed
										.. "' because its value is not a table"
								)
							end

							if v46[arg] == nil then
								return
							end
							local v47 = table.clone(v46)
							v47[arg] = nil
							noGlobalStateNamed2:set(v47)
						end,
					}

					return noGlobalStateNameds
				end)()
			)
		end,
		[118] = function()
			local v, instance, v43 = fn23(118)

			return (
				(function()
					local v44 = v43(instance.http)
					local v45 = v43(instance.auth)
					local v46 = v43(instance.events)
					local v47 = v43(instance.utils)
					local v48 = v43(instance.capabilities)
					local v49 = v43(instance.Parent.packages.states)
					local v50 = v43(instance.Parent.utils.pendingTasks)

					if getgenv().Ethos and getgenv().Ethos.disconnect then
						pcall(function()
							getgenv().Ethos:disconnect()
						end)

						getgenv().Ethos = nil
					end

					local n = 60000
					local v51 = v48.new()
					local info = v51:getInfo()
					local v52 = v44.new(v51:getHttpProvider(), { spawnTask = v50.spawn, cancelTask = v50.cancel })
					local v53 = v45.new(v52)
					local v54 = v46.new(v52)

					local function fn24(arg, arg2, arg3)
						v49.ServerConnected:set(arg)
						v49.ServerConnecting:set(arg2)
						v49.ServerAuthenticating:set(arg3)
					end

					local function fn25()
						return { client = v47.getClientMetadata(info), capabilities = {} }
					end

					local function fn26()
						if not v53:isAuthenticated() then
							return false
						end
						local accessTokenExpiresAt = v53:getAccessTokenExpiresAt()
						if type(accessTokenExpiresAt) ~= "number" then
							return false
						end
						return accessTokenExpiresAt - DateTime.now().UnixTimestampMillis > n
					end

					local courage = {
						auth = v53,
						events = v54,
						connecting = false,
						disconnecting = false,
						ensureConnected = function(arg)
							if arg.disconnecting then
								return false
							end

							if fn26() then
								fn24(true, false, false)
								return true
							end

							if arg.connecting then
								return false
							end
							arg.connecting = true
							fn24(false, true, true)
							local flag19 = false

							local ok, result = pcall(function()
								if v53:isAuthenticated() then
									local v55, v56 = v53:refresh()
									if v55 then
										return true
									end

									if type(v56) ~= "table" or v56.canBootstrap ~= true then
										return false
									end
								end

								return v53:authenticate(fn25()) == true
							end)

							if ok then
								flag19 = result == true
							else
								v47.logError(result, "connection")
							end

							arg.connecting = false
							fn24(flag19, false, false)
							return flag19
						end,
						publishEvent = function(arg, arg2, arg3, arg4)
							if arg.disconnecting then
								return false, "client_disconnecting"
							end

							if not arg:ensureConnected() then
								return false, "backend_unavailable"
							end
							return v54:publish(arg2, arg3, arg4)
						end,
						disconnect = function(arg)
							if arg.disconnecting then
								return
							end
							arg.disconnecting = true
							arg.connecting = false
							v53:cleanup()
							fn24(false, false, false)
							arg.disconnecting = false
						end,
						setAuthKey = function(arg, arg2)
							if not v53:setAuthKey(arg2) then
								return false
							end
							arg:disconnect()
							return true
						end,
					}

					getgenv().Ethos = courage

					getgenv().setAuthKey = function(arg)
						return courage:setAuthKey(arg)
					end

					getgenv().EthosServer = courage
					return courage
				end)()
			)
		end,
		[119] = function()
			local v, instance, v43 = fn23(119)

			return (
				(function()
					local v44 = v43(instance.Parent.config)
					local v45 = v43(instance.Parent.utils)
					local index = {}
					index.__index = index

					local errors = {
						account_not_found = true,
						invalid_refresh_token = true,
						refresh_credential_mismatch = true,
						refresh_token_reuse = true,
					}

					local function fn24(...)
						local v46 = table.pack(...)

						for i = 1, select("#", ...) do
							local value = select(i, table.unpack(v46, 1, v46.n))
							if type(value) == "string" and value ~= "" then
								return value
							end
						end

						return nil
					end

					local function getError(arg)
						if type(arg) ~= "table" then
							return nil
						end
						local data = arg.data
						if type(data) ~= "table" or type(data.error) ~= "table" then
							return nil
						end
						return data.error
					end

					local function getHeader(headers, arg)
						if type(headers) ~= "table" then
							return nil
						end
						local v46 = string.lower(arg)

						for k, header in pairs(headers) do
							if type(k) == "string" and string.lower(k) == v46 then
								return header
							end
						end

						return nil
					end

					local function fn25(arg)
						if type(arg) ~= "table" then
							return nil
						end
						local num = tonumber(getHeader(arg.headers, "retry-after"))
						if num == nil or num < 0 or num >= math.huge then
							return nil
						end
						return num
					end

					local function fn26(arg)
						local statusCode = type(arg) == "table" and arg.statusCode or nil
						local error_ = getError(arg)
						local error_2 = error_ and fn24(error_.code) or nil

						if statusCode == 429 then
							return {
								kind = "rate_limited",
								statusCode = statusCode,
								code = error_2,
								retryAfterSeconds = fn25(arg),
								canBootstrap = false,
							}
						end

						local tbl14 = { kind = "request_failed", statusCode = statusCode, code = error_2 }
						local retryable

						if error_ then
							retryable = error_.retryable == true
						else
							retryable = nil
						end

						tbl14.retryable = retryable
						tbl14.canBootstrap = error_2 ~= nil and errors[error_2] == true
						return tbl14
					end

					index.new = function(arg)
						return setmetatable({
							http = arg,
							authenticated = false,
							userData = nil,
							accessToken = nil,
							refreshToken = nil,
							accessTokenExpiresAt = nil,
							refreshTokenExpiresAt = nil,
							realtime = nil,
							requestGeneration = 0,
						}, index)
					end

					index._buildBootstrapPayload = function(arg, arg2)
						arg2 = type(arg2) == "table" and arg2 or {}
						return {
							licenseKey = v44.AUTH_KEY,
							client = arg2.client,
							capabilities = arg2.capabilities or {},
						}
					end

					index._extractTokens = function(arg, arg2)
						local tbl14 = type(arg2) == "table" and arg2 or {}
						local accessTokenExpiresAt = tbl14.accessTokenExpiresAt
						local refreshTokenExpiresAt = tbl14.refreshTokenExpiresAt
						if type(accessTokenExpiresAt) ~= "number" or type(refreshTokenExpiresAt) ~= "number" then
							return nil, nil, nil, nil, tbl14
						end
						return fn24(tbl14.accessToken),
							fn24(tbl14.refreshToken),
							accessTokenExpiresAt,
							refreshTokenExpiresAt,
							tbl14
					end

					index.authenticate = function(arg, arg2)
						if v44.AUTH_KEY == "" or arg.http == nil then
							return false, { kind = "not_configured", canBootstrap = false }
						end
						local requestGeneration = arg.requestGeneration
						local v46, v47 =
							arg.http:post(v44.AUTH_CLIENT_BOOTSTRAP_PATH, arg:_buildBootstrapPayload(arg2), false)
						if arg.requestGeneration ~= requestGeneration then
							return false, { kind = "cancelled", canBootstrap = false }
						end

						if not v46 then
							v45.logError(v47, "authentication")
							return false, fn26(v47)
						end
						local accessToken, refreshToken, accessTokenExpiresAt, refreshTokenExpiresAt, v48 =
							arg:_extractTokens(v47.data)
						if accessToken == nil or refreshToken == nil then
							return false, { kind = "invalid_response", canBootstrap = false }
						end
						arg.accessToken = accessToken
						arg.refreshToken = refreshToken
						arg.accessTokenExpiresAt = accessTokenExpiresAt
						arg.refreshTokenExpiresAt = refreshTokenExpiresAt
						arg.authenticated = true
						arg.userData = v48.account
						arg.realtime = v48.realtime
						arg.http:setAccessToken(accessToken)
						return true
					end

					index.refresh = function(arg)
						if arg.refreshToken == nil then
							return false, { kind = "refresh_unavailable", canBootstrap = true }
						end

						if v44.AUTH_KEY == "" or arg.http == nil then
							return false, { kind = "not_configured", canBootstrap = false }
						end
						local requestGeneration = arg.requestGeneration
						local v46, v47 = arg.http:post(
							v44.AUTH_CLIENT_REFRESH_PATH,
							{ refreshToken = arg.refreshToken, licenseKey = v44.AUTH_KEY },
							false
						)
						if arg.requestGeneration ~= requestGeneration then
							return false, { kind = "cancelled", canBootstrap = false }
						end

						if not v46 then
							local v48 = fn26(v47)

							if v48.canBootstrap then
								arg.refreshToken = nil
								arg.refreshTokenExpiresAt = nil
							end

							return false, v48
						end

						local accessToken, refreshToken, accessTokenExpiresAt, refreshTokenExpiresAt, v48 =
							arg:_extractTokens(v47.data)
						if accessToken == nil or refreshToken == nil then
							return false, { kind = "invalid_response", canBootstrap = false }
						end
						arg.accessToken = accessToken
						arg.refreshToken = refreshToken
						arg.accessTokenExpiresAt = accessTokenExpiresAt
						arg.refreshTokenExpiresAt = refreshTokenExpiresAt
						arg.authenticated = true
						arg.userData = v48.account or arg.userData
						arg.realtime = v48.realtime or arg.realtime
						arg.http:setAccessToken(accessToken)
						return true
					end

					index.isAuthenticated = function(arg)
						return arg.authenticated
					end

					index.getUserData = function(arg)
						return arg.userData
					end

					index.getAccessToken = function(arg)
						return arg.accessToken
					end

					index.getAccessTokenExpiresAt = function(arg)
						return arg.accessTokenExpiresAt
					end

					index.getRealtimePath = function(arg)
						return arg.realtime and (arg.realtime.path or arg.realtime.clientWebSocketPath)
					end

					index.setAuthKey = function(arg, authKey)
						if type(authKey) ~= "string" or authKey:gsub("%s+", "") == "" then
							return false
						end
						v44.AUTH_KEY = authKey
						return true
					end

					index.cleanup = function(arg)
						arg.requestGeneration += 1
						arg.authenticated = false
						arg.userData = nil
						arg.realtime = nil
						arg.accessToken = nil
						arg.refreshToken = nil
						arg.accessTokenExpiresAt = nil
						arg.refreshTokenExpiresAt = nil

						if arg.http then
							arg.http:setAccessToken(nil)
						end
					end

					return index
				end)()
			)
		end,
		[120] = function()
			fn23(120)

			return (
				(function()
					local index = {}
					index.__index = index

					local function fn24()
						local function fn25(arg)
							return getgenv()[arg]
						end

						return {
							syn = fn25("syn"),
							http = fn25("http"),
							http_request = fn25("http_request"),
							request = fn25("request"),
							fluxus = fn25("fluxus"),
							Krnl = fn25("Krnl"),
							WebSocket = fn25("WebSocket"),
							WebsocketClient = fn25("WebsocketClient"),
							identifyexecutor = fn25("identifyexecutor"),
							getthreadidentity = fn25("getthreadidentity"),
							loadstring = fn25("loadstring"),
							readfile = fn25("readfile"),
							writefile = fn25("writefile"),
							listfiles = fn25("listfiles"),
							getgc = fn25("getgc"),
							getreg = fn25("getreg"),
							getrenv = fn25("getrenv"),
							getnilinstances = fn25("getnilinstances"),
							getconnections = fn25("getconnections"),
							getloadedmodules = fn25("getloadedmodules"),
							getrunningscripts = fn25("getrunningscripts"),
							getscriptbytecode = fn25("getscriptbytecode"),
							decompile = fn25("decompile"),
							firesignal = fn25("firesignal"),
							replicatesignal = fn25("replicatesignal"),
							sethiddenproperty = fn25("sethiddenproperty"),
							task = fn25("task"),
						}
					end

					local function fn25(arg, ...)
						for _, v in ipairs({ ... }) do
							if type(arg) ~= "table" then
								return nil
							end
							arg = arg[v]
						end

						if type(arg) ~= "function" then
							arg = nil
						end

						return arg
					end

					local function fn26(...)
						local v = table.pack(...)

						for i = 1, v.n do
							if type(v[i]) == "function" then
								return v[i]
							end
						end

						return nil
					end

					local function fn27(arg)
						local ok, result = pcall(tostring, arg)

						if not (ok and type(result) == "string") then
							result = "<unprintable>"
						end

						return result
					end

					index.new = function(arg, arg2)
						local tbl14 = arg2 or {}

						return setmetatable({
							globals = arg or fn24(),
							clock = tbl14.clock or os.clock,
							webSocketCapabilityTimeoutSeconds = tbl14.webSocketCapabilityTimeoutSeconds or 5,
						}, index)
					end

					index.getPrimitive = function(arg, arg2)
						local global = arg.globals[arg2]
						local global2

						if type(global) == "function" then
							global2 = global
						else
							global2 = nil
						end

						return global2
					end

					index.getHttpProvider = function(arg)
						local globals = arg.globals
						local httpRequest = globals.http_request
						local request_ = globals.request
						local v = fn26(
							fn25(globals.syn, "request"),
							fn25(globals.http, "request"),
							httpRequest,
							request_,
							fn25(globals.fluxus, "request"),
							fn25(globals.Krnl, "request")
						)
						if v == nil then
							return nil
						end

						return {
							request = function(arg2)
								return v(arg2)
							end,
						}
					end

					index.getWebSocketProvider = function(arg)
						local globals = arg.globals
						local v = fn26(
							fn25(globals.syn, "websocket", "connect"),
							fn25(globals.Krnl, "WebSocket", "connect"),
							fn25(globals.WebSocket, "connect"),
							fn25(globals.fluxus, "websocket", "connect"),
							fn25(globals.WebsocketClient, "connect")
						)
						if v ~= nil then
							return {
								connect = function(arg2)
									return v(arg2)
								end,
							}
						end

						if type(globals.Krnl) == "table" then
							return {
								connect = function(arg2, arg3)
									local webSocket = fn25(globals.Krnl, "WebSocket", "connect")
									local v43 = fn25(globals.task, "wait")
									local n = arg.clock() + math.max(0, arg.webSocketCapabilityTimeoutSeconds)

									while webSocket == nil do
										assert(
											v43,
											"task.wait() is unavailable while waiting for KRNL WebSocket support."
										)

										if type(arg3) == "function" and not arg3() then
											error("KRNL WebSocket capability wait was cancelled.", 0)
										end

										local n27 = n - arg.clock()

										if n27 <= 0 then
											error("Timed out waiting for KRNL WebSocket support.", 0)
										end

										v43(math.min(0.05, n27))
										webSocket = fn25(globals.Krnl, "WebSocket", "connect")
									end

									if type(arg3) == "function" and not arg3() then
										error("KRNL WebSocket capability wait was cancelled.", 0)
									end

									return webSocket(arg2)
								end,
							}
						end

						return nil
					end

					index.getInfo = function(arg)
						local globals = arg.globals
						local identifyexecutor_ = arg:getPrimitive("identifyexecutor")
						local str7 = "unknown"

						if identifyexecutor_ then
							local ok, result = pcall(identifyexecutor_)

							if ok and result ~= nil then
								str7 = fn27(result)
							end
						end

						local getthreadidentity = arg:getPrimitive("getthreadidentity")
						local result = nil

						if getthreadidentity then
							local ok
							ok, result = pcall(getthreadidentity)
							local v = nil

							if not ok then
								result = v
							end
						end

						return {
							executor = str7,
							identity = result,
							primitives = {
								request = arg:getHttpProvider() ~= nil,
								websocket = arg:getWebSocketProvider() ~= nil,
								loadstring = type(globals.loadstring) == "function",
								readfile = type(globals.readfile) == "function",
								writefile = type(globals.writefile) == "function",
								listfiles = type(globals.listfiles) == "function",
								getgc = type(globals.getgc) == "function",
								getreg = type(globals.getreg) == "function",
								getrenv = type(globals.getrenv) == "function",
								getnilinstances = type(globals.getnilinstances) == "function",
								getconnections = type(globals.getconnections) == "function",
								getloadedmodules = type(globals.getloadedmodules) == "function",
								getrunningscripts = type(globals.getrunningscripts) == "function",
								getscriptbytecode = type(globals.getscriptbytecode) == "function",
								decompile = type(globals.decompile) == "function",
								firesignal = type(globals.firesignal) == "function",
								replicatesignal = type(globals.replicatesignal) == "function",
								sethiddenproperty = type(globals.sethiddenproperty) == "function",
							},
						}
					end

					return index
				end)()
			)
		end,
		[121] = function()
			fn23(121)

			return (
				(function()
					local function fn24(...)
						local v = table.pack(...)

						for i = 1, select("#", ...) do
							local value = select(i, table.unpack(v, 1, v.n))
							if type(value) == "string" and value ~= "" then
								return value
							end
						end

						return ""
					end

					return {
						API_BASE_URL = fn24(getgenv().ETHOS_API_BASE_URL, "https://165.1.72.52"),
						REALTIME_CLIENT_PATH = "/api/v1/realtime/roblox",
						AUTH_CLIENT_BOOTSTRAP_PATH = "/api/v1/auth/roblox/bootstrap",
						AUTH_CLIENT_REFRESH_PATH = "/api/v1/auth/roblox/refresh",
						AUTH_KEY = (function()
							local flag19 = type(isfile) == "function" and type(readfile) == "function"
							local str7 = ""

							if flag19 then
								local ok, result = pcall(isfile, "key.txt")

								if ok and result then
									local ok2, result2 = pcall(readfile, "key.txt")

									if ok2 and type(result2) == "string" then
										str7 = result2:gsub("^%s+", ""):gsub("%s+$", "")
									end
								end
							end

							return fn24(
								getgenv().ETHOS_LICENSE_KEY,
								getgenv().script_key,
								getgenv().__ETHOS_LUARMOR_SCRIPT_KEY,
								script_key,
								str7
							)
						end)(),
						CLIENT_VERSION = "0.1.0",
						DEBUG = getgenv().ETHOS_DEBUG ~= false,
						AI_AGENT_ENABLED = getgenv().ETHOS_AI_AGENT_ENABLED == true,
						PROTOCOL_VERSION = 1,
					}
				end)()
			)
		end,
		[122] = function()
			local v, instance, v43 = fn23(122)

			return (
				(function()
					local v44 = v43(instance.Parent.utils)
					local index = {}
					index.__index = index

					local function fn24(arg, arg2)
						if type(arg) == "string" and arg ~= "" then
							return arg
						end
						return arg2
					end

					index.new = function(arg)
						assert(arg ~= nil, "Events.new requires an HTTP client")
						return setmetatable({ http = arg }, index)
					end

					index.publish = function(arg, arg2, arg3, arg4)
						local tbl14 = type(arg4) == "table" and arg4 or {}
						if type(arg2) ~= "string" or arg2 == "" or type(arg3) ~= "table" then
							return false, "invalid_event"
						end
						local game_ = type(tbl14.game) == "table" and tbl14.game or {}

						local events, v45 = arg.http:post("/api/v1/events", {
							eventId = fn24(tbl14.eventId, "evt_" .. v44.generateId()),
							type = arg2,
							game = {
								key = fn24(game_.key, "roblox"),
								name = fn24(game_.name, "Roblox"),
								placeId = fn24(game_.placeId, tostring(game.PlaceId)),
								universeId = fn24(game_.universeId, tostring(game.GameId)),
							},
							data = arg3,
						}, true)

						if not events then
							return false, v45
						end
						return true, v45 and v45.data or nil
					end

					return index
				end)()
			)
		end,
		[123] = function()
			local v, instance, v43 = fn23(123)

			return (
				(function()
					local httpService = v43(instance.Parent.Parent.utils.services).HttpService
					local v44 = v43(instance.Parent.config)
					local index = {}
					index.__index = index
					local v45 = 10

					local function fn24(apiBaseUrl, arg)
						if type(arg) == "string" and arg:sub(1, 4) == "http" then
							return arg
						end
						return (apiBaseUrl or ""):gsub("/+$", "") .. "/" .. (arg or ""):gsub("^/+", "")
					end

					local function fn25(body)
						return type(body) == "table" and next(body) == nil
					end

					index.new = function(arg, arg2)
						arg2 = type(arg2) == "table" and arg2 or {}

						return setmetatable({
							provider = arg,
							accessToken = nil,
							requestTimeoutSeconds = arg2.requestTimeoutSeconds or v45,
							spawnTask = arg2.spawnTask or task.spawn,
							cancelTask = arg2.cancelTask or task.cancel,
							waitTask = arg2.waitTask or task.wait,
							clock = arg2.clock or os.clock,
						}, index)
					end

					index.setAccessToken = function(arg, accessToken)
						arg.accessToken = accessToken
					end

					index.getAccessToken = function(arg)
						return arg.accessToken
					end

					index.buildUrl = function(arg, arg2, arg3)
						local v46 = fn24(v44.API_BASE_URL, arg2 or "")
						local tbl14 = {}

						if type(arg3) == "table" then
							for k, v47 in pairs(arg3) do
								if v47 ~= nil then
									table.insert(
										tbl14,
										httpService:UrlEncode(tostring(k))
											.. "="
											.. httpService:UrlEncode(tostring(v47))
									)
								end
							end
						end

						return #tbl14 > 0 and v46 .. "?" .. table.concat(tbl14, "&") or v46
					end

					index.request = function(arg, arg2)
						if not arg.provider then
							return false, "No executor HTTP request implementation found"
						end
						local v46 = table.clone(arg2.headers or {})
						v46.Accept = v46.Accept or "application/json"
						local body = arg2.body

						if type(body) == "table" then
							body = fn25(body) and "{}" or httpService:JSONEncode(body)
							v46["Content-Type"] = v46["Content-Type"] or "application/json"
						end

						if arg2.authenticated and arg.accessToken then
							v46.Authorization = "Bearer " .. arg.accessToken
						end

						local flag19 = false
						local ok3 = false
						local v47 = nil

						local ok, result = pcall(arg.spawnTask, function()
							local ok, result = pcall(function()
								return arg.provider.request({
									Url = arg:buildUrl(arg2.path or arg2.url or "", arg2.query),
									Method = string.upper(arg2.method or "GET"),
									Headers = v46,
									Body = body,
								})
							end)

							ok3 = ok
							v47 = result
							flag19 = true
						end)

						if not ok then
							return false, result
						end
						local n = arg.clock() + math.max(0, arg2.timeoutSeconds or arg.requestTimeoutSeconds)

						while not flag19 do
							local n27 = n - arg.clock()

							if n27 <= 0 then
								if result ~= nil then
									pcall(arg.cancelTask, result)
								end

								return false,
									{
										statusCode = 0,
										body = "",
										data = { error = { code = "request_timeout", retryable = true } },
										headers = {},
									}
							end

							arg.waitTask(math.min(0.05, n27))
						end

						if not ok3 then
							return false, v47
						end
						local statusCode = v47.StatusCode or v47.Status or 0
						local body2 = v47.Body or v47.body or ""
						local flag20 = type(body2) == "string" and body2 ~= ""
						local result2 = nil

						if flag20 then
							local ok2

							ok2, result2 = pcall(function()
								return httpService:JSONDecode(body2)
							end)

							local v48 = nil

							if not ok2 then
								result2 = v48
							end
						end

						local tbl14 = {
							statusCode = statusCode,
							body = body2,
							data = result2,
							headers = v47.Headers or v47.headers or {},
						}
						if statusCode < 200 or statusCode >= 300 then
							return false, tbl14
						end
						return true, tbl14
					end

					index.get = function(arg, arg2, arg3, arg4)
						return arg:request({ method = "GET", path = arg2, query = arg3, authenticated = arg4 })
					end

					index.post = function(arg, arg2, arg3, arg4)
						return arg:request({ method = "POST", path = arg2, body = arg3, authenticated = arg4 })
					end

					index.patch = function(arg, arg2, arg3, arg4)
						return arg:request({ method = "PATCH", path = arg2, body = arg3, authenticated = arg4 })
					end

					return index
				end)()
			)
		end,
		[124] = function()
			local v, instance, v43 = fn23(124)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.utils.services)
					local httpService = v44.HttpService
					local players = v44.Players
					local v45 = v43(instance.Parent.config)
					local tbl14

					tbl14 = {
						_clientInstanceId = nil,
						log = function(...)
							if v45.DEBUG then
								print("[UI Server]", ...)
							end
						end,
						logError = function(arg, arg2)
							if not v45.DEBUG then
								return
							end
							warn("[UI Server Error]", arg2 and tostring(arg2) or "", tostring(arg))
						end,
						generateId = function()
							return httpService:GenerateGUID(false)
						end,
						jsonEncode = function(arg)
							local ok, result = pcall(function()
								return httpService:JSONEncode(arg)
							end)

							if not ok then
								tbl14.logError(result, "json encode")
								return nil
							end
							return result
						end,
						jsonDecode = function(arg)
							local ok, result = pcall(function()
								return httpService:JSONDecode(arg)
							end)

							if not ok then
								tbl14.logError(result, "json decode")
								return nil
							end
							return result
						end,
						getPlayerInfo = function()
							local localPlayer = players.LocalPlayer
							local name = localPlayer and localPlayer.Name or "Unknown"

							return {
								username = name,
								displayName = localPlayer and (localPlayer.DisplayName or name) or name,
								userId = localPlayer and localPlayer.UserId or 0,
							}
						end,
						getClientInstanceId = function()
							if tbl14._clientInstanceId == nil then
								tbl14._clientInstanceId = "roblox_" .. tbl14.generateId()
							end

							return tbl14._clientInstanceId
						end,
						getClientMetadata = function(arg)
							local playerInfo = tbl14.getPlayerInfo()
							local name = "Unknown"

							pcall(function()
								name = game.Name
							end)

							return {
								clientInstanceId = tbl14.getClientInstanceId(),
								clientVersion = v45.CLIENT_VERSION,
								executor = arg.executor,
								username = playerInfo.username,
								displayName = playerInfo.displayName,
								userId = playerInfo.userId,
								gameName = name,
								gameId = game.GameId,
								placeId = game.PlaceId,
								jobId = game.JobId,
							}
						end,
						getRobloxContext = function()
							return {
								player = tbl14.getPlayerInfo(),
								game = {
									name = game.Name,
									gameId = game.GameId,
									placeId = game.PlaceId,
									jobId = game.JobId,
								},
							}
						end,
					}

					return tbl14
				end)()
			)
		end,
		[126] = function()
			local v, instance, v43 = fn23(126)

			return (
				(function()
					local parent = instance.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.packages.states)
					local v46 = v43(parent.Internal)
					local v47 = v43(parent.storage.themes)
					local v48 = v43(parent.utils.themeUtils)
					local scope = v46.Scope
					local peek = v44.peek
					local theme = v45.Theme

					local function fn24(arg)
						return v48.WithConfigDefaults(v47.getTheme(arg))
					end

					local function fn25()
						local setThemeForScope = v48.SetThemeForScope
						local v49 = table.pack(fn24(peek(theme)))
						setThemeForScope(scope, table.unpack(v49, 1, v49.n))
					end

					fn25()
					v44.Observer(scope, theme):onChange(fn25)
					local themeForScope = v48.GetThemeForScope(scope)
					local tbl14 = {}

					for k in pairs(fn24("eclipse").navbar) do
						table.insert(tbl14, k)
					end

					table.freeze(tbl14)

					local v49 = scope:Computed(function(arg)
						local v49 = arg(theme)
						return fn24(v49).navbar
					end)

					local tbl15 = {}

					for _, v50 in ipairs(tbl14) do
						tbl15[v50] = scope:Computed(function(arg)
							return arg(v49)[v50]
						end)
					end

					table.freeze(tbl15)

					local function getThemeNames()
						return v47.getThemeNames()
					end

					local function setTheme(arg)
						if v47.getTheme(arg) then
							theme:set(arg)
						end
					end

					local function getNavbarTheme(arg)
						if arg then
							return tbl15[arg]
						end
						return tbl15
					end

					themeForScope.GetThemeForScope = function(arg)
						return v48.GetThemeForScope(arg) or themeForScope
					end

					themeForScope.SetThemeForScope = v48.SetThemeForScope
					themeForScope.GetNextVariant = v48.GetNextVariant
					themeForScope.CalcColorModifier = v48.CalcColorModifier

					themeForScope.ApplyColorModifier = function(arg, arg2, arg3)
						return v48.ApplyColorModifier(themeForScope, arg, arg2, arg3)
					end

					themeForScope.GetSupportedThemes = getThemeNames
					themeForScope.SetTheme = setTheme
					themeForScope.GetNavbarTheme = getNavbarTheme
					return themeForScope
				end)()
			)
		end,
		[127] = function()
			local v, v43, v44 = fn23(127)

			return (function()
				local tbl14 = {
					amber = v43.amber,
					axiom = v43.axiom,
					bone = v43.bone,
					bronze = v43.bronze,
					clay = v43.clay,
					crimson = v43.crimson,
					dark = v43.dark,
					eclipse = v43.eclipse,
					ember = v43.ember,
					granite = v43.granite,
					mauve = v43.mauve,
					midnight = v43.midnight,
					moraine = v43.moraine,
					nocturne = v43.nocturne,
					obsidian = v43.obsidian,
					onyx = v43.onyx,
					petrol = v43.petrol,
					pine = v43.pine,
					sage = v43.sage,
					shadow = v43.shadow,
					slate = v43.slate,
					strata = v43.strata,
					vapor = v43.vapor,
					velvet = v43.velvet,
					wine = v43.wine,
				}

				local tbl15 = {}

				local function fn24(arg)
					if type(arg) ~= "table" or table.isfrozen(arg) then
						return arg
					end

					for _, v45 in pairs(arg) do
						if type(v45) == "table" and not table.isfrozen(v45) then
							fn24(v45)
						end
					end

					return table.freeze(arg)
				end

				local tbl16 = {}

				for k in pairs(tbl14) do
					table.insert(tbl16, k)
				end

				table.sort(tbl16)
				local v45 = table.freeze(tbl16)

				return table.freeze({
					getTheme = function(arg)
						if tbl15[arg] then
							return tbl15[arg]
						end
						local v46 = tbl14[arg]
						if not v46 then
							return nil
						end
						local v47 = v44(v46)
						fn24(v47)
						tbl15[arg] = v47
						return v47
					end,
					getThemeNames = function()
						return v45
					end,
				})
			end)()
		end,
		[128] = function()
			local v, instance, v43 = fn23(128)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "amber",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(11, 11, 15),
							foreground = rgb(230, 230, 230),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.08,
							dropshadowTransparency = 0.8,
							glowTransparency = 0.4,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(216, 159, 79)),
									ColorSequenceKeypoint.new(0.25, rgb(220, 169, 95)),
									ColorSequenceKeypoint.new(0.5, rgb(224, 179, 111)),
									ColorSequenceKeypoint.new(0.75, rgb(228, 189, 127)),
									ColorSequenceKeypoint.new(1, rgb(232, 199, 143)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 45,
							},
						},
						BgBaseColor = rgb(11, 11, 15),
						AccentPrimary = rgb(216, 159, 79),
						AccentSecondary = rgb(60, 170, 190),
						AccentCaution = rgb(230, 180, 80),
						AccentDestructive = rgb(255, 92, 92),
					}
				end)()
			)
		end,
		[129] = function()
			local v, instance, v43 = fn23(129)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "axiom",
						navbar = {
							outlined = true,
							acrylic = false,
							background = rgb(13, 16, 21),
							foreground = rgb(232, 239, 247),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.05,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.58,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(73, 137, 238)),
									ColorSequenceKeypoint.new(0.35, rgb(82, 157, 244)),
									ColorSequenceKeypoint.new(0.7, rgb(91, 187, 213)),
									ColorSequenceKeypoint.new(1, rgb(104, 211, 180)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 195,
							},
						},
						BgBaseColor = rgb(19, 22, 27),
						BgTintColor = rgb(35, 46, 59),
						AccentPrimary = rgb(73, 137, 238),
						AccentSecondary = rgb(89, 190, 166),
						AccentCaution = rgb(218, 171, 98),
						AccentDestructive = rgb(226, 112, 123),
					}
				end)()
			)
		end,
		[130] = function()
			local v, instance, v43 = fn23(130)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "bone",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(20, 19, 18),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78000000000000003,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(176, 170, 156)),
									ColorSequenceKeypoint.new(0.25, rgb(186, 180, 166)),
									ColorSequenceKeypoint.new(0.5, rgb(196, 190, 176)),
									ColorSequenceKeypoint.new(0.75, rgb(206, 200, 186)),
									ColorSequenceKeypoint.new(1, rgb(216, 210, 196)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 75,
							},
						},
						BgBaseColor = rgb(17, 16, 15),
						BgTintColor = rgb(36, 34, 30),
						AccentPrimary = rgb(176, 170, 156),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[131] = function()
			local v, instance, v43 = fn23(131)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "bronze",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(19, 17, 14),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78000000000000003,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(152, 102, 52)),
									ColorSequenceKeypoint.new(0.25, rgb(162, 112, 62)),
									ColorSequenceKeypoint.new(0.5, rgb(172, 122, 72)),
									ColorSequenceKeypoint.new(0.75, rgb(182, 132, 82)),
									ColorSequenceKeypoint.new(1, rgb(192, 142, 92)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 45,
							},
						},
						BgBaseColor = rgb(16, 14, 11),
						BgTintColor = rgb(42, 30, 18),
						AccentPrimary = rgb(152, 102, 52),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[132] = function()
			local v, instance, v43 = fn23(132)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "clay",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(22, 18, 17),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(182, 104, 82)),
									ColorSequenceKeypoint.new(0.25, rgb(192, 114, 92)),
									ColorSequenceKeypoint.new(0.5, rgb(202, 124, 102)),
									ColorSequenceKeypoint.new(0.75, rgb(212, 134, 112)),
									ColorSequenceKeypoint.new(1, rgb(222, 144, 122)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 45,
							},
						},
						BgBaseColor = rgb(18, 15, 14),
						BgTintColor = rgb(44, 30, 26),
						AccentPrimary = rgb(182, 104, 82),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[133] = function()
			local v, instance, v43 = fn23(133)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "crimson",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(11, 11, 15),
							foreground = rgb(230, 230, 230),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.08,
							dropshadowTransparency = 0.8,
							glowTransparency = 0.4,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(216, 79, 104)),
									ColorSequenceKeypoint.new(0.25, rgb(225, 95, 120)),
									ColorSequenceKeypoint.new(0.5, rgb(235, 110, 135)),
									ColorSequenceKeypoint.new(0.75, rgb(245, 125, 150)),
									ColorSequenceKeypoint.new(1, rgb(255, 140, 165)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 135,
							},
						},
						BgBaseColor = rgb(11, 11, 15),
						AccentPrimary = rgb(216, 79, 104),
						AccentSecondary = rgb(75, 180, 200),
						AccentCaution = rgb(230, 184, 70),
						AccentDestructive = rgb(255, 92, 92),
					}
				end)()
			)
		end,
		[134] = function()
			local v, instance, v43 = fn23(134)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb
					local new = ColorSequenceKeypoint.new
					local v44 = 255

					return {
						name = "dark",
						navbar = {
							outlined = false,
							acrylic = false,
							background = rgb(26, 26, 26),
							foreground = rgb(255, 255, 255),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.08,
							dropshadowTransparency = 0.65,
							glowTransparency = 0.7,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(0, 110, 230)),
									ColorSequenceKeypoint.new(0.25, rgb(50, 130, 240)),
									ColorSequenceKeypoint.new(0.5, rgb(80, 150, 250)),
									ColorSequenceKeypoint.new(0.75, rgb(110, 170, 255)),
									new(1, rgb(140, 190, v44)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 0,
							},
						},
						BgBaseColor = rgb(15, 15, 15),
						AccentPrimary = rgb(0, 110, 230),
						AccentSecondary = rgb(40, 170, 190),
						AccentCaution = rgb(215, 149, 33),
						AccentDestructive = rgb(220, 50, 47),
					}
				end)()
			)
		end,
		[135] = function()
			local v, instance, v43 = fn23(135)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "eclipse",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(18, 18, 22),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.8,
							glowTransparency = 0.45,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(70, 100, 210)),
									ColorSequenceKeypoint.new(0.25, rgb(80, 110, 220)),
									ColorSequenceKeypoint.new(0.5, rgb(90, 120, 230)),
									ColorSequenceKeypoint.new(0.75, rgb(100, 130, 240)),
									ColorSequenceKeypoint.new(1, rgb(110, 140, 250)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 210,
							},
						},
						BgBaseColor = rgb(18, 18, 22),
						AccentPrimary = rgb(70, 100, 210),
						AccentSecondary = rgb(55, 165, 185),
						AccentCaution = rgb(200, 145, 50),
						AccentDestructive = rgb(200, 55, 60),
					}
				end)()
			)
		end,
		[136] = function()
			local v, instance, v43 = fn23(136)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb
					local new = ColorSequenceKeypoint.new

					return {
						name = "ember",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(20, 18, 17),
							foreground = rgb(240, 235, 230),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.08,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(195, 110, 70)),
									ColorSequenceKeypoint.new(0.25, rgb(205, 120, 80)),
									ColorSequenceKeypoint.new(0.5, rgb(215, 130, 90)),
									ColorSequenceKeypoint.new(0.75, rgb(225, 140, 100)),
									new(1, rgb(235, 150, 110)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 60,
							},
						},
						BgBaseColor = rgb(17, 15, 14),
						AccentPrimary = rgb(195, 110, 70),
						AccentSecondary = rgb(60, 165, 185),
						AccentCaution = rgb(210, 145, 50),
						AccentDestructive = rgb(205, 55, 60),
					}
				end)()
			)
		end,
		[137] = function()
			local v, instance, v43 = fn23(137)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "granite",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(18, 19, 21),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(138, 142, 150)),
									ColorSequenceKeypoint.new(0.25, rgb(148, 152, 160)),
									ColorSequenceKeypoint.new(0.5, rgb(158, 162, 170)),
									ColorSequenceKeypoint.new(0.75, rgb(168, 172, 180)),
									ColorSequenceKeypoint.new(1, rgb(178, 182, 190)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 90,
							},
						},
						BgBaseColor = rgb(15, 16, 17),
						BgTintColor = rgb(30, 33, 36),
						AccentPrimary = rgb(138, 142, 150),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[138] = function()
			local v, instance, v43 = fn23(138)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "mauve",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(20, 18, 21),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(150, 108, 142)),
									ColorSequenceKeypoint.new(0.25, rgb(160, 118, 152)),
									ColorSequenceKeypoint.new(0.5, rgb(170, 128, 162)),
									ColorSequenceKeypoint.new(0.75, rgb(180, 138, 172)),
									ColorSequenceKeypoint.new(1, rgb(190, 148, 182)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 285,
							},
						},
						BgBaseColor = rgb(17, 15, 18),
						BgTintColor = rgb(36, 29, 40),
						AccentPrimary = rgb(150, 108, 142),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[139] = function()
			local v, instance, v43 = fn23(139)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb
					local new = ColorSequenceKeypoint.new

					return {
						name = "midnight",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(15, 17, 24),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(52, 66, 130)),
									ColorSequenceKeypoint.new(0.25, rgb(62, 76, 140)),
									ColorSequenceKeypoint.new(0.5, rgb(72, 86, 150)),
									ColorSequenceKeypoint.new(0.75, rgb(82, 96, 160)),
									new(1, rgb(92, 106, 170)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 210,
							},
						},
						BgBaseColor = rgb(12, 14, 20),
						BgTintColor = rgb(24, 32, 54),
						AccentPrimary = rgb(52, 66, 130),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[140] = function()
			local v, instance, v43 = fn23(140)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "moraine",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(16, 19, 21),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(92, 132, 138)),
									ColorSequenceKeypoint.new(0.25, rgb(102, 142, 148)),
									ColorSequenceKeypoint.new(0.5, rgb(112, 152, 158)),
									ColorSequenceKeypoint.new(0.75, rgb(122, 162, 168)),
									ColorSequenceKeypoint.new(1, rgb(132, 172, 178)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 180,
							},
						},
						BgBaseColor = rgb(13, 16, 18),
						BgTintColor = rgb(26, 38, 42),
						AccentPrimary = rgb(92, 132, 138),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[141] = function()
			local v, instance, v43 = fn23(141)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "nocturne",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(12, 15, 25),
							foreground = rgb(235, 239, 249),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.1,
							dropshadowTransparency = 0.82,
							glowTransparency = 0.42,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(106, 119, 239)),
									ColorSequenceKeypoint.new(0.25, rgb(116, 132, 246)),
									ColorSequenceKeypoint.new(0.5, rgb(129, 146, 250)),
									ColorSequenceKeypoint.new(0.75, rgb(143, 164, 250)),
									ColorSequenceKeypoint.new(1, rgb(157, 186, 249)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 225,
							},
						},
						BgBaseColor = rgb(14, 17, 28),
						BgTintColor = rgb(25, 34, 59),
						AccentPrimary = rgb(106, 119, 239),
						AccentSecondary = rgb(79, 190, 190),
						AccentCaution = rgb(228, 177, 86),
						AccentDestructive = rgb(229, 101, 119),
					}
				end)()
			)
		end,
		[142] = function()
			local v, instance, v43 = fn23(142)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "obsidian",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(22, 22, 29),
							foreground = rgb(230, 230, 235),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.10000000000000001,
							dropshadowTransparency = 0.75,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(110, 60, 190)),
									ColorSequenceKeypoint.new(0.25, rgb(130, 80, 210)),
									ColorSequenceKeypoint.new(0.5, rgb(150, 100, 230)),
									ColorSequenceKeypoint.new(0.75, rgb(170, 120, 245)),
									ColorSequenceKeypoint.new(1, rgb(190, 140, 255)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 90,
							},
						},
						BgBaseColor = rgb(22, 22, 29),
						AccentPrimary = rgb(110, 60, 190),
						AccentSecondary = rgb(60, 180, 195),
						AccentCaution = rgb(215, 145, 45),
						AccentDestructive = rgb(215, 60, 65),
					}
				end)()
			)
		end,
		[143] = function()
			local v, instance, v43 = fn23(143)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "onyx",
						navbar = {
							outlined = false,
							acrylic = false,
							background = rgb(24, 24, 26),
							foreground = rgb(245, 245, 250),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.07,
							dropshadowTransparency = 0.7,
							glowTransparency = 0.55,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(235, 125, 0)),
									ColorSequenceKeypoint.new(0.25, rgb(240, 135, 20)),
									ColorSequenceKeypoint.new(0.5, rgb(245, 145, 40)),
									ColorSequenceKeypoint.new(0.75, rgb(250, 155, 60)),
									ColorSequenceKeypoint.new(1, rgb(255, 165, 80)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 15,
							},
						},
						BgBaseColor = rgb(24, 24, 26),
						AccentPrimary = rgb(235, 125, 0),
						AccentSecondary = rgb(60, 175, 195),
						AccentCaution = rgb(225, 155, 30),
						AccentDestructive = rgb(225, 55, 45),
					}
				end)()
			)
		end,
		[144] = function()
			local v, instance, v43 = fn23(144)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "petrol",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(16, 19, 22),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(48, 112, 120)),
									ColorSequenceKeypoint.new(0.25, rgb(58, 122, 130)),
									ColorSequenceKeypoint.new(0.5, rgb(68, 132, 140)),
									ColorSequenceKeypoint.new(0.75, rgb(78, 142, 150)),
									ColorSequenceKeypoint.new(1, rgb(88, 152, 160)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 180,
							},
						},
						BgBaseColor = rgb(13, 15, 18),
						BgTintColor = rgb(26, 44, 50),
						AccentPrimary = rgb(48, 112, 120),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[145] = function()
			local v, instance, v43 = fn23(145)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb
					local new = ColorSequenceKeypoint.new

					return {
						name = "pine",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(15, 18, 16),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(54, 98, 72)),
									ColorSequenceKeypoint.new(0.25, rgb(64, 108, 82)),
									ColorSequenceKeypoint.new(0.5, rgb(74, 118, 92)),
									ColorSequenceKeypoint.new(0.75, rgb(84, 128, 102)),
									new(1, rgb(94, 138, 112)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 135,
							},
						},
						BgBaseColor = rgb(12, 15, 13),
						BgTintColor = rgb(24, 42, 32),
						AccentPrimary = rgb(54, 98, 72),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[146] = function()
			local v, instance, v43 = fn23(146)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "sage",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(17, 20, 18),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(120, 142, 116)),
									ColorSequenceKeypoint.new(0.25, rgb(130, 152, 126)),
									ColorSequenceKeypoint.new(0.5, rgb(140, 162, 136)),
									ColorSequenceKeypoint.new(0.75, rgb(150, 172, 146)),
									ColorSequenceKeypoint.new(1, rgb(160, 182, 156)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 150,
							},
						},
						BgBaseColor = rgb(14, 17, 16),
						BgTintColor = rgb(30, 40, 34),
						AccentPrimary = rgb(120, 142, 116),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[147] = function()
			local v, instance, v43 = fn23(147)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "shadow",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(18, 20, 25),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.1,
							dropshadowTransparency = 0.75,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(60, 180, 200)),
									ColorSequenceKeypoint.new(0.25, rgb(80, 190, 210)),
									ColorSequenceKeypoint.new(0.5, rgb(100, 200, 220)),
									ColorSequenceKeypoint.new(0.75, rgb(120, 210, 230)),
									ColorSequenceKeypoint.new(1, rgb(140, 220, 240)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 120,
							},
						},
						BgBaseColor = rgb(18, 20, 25),
						AccentPrimary = rgb(60, 180, 200),
						AccentSecondary = rgb(45, 175, 195),
						AccentCaution = rgb(205, 150, 45),
						AccentDestructive = rgb(205, 60, 75),
					}
				end)()
			)
		end,
		[148] = function()
			local v, instance, v43 = fn23(148)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "slate",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(16, 18, 23),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78000000000000003,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(96, 112, 168)),
									ColorSequenceKeypoint.new(0.25, rgb(108, 124, 178)),
									ColorSequenceKeypoint.new(0.5, rgb(120, 136, 188)),
									ColorSequenceKeypoint.new(0.75, rgb(132, 148, 198)),
									ColorSequenceKeypoint.new(1, rgb(144, 160, 208)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 210,
							},
						},
						BgBaseColor = rgb(13, 15, 19),
						BgTintColor = rgb(28, 34, 46),
						AccentPrimary = rgb(96, 112, 168),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[149] = function()
			local v, instance, v43 = fn23(149)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "strata",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(18, 20, 25),
							foreground = rgb(230, 235, 242),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.1,
							dropshadowTransparency = 0.76,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(52, 211, 153)),
									ColorSequenceKeypoint.new(0.5, rgb(125, 211, 252)),
									ColorSequenceKeypoint.new(1, rgb(59, 130, 246)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 200,
							},
						},
						BgBaseColor = rgb(16, 18, 22),
						AccentPrimary = rgb(52, 211, 153),
						AccentSecondary = rgb(125, 211, 252),
						AccentCaution = rgb(217, 119, 6),
						AccentDestructive = rgb(239, 68, 68),
					}
				end)()
			)
		end,
		[150] = function()
			fn23(150)

			return (
				(function()
					return {
						hex = function(arg)
							local str7 = arg:gsub("#", "")
							return Color3.fromRGB(
								tonumber(str7:sub(1, 2), 16) or 0,
								tonumber(str7:sub(3, 4), 16) or 0,
								tonumber(str7:sub(5, 6), 16) or 0
							)
						end,
						rgb = function(r, g, b)
							return Color3.fromRGB(r, g, b)
						end,
					}
				end)()
			)
		end,
		[151] = function()
			local v, instance, v43 = fn23(151)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "vapor",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(20, 22, 28),
							foreground = rgb(240, 242, 250),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.11,
							dropshadowTransparency = 0.8,
							glowTransparency = 0.45,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(130, 110, 160)),
									ColorSequenceKeypoint.new(0.25, rgb(140, 120, 170)),
									ColorSequenceKeypoint.new(0.5, rgb(150, 130, 180)),
									ColorSequenceKeypoint.new(0.75, rgb(160, 140, 190)),
									ColorSequenceKeypoint.new(1, rgb(170, 150, 200)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 60,
							},
						},
						BgBaseColor = rgb(20, 22, 28),
						AccentPrimary = rgb(130, 110, 160),
						AccentSecondary = rgb(60, 170, 190),
						AccentCaution = rgb(215, 150, 40),
						AccentDestructive = rgb(215, 60, 70),
					}
				end)()
			)
		end,
		[152] = function()
			local v, instance, v43 = fn23(152)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "velvet",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(23, 17, 28),
							foreground = rgb(243, 237, 246),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.1,
							dropshadowTransparency = 0.82,
							glowTransparency = 0.44,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(176, 112, 215)),
									ColorSequenceKeypoint.new(0.25, rgb(187, 123, 221)),
									ColorSequenceKeypoint.new(0.5, rgb(199, 134, 226)),
									ColorSequenceKeypoint.new(0.75, rgb(211, 147, 222)),
									ColorSequenceKeypoint.new(1, rgb(224, 161, 217)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 300,
							},
						},
						BgBaseColor = rgb(27, 20, 32),
						BgTintColor = rgb(48, 29, 54),
						AccentPrimary = rgb(176, 112, 215),
						AccentSecondary = rgb(115, 190, 198),
						AccentCaution = rgb(226, 174, 90),
						AccentDestructive = rgb(229, 105, 137),
					}
				end)()
			)
		end,
		[153] = function()
			local v, instance, v43 = fn23(153)

			return (
				(function()
					local rgb = v43(instance.Parent.utils).rgb

					return {
						name = "wine",
						navbar = {
							outlined = false,
							acrylic = true,
							background = rgb(19, 16, 18),
							foreground = rgb(235, 235, 240),
							dropshadow = rgb(0, 0, 0),
							transparency = 0.09,
							dropshadowTransparency = 0.78,
							glowTransparency = 0.5,
							accentGradient = {
								color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, rgb(135, 62, 72)),
									ColorSequenceKeypoint.new(0.25, rgb(145, 72, 82)),
									ColorSequenceKeypoint.new(0.5, rgb(155, 82, 92)),
									ColorSequenceKeypoint.new(0.75, rgb(165, 92, 102)),
									ColorSequenceKeypoint.new(1, rgb(175, 102, 112)),
								}),
								transparency = NumberSequence.new(0),
								rotation = 300,
							},
						},
						BgBaseColor = rgb(16, 14, 16),
						BgTintColor = rgb(38, 26, 32),
						AccentPrimary = rgb(135, 62, 72),
						AccentSecondary = rgb(60, 175, 190),
						AccentCaution = rgb(210, 150, 40),
						AccentDestructive = rgb(210, 60, 65),
					}
				end)()
			)
		end,
		[155] = function()
			local v, instance, v43 = fn23(155)

			return (
				(function()
					local parent = instance.Parent.Parent
					local userInputService = v43(parent.utils.services).UserInputService
					local packages = parent.packages
					local v44 = v43(packages.fusion)
					local v45 = v43(packages.states)
					local v46 = nil
					local v47 = nil
					local scope = v43(parent.Internal).Scope
					local peek = v44.peek
					local v48 = v43(parent.utils.perf)
					local v49 = v43(parent.utils.pendingTasks)
					local tbl14 = {}
					local names = {}
					local v50 = nil
					local v51 = nil
					local v52 = nil

					return {
						Initialize = function()
							peek(v45.Library):AddConnection(
								userInputService.InputBegan:Connect(function(input, gameProcessed)
									if gameProcessed then
										return
									end

									if input.KeyCode == peek(v45.CommandBarPrefix) then
										v49.defer(function()
											v45.CommandBarOpened:set(true)
										end)
									end
								end)
							)
						end,
						SetupModuleSystem = function(arg, arg2)
							v46 = v46 or v43(packages.damerau)
							v47 = v47 or v43(packages.cmdr)
							local scope2 = arg2 or scope
							table.clear(tbl14)
							table.clear(names)
							v52 = v47.new({ prefix = peek(v45.CommandBarPrefix) })
							local flag19 = false
							local str7 = ""
							local tbl15 = {}

							local function fn24()
								v48.time("ui:commandBar:generateSuggestions", function()
									flag19 = false
									local tbl16 = {}
									local v53 = peek(v45.CommandBarText)
									if v53 == "" then
										v45.Suggestions:set({})
										return
									end

									if v53 == str7 then
										v45.Suggestions:set(tbl15)
										return
									end

									for _, v54 in names do
										local v55 = tbl14[v54]
										local v56 = v46.raw(v53, v54)

										if v55.aliases then
											for _, aliase in ipairs(v55.aliases) do
												local v57 = v46.raw(v53, aliase)

												if v57 < v56 then
													v56 = v57
												end
											end
										end

										tbl16[v54] = v56
									end

									local tbl17 = {}

									for k in tbl16 do
										table.insert(tbl17, k)
									end

									table.sort(tbl17, function(arg3, arg4)
										return tbl16[arg3] < tbl16[arg4]
									end)

									local tbl18 = {}
									local v54 = 0

									for k, v55 in tbl17 do
										if not (tbl16[v55] < 5) then
											continue
										end
										local v56 = tbl14[v55]

										if v56.aliases and #v56.aliases > 0 then
											v55 ..= " / " .. table.concat(v56.aliases, " / ")
										end

										table.insert(tbl18, {
											name = v55,
											description = v56.description,
											types = v56.arguments,
											top = k == 1 and true or false,
										})

										v54 += 1
										if v54 >= 8 then
											break
										end
									end

									str7 = v53
									tbl15 = tbl18
									v45.Suggestions:set(tbl18)
								end)
							end

							scope2:Observer(v45.CommandBarText):onChange(function()
								if not flag19 then
									flag19 = true

									v50 = v49.delay(0.085, function()
										v50 = nil
										fn24()
									end)
								end
							end)

							scope2:Observer(v45.ToExecute):onChange(function()
								v51 = v49.defer(function()
									v51 = nil

									v48.profile("ui:commandBar:execute", function()
										local v53 = peek(v45.ToExecute)
										if v53 == "" then
											return
										end
										v52:executeCommand(v53)
										v45.ToExecute:set("")
									end)
								end)
							end)

							return function(arg3, arg4)
								assert(v52 ~= nil, "CommandBar has been cleaned up")
								assert(type(arg4) == "table", "Module data must be a table")
								assert(type(arg4.name) == "string", "Module must have a name")
								assert(type(arg4.description) == "string", "Module must have a description")
								assert(type(arg4.callback) == "function", "Module must have a callback function")

								if not arg4.arguments then
									arg4.arguments = {}
								end

								tbl14[arg4.name] = arg4
								table.insert(names, arg4.name)

								v52:newCommand({
									name = arg4.name,
									aliases = arg4.aliases or {},
									description = arg4.description,
									arguments = arg4.arguments or {},
									callback = arg4.callback,
								})
							end
						end,
						cleanup = function()
							v49.cancel(v50)
							v49.cancel(v51)
							v50 = nil
							v51 = nil
							table.clear(tbl14)
							table.clear(names)
							v52 = nil
							v45.CommandBarOpened:set(false)
							v45.CommandBarText:set("")
							v45.ToExecute:set("")
							v45.Suggestions:set({})
						end,
					}
				end)()
			)
		end,
		[157] = function()
			fn23(157)

			return (
				(function()
					local tbl14 = {
						running = "running",
						pending = "pending",
						success = "success",
						error = "error",
						["awaiting input"] = "awaiting input",
					}

					local function fn24(elapsed)
						if elapsed < 60 then
							return string.format("%.1fs", elapsed)
						end
						local elapsed2 = math.floor(elapsed / 60)
						return string.format("%dm %ds", elapsed2, math.floor(elapsed - elapsed2 * 60))
					end

					local function fn25(arg)
						local n = math.max(0, math.floor(arg))
						local n27 = math.floor(n / 86400)
						local n28 = math.floor(n % 86400 / 3600)
						local n29 = math.floor(n % 3600 / 60)
						local n30 = n % 60
						local tbl15 = {}

						if n27 > 0 then
							table.insert(tbl15, string.format("%dd", n27))
						end

						if n >= 3600 then
							table.insert(tbl15, string.format("%dh", n28))
						end

						if n >= 60 then
							table.insert(tbl15, string.format("%dm", n29))
						end

						table.insert(tbl15, string.format("%ds", n30))
						return table.concat(tbl15, " ")
					end

					local function getPhase(arg)
						if #arg.phases == 0 then
							return nil
						end
						return arg.phases[#arg.phases]
					end

					local function fn26(arg)
						local tbl15 = {
							id = arg.nextId,
							kind = "activity",
							final = false,
							tools = {},
							status = "running",
							startedAt = os.clock(),
						}

						arg.nextId += 1
						table.insert(arg.phases, tbl15)
						return tbl15
					end

					local function fn27(phase)
						if phase == nil then
							return false
						end
						return phase.status == "running" and not phase.final and phase.kind == "activity"
					end

					local function fn28(phase)
						if not fn27(phase) then
							return false
						end

						if phase == nil then
							return false
						end
						return #phase.tools == 0
					end

					local function fn29(phase)
						return fn28(phase)
					end

					local function fn30(arg, runId)
						arg.phases = {}
						arg.summary = nil
						arg.runId = runId
						arg.runStartedAt = os.clock()
					end

					local function fn31(arg, text)
						local phase = getPhase(arg)

						if not fn29(phase) then
							phase = fn26(arg)
						end

						if phase.thinking == nil then
							phase.thinking = { title = "Thinking", text = "", status = "running" }
						end

						phase.thinking.text = phase.thinking.text .. text
					end

					local function fn32(arg, title)
						local phase = getPhase(arg)

						if phase and phase.thinking then
							phase.thinking.status = "completed"

							if title and #title > 0 then
								phase.thinking.title = title
							end
						end
					end

					local function fn33(arg, id, name, arguments)
						local phase = getPhase(arg)

						if not fn27(phase) then
							phase = fn26(arg)
						end

						table.insert(phase.tools, { id = id, name = name, status = "running", arguments = arguments })
					end

					local function fn34(arg, id, status, summary)
						local status2 = tbl14[status] or "pending"

						for i = #arg.phases, 1, -1 do
							for _, tool in ipairs(arg.phases[i].tools) do
								if tool.id == id then
									tool.status = status2
									tool.summary = summary
									return
								end
							end
						end
					end

					local function fn35(arg, text)
						local phase = getPhase(arg)

						if not fn28(phase) then
							phase = fn26(arg)
						end

						phase.narration = (phase.narration or "") .. text
					end

					local function fn36(arg, arg2)
						local phase = getPhase(arg)
						if phase == nil then
							return
						end

						if arg2 then
							phase.final = true
							phase.kind = "answer"
						end
					end

					local function fn37(arg)
						local v = 0

						for _, phase in ipairs(arg.phases) do
							phase.status = "completed"
							phase.duration = fn24(os.clock() - phase.startedAt)
							v += #phase.tools
						end

						if arg.runStartedAt then
							local elapsed = os.clock() - arg.runStartedAt

							arg.summary = {
								toolCount = v,
								phaseCount = #arg.phases,
								elapsedSeconds = elapsed,
								duration = fn24(elapsed),
								workedLabel = fn25(elapsed),
							}
						end
					end

					return {
						formatElapsed = fn25,
						new = function()
							return { phases = {}, nextId = 1 }
						end,
						snapshot = function(arg)
							local phases = {}

							for _, phase in ipairs(arg.phases) do
								local tools = {}

								for _, tool in ipairs(phase.tools) do
									table.insert(tools, table.clone(tool))
								end

								local v = table.clone(phase)
								v.tools = tools

								if phase.thinking then
									v.thinking = table.clone(phase.thinking)
								end

								table.insert(phases, v)
							end

							local v = table.clone(arg)
							v.phases = phases

							if arg.summary then
								v.summary = table.clone(arg.summary)
							end

							return v
						end,
						push = function(arg, arg2)
							local kind = arg2.kind

							if kind == "run_start" then
								fn30(arg, arg2.runId)
							elseif kind == "thinking_delta" then
								fn31(arg, arg2.text)
							elseif kind == "thinking_end" then
								fn32(arg, arg2.title)
							elseif kind == "tool_start" then
								fn33(arg, arg2.id, arg2.name, arg2.arguments)
							elseif kind == "tool_result" then
								fn34(arg, arg2.id, arg2.status, arg2.summary)
							elseif kind == "message_delta" then
								fn35(arg, arg2.text)
							elseif kind == "message_end" then
								fn36(arg, arg2.final == true)
							elseif kind == "run_end" then
								fn37(arg)
							end

							return arg
						end,
					}
				end)()
			)
		end,
		[158] = function()
			local v, instance, v43 = fn23(158)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Internal)
					local packages = instance.Parent.Parent.packages
					local v45 = v43(packages.fusion)
					local v46 = v43(packages.states)
					local v47 = v43(instance.Parent.perf)
					local scope = v44.Scope
					local peek = v45.peek

					return function(e, M, x, O)
						local R = O or scope

						O = R:Computed(function(d, p)
							return v47.profile("ui:animateTarget", function()
								return e(d, p)
							end)
						end)

						if not peek(v46.AnimationsEnabled) then
							return O
						end
						return R:Spring(O, M, x)
					end
				end)()
			)
		end,
		[159] = function()
			local v, instance, v43 = fn23(159)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.packages.fusion)
					local v45 = v43(instance.Parent.pendingTasks)
					local peek = v44.peek

					return {
						new = function(e, M)
							local x, O, R = e:Value(peek(M)), false, true

							local function d()
								O = false

								if R then
									x:set(peek(M))
								end
							end

							e:Observer(M):onChange(function()
								if not O then
									O = true
									v45.defer(d)
								end
							end)

							e:insert(function()
								R = false
							end)

							return x
						end,
					}
				end)()
			)
		end,
		[160] = function()
			fn23(160)

			return (
				(function()
					local function fn24(arg)
						return math.clamp(arg, 0, 255)
					end

					return {
						darkenRGB = function(arg, arg2)
							if not arg then
								warn("ColorUtils.darkenRGB received a nil Color. Returning default white.")
								return Color3.new(1, 1, 1)
							end
							return Color3.fromRGB(
								fn24(arg.R * 255 - arg2),
								fn24(arg.G * 255 - arg2),
								fn24(arg.B * 255 - arg2)
							)
						end,
						lightenRGB = function(arg, arg2)
							if not arg then
								warn("ColorUtils.lightenRGB received a nil Color. Returning default white.")
								return Color3.new(1, 1, 1)
							end
							return Color3.fromRGB(
								fn24(arg.R * 255 + arg2),
								fn24(arg.G * 255 + arg2),
								fn24(arg.B * 255 + arg2)
							)
						end,
						getColorInSequence = function(arg, arg2)
							local keypoints = arg.Keypoints
							local n = math.floor(arg2 * (#keypoints - 1)) + 1
							local n27 = math.min(n + 1, #keypoints)
							local keypoint = keypoints[n] or keypoints[1]
							return keypoint.Value:Lerp(
								(keypoints[n27] or keypoint).Value,
								arg2 * (#keypoints - 1) - (n - 1)
							)
						end,
					}
				end)()
			)
		end,
		[161] = function()
			local v, v43, v44 = fn23(161)

			return (
				(function()
					local v45 = v44(v43.contrast)
					local n = #"ColorSpace:"
					local n27 = #"ColorSpaceConstr:"
					local function fn24(g)
						return g
					end
					local function fn25(g)
						if g <= 0.04045 then
							return g / 12.92
						else
							return ((g + 0.055) / 1.055) ^ 2.4
						end
					end
					local function fn26(g)
						if g <= 0.0031308 then
							return g * 12.92
						else
							return 1.055 * g ^ 0.4166666666666667 - 0.055
						end
					end
					local n28 = 0.5
					local n29 = 12
					local index = { kind = fn24("ColorSpaceConstr:Srgb") }
					index.__index = index

					index.new = function(e, M, x)
						return setmetatable({ red = e, green = M, blue = x, kind = fn24("ColorSpace:Srgb") }, index)
					end

					local index2 = { kind = fn24("ColorSpaceConstr:LinearRgb") }
					index2.__index = index2

					index2.new = function(e, M, x)
						return setmetatable(
							{ red = e, green = M, blue = x, kind = fn24("ColorSpace:LinearRgb") },
							index2
						)
					end

					local index3 = { kind = fn24("ColorSpaceConstr:Xyz") }
					index3.__index = index3

					index3.new = function(e, M, x)
						return setmetatable({ x = e, y = M, z = x, kind = fn24("ColorSpace:Xyz") }, index3)
					end

					local index4 = { kind = fn24("ColorSpaceConstr:Oklab") }
					index4.__index = index4

					index4.new = function(e, M, x)
						return setmetatable({ lightness = e, a = M, b = x, kind = fn24("ColorSpace:Oklab") }, index4)
					end

					local index5 = { kind = fn24("ColorSpaceConstr:Oklch") }
					index5.__index = index5

					index5.new = function(e, M, x)
						return setmetatable(
							{ lightness = e, chroma = M, hue = x, kind = fn24("ColorSpace:Oklch") },
							index5
						)
					end

					index.ToLinearRgb = function(e)
						return index2.new(fn25(e.red), fn25(e.green), fn25(e.blue))
					end

					index2.ToSrgb = function(e)
						return index.new(
							math.clamp(fn26(e.red), 0, 1),
							math.clamp(fn26(e.green), 0, 1),
							math.clamp(fn26(e.blue), 0, 1)
						)
					end

					index2.ToXyz = function(e)
						local M = e.red
						local x = e.green
						local O = e.blue
						return index3.new(
							((0.4124564 * M) + (0.3575761 * x)) + (0.1804375 * O),
							((0.2126729 * M) + (0.7151522 * x)) + (0.072175 * O),
							((0.0193339 * M) + (0.119192 * x)) + (0.9503041 * O)
						)
					end

					index3.ToLinearRgb = function(e)
						return index2.new(
							((3.2404542 * e.x) - (1.5371385 * e.y)) - (0.4985314 * e.z),
							((-0.969266 * e.x) + (1.8760108 * e.y)) + (0.041556 * e.z),
							((0.0556434 * e.x) - (0.2040259 * e.y)) + (1.0572252 * e.z)
						)
					end

					index2.ToOklab = function(e)
						local M, x, O = e.red, e.green, e.blue
						local e = (((0.4122214708 * M) + (0.5363325363 * x)) + (0.0514459929 * O)) ^ 0.3333333333333333
						local R = (((0.2119034982 * M) + (0.6806995451 * x)) + (0.1073969566 * O)) ^ 0.3333333333333333
						local d = (((0.0883024619 * M) + (0.2817188376 * x)) + (0.6299787005 * O)) ^ 0.3333333333333333
						return index4.new(
							((0.2104542553 * e) + (0.793617785 * R)) - (0.0040720468 * d),
							((1.9779984951 * e) - (2.428592205 * R)) + (0.4505937099 * d),
							((0.0259040371 * e) + (0.7827717662 * R)) - (0.808675766 * d)
						)
					end

					index4.ToLinearRgb = function(e)
						local M = ((e.lightness + (0.3963377774 * e.a)) + (0.2158037573 * e.b)) ^ 3
						local x = ((e.lightness - (0.1055613458 * e.a)) - (0.0638541728 * e.b)) ^ 3
						local O = ((e.lightness - (0.0894841775 * e.a)) - (1.291485548 * e.b)) ^ 3
						return index2.new(
							((4.0767416621 * M) - (3.3077115913 * x)) + (0.2309699292 * O),
							((-1.2684380046 * M) + (2.6097574011 * x)) - (0.3413193965 * O),
							((-0.0041960863 * M) - (0.7034186147 * x)) + (1.707614701 * O)
						)
					end

					index4.ToOklch = function(e)
						return index5.new(e.lightness, math.sqrt((e.a ^ 2) + (e.b ^ 2)), math.atan2(e.b, e.a))
					end

					index5.ToOklab = function(e)
						return index4.new(e.lightness, e.chroma * math.cos(e.hue), e.chroma * math.sin(e.hue))
					end

					index.ToXyz = function(g)
						return g:ToLinearRgb():ToXyz()
					end
					index.ToOklab = function(g)
						return g:ToLinearRgb():ToOklab()
					end
					index.ToOklch = function(g)
						return g:ToLinearRgb():ToOklab():ToOklch()
					end
					index2.ToOklch = function(g)
						return g:ToOklab():ToOklch()
					end
					index3.ToSrgb = function(g)
						return g:ToLinearRgb():ToSrgb()
					end
					index3.ToOklab = function(g)
						return g:ToLinearRgb():ToOklab()
					end
					index3.ToOklch = function(g)
						return g:ToLinearRgb():ToOklab():ToOklch()
					end
					index4.ToSrgb = function(g)
						return g:ToLinearRgb():ToSrgb()
					end
					index4.ToXyz = function(g)
						return g:ToLinearRgb():ToXyz()
					end
					index5.ToLinearRgb = function(g)
						return g:ToOklab():ToLinearRgb()
					end
					index5.ToSrgb = function(g)
						return g:ToOklab():ToLinearRgb():ToSrgb()
					end
					index5.ToXyz = function(g)
						return g:ToOklab():ToLinearRgb():ToXyz()
					end

					index.Lerp = function(e, M, x)
						return index.new(
							e.red + ((M.red - e.red) * x),
							e.green + ((M.green - e.green) * x),
							e.blue + ((M.blue - e.blue) * x)
						)
					end

					index2.Lerp = function(e, M, x)
						return index2.new(
							e.red + ((M.red - e.red) * x),
							e.green + ((M.green - e.green) * x),
							e.blue + ((M.blue - e.blue) * x)
						)
					end

					index3.Lerp = function(e, M, x)
						return index3.new(e.x + ((M.x - e.x) * x), e.y + ((M.y - e.y) * x), e.z + ((M.z - e.z) * x))
					end

					index4.Lerp = function(e, M, x)
						return index4.new(
							e.lightness + ((M.lightness - e.lightness) * x),
							e.a + ((M.a - e.a) * x),
							e.b + ((M.b - e.b) * x)
						)
					end

					index5.Lerp = function(e, M, x)
						local O = (M.hue - e.hue) % 6.283185307179586
						return index5.new(
							e.lightness + ((M.lightness - e.lightness) * x),
							e.chroma + ((M.chroma - e.chroma) * x),
							e.hue + ((if O > 3.141592653589793 then O - 6.283185307179586 else O) * x)
						)
					end

					index.Components = function(g)
						return g.red, g.green, g.blue
					end
					index2.Components = function(g)
						return g.red, g.green, g.blue
					end
					index3.Components = function(g)
						return g.x, g.y, g.z
					end
					index4.Components = function(g)
						return g.lightness, g.a, g.b
					end
					index5.Components = function(g)
						return g.lightness, g.chroma, g.hue
					end
					index.ToColor3 = function(g)
						return Color3.new(g.red, g.green, g.blue)
					end
					index2.ToColor3 = function(g)
						return g:ToSrgb():ToColor3()
					end
					index3.ToColor3 = function(g)
						return g:ToSrgb():ToColor3()
					end
					index4.ToColor3 = function(g)
						return g:ToSrgb():ToColor3()
					end
					index5.ToColor3 = function(g)
						return g:ToSrgb():ToColor3()
					end
					index.ToHexString = function(g)
						return string.format(
							"#%02X%02X%02X",
							math.round(g.red * 255),
							math.round(g.green * 255),
							math.round(g.blue * 255)
						)
					end
					index2.ToHexString = function(g)
						return g:ToSrgb():ToHexString()
					end
					index3.ToHexString = function(g)
						return g:ToSrgb():ToHexString()
					end
					index4.ToHexString = function(g)
						return g:ToSrgb():ToHexString()
					end
					index5.ToHexString = function(g)
						return g:ToSrgb():ToHexString()
					end

					index4.IsDark = function(e)
						return e.lightness <= n28
					end

					index4.IsLight = function(g)
						return not g:IsDark()
					end
					index.IsDark = function(g)
						return g:ToOklab():IsDark()
					end
					index.IsLight = function(g)
						return not g:IsDark()
					end
					index2.IsDark = function(g)
						return g:ToOklab():IsDark()
					end
					index2.IsLight = function(g)
						return not g:IsDark()
					end
					index3.IsDark = function(g)
						return g:ToOklab():IsDark()
					end
					index3.IsLight = function(g)
						return not g:IsDark()
					end
					index5.IsDark = function(g)
						return g:ToOklab():IsDark()
					end
					index5.IsLight = function(g)
						return not g:IsDark()
					end

					local function fn27(e, M)
						local x = if typeof(e) == "Color3" then "Color3" else (string.sub(e.kind, n + 1))
						local O = if M == "Color3" then "Color3" else (string.sub(M.kind, n27 + 1))
						if x == O then
							return e
						end
						M = nil

						if x == "Color3" then
							M = index.new(e.R, e.G, e.B)
							if O == "Srgb" then
								return M
							end
						else
							M = e
						end

						if O == "Color3" then
							return M:ToColor3()
						end
						return M["To" .. O](M)
					end

					index.From = function(e)
						return (fn27(e, index))
					end

					index2.From = function(e)
						return (fn27(e, index2))
					end

					index3.From = function(e)
						return (fn27(e, index3))
					end

					index4.From = function(e)
						return (fn27(e, index4))
					end

					index5.From = function(e)
						return (fn27(e, index5))
					end

					local function fn28(e)
						local M, x, O = index2.From(e):Components()
						return (((((M >= 0) and (M <= 1)) and (x >= 0)) and (x <= 1)) and (O >= 0)) and (O <= 1)
					end

					local function fn29(e)
						local M, x, O = index5.From(e):Components()
						M, x = math.clamp(M, 0, 1), math.max(x, 0)
						e = index5.new(M, x, O)
						if fn28(e) then
							return e:ToColor3()
						end
						local e = 0
						local R = x
						local x = 0

						for d = 1, n29, 1 do
							d = (e + R) / 2

							if fn28((index5.new(M, d, O))) then
								e, x = d, d
							else
								R = d
							end
						end

						return index5.new(M, x, O):ToColor3()
					end

					local function fn30(e)
						local M = index2.From(e)
						return v45.RelativeLuminance(M.red, M.green, M.blue)
					end

					local function fn31(e, M)
						return v45.Check(fn30(e), fn30(M))
					end

					local function fn32(e, M, ...)
						local x = { ... }
						local O, R = fn31(e, M).ratio, M

						for M, d in x, nil, nil do
							M = fn31(e, d).ratio

							if M > O then
								O, R = M, d
							end
						end

						return R
					end

					index.CheckContrast = function(e, M)
						return fn31(e, M)
					end

					index2.CheckContrast = function(e, M)
						return fn31(e, M)
					end

					index3.CheckContrast = function(e, M)
						return fn31(e, M)
					end

					index4.CheckContrast = function(e, M)
						return fn31(e, M)
					end

					index5.CheckContrast = function(e, M)
						return fn31(e, M)
					end

					index.BestContrast = function(e, M, ...)
						return fn32(e, M, ...)
					end

					index2.BestContrast = function(e, M, ...)
						return fn32(e, M, ...)
					end

					index3.BestContrast = function(e, M, ...)
						return fn32(e, M, ...)
					end

					index4.BestContrast = function(e, M, ...)
						return fn32(e, M, ...)
					end

					index5.BestContrast = function(e, M, ...)
						return fn32(e, M, ...)
					end

					return {
						Srgb = index,
						LinearRgb = index2,
						Xyz = index3,
						Oklab = index4,
						Oklch = index5,
						ToGamutMappedColor3 = fn29,
					}
				end)()
			)
		end,
		[162] = function()
			fn23(162)

			return (
				(function()
					local n = 4.5
					local n27 = 7
					local n28 = 3
					local n29 = 4.5
					local n30 = 3

					return {
						RelativeLuminance = function(g, e, M)
							return 0.2126 * g + 0.7152 * e + 0.0722 * M
						end,
						Check = function(e, M)
							local x, O = math.max(e, M), math.min(e, M)
							local e = (x + 0.05) / (O + 0.05)
							return {
								ratio = e,
								normalTextAA = e >= n,
								normalTextAAA = e >= n27,
								largeTextAA = e >= n28,
								largeTextAAA = e >= n29,
								uiAA = e >= n30,
							}
						end,
					}
				end)()
			)
		end,
		[163] = function()
			local v, instance, v43 = fn23(163)

			return (
				(function()
					local v44 = v43(instance.Parent.targetResolver)
					local v45 = v43(instance.Parent.toolError)

					local tbl14 = {
						window = nil,
						categories = {},
						tabs = {},
						sections = {},
						options = {},
						controlsById = {},
						controlsByOptionKey = {},
						controlOrder = {},
						nextId = 0,
						changeListeners = {},
						nextChangeListenerId = 0,
					}

					local function fn24(arg)
						if type(arg) ~= "string" then
							return ""
						end
						return string.match(arg, "^%s*(.-)%s*$") or ""
					end

					local function fn25(arg)
						return string.lower(fn24(arg))
					end

					local function fn26(title)
						local v46 =
							string.gsub(string.gsub(string.gsub(fn25(title), "[^%w]+", "_"), "^_+", ""), "_+$", "")
						if v46 == "" then
							return "item"
						end
						return v46
					end

					local function fn27(arg, title)
						tbl14.nextId += 1
						return string.format("%s_%s_%04d", arg, fn26(title), tbl14.nextId)
					end

					local function fn28(optionKey, title, type_)
						local v46 = fn24(optionKey)
						if v46 ~= "" and tbl14.controlsById[v46] == nil then
							return v46
						end
						return fn27("control", v46 ~= "" and v46 or title or type_ or "control")
					end

					local function fn29(...)
						local v46 = table.pack(...)
						local tbl15 = {}

						for i = 1, v46.n do
							local v47 = fn24(v46[i])

							if v47 ~= "" then
								table.insert(tbl15, v47)
							end
						end

						return tbl15
					end

					local function fn30(arg, arg2, arg3)
						local kind = typeof(arg)
						arg2 = arg2 or 0
						arg3 = arg3 or {}
						if kind == "nil" or kind == "string" or kind == "number" or kind == "boolean" then
							return arg
						end

						if kind == "Color3" then
							return {
								type = "Color3",
								r = math.round(arg.R * 255),
								g = math.round(arg.G * 255),
								b = math.round(arg.B * 255),
							}
						end

						if kind == "EnumItem" then
							return tostring(arg)
						end

						if kind == "table" then
							if arg3[arg] then
								return "<cycle>"
							end

							if arg2 >= 5 then
								return "<max-depth>"
							end
							arg3[arg] = true
							local count5 = 0
							local flag19 = true

							for k in arg do
								count5 += 1

								if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
									flag19 = false
								end
							end

							local tbl15

							if flag19 then
								tbl15 = table.create(count5)
							else
								tbl15 = {}
							end

							if flag19 then
								for i = 1, count5 do
									tbl15[i] = fn30(arg[i], arg2 + 1, arg3)
								end
							else
								for k, v46 in arg do
									tbl15[tostring(k)] = fn30(v46, arg2 + 1, arg3)
								end
							end

							arg3[arg] = nil
							return tbl15
						end

						return tostring(arg)
					end

					local function fn31(arg, arg2)
						if type(arg) ~= "table" then
							return arg
						end
						arg2 = arg2 or {}
						if arg2[arg] then
							return arg2[arg]
						end
						local tbl15 = {}
						arg2[arg] = tbl15

						for k, v46 in arg do
							tbl15[fn31(k, arg2)] = fn31(v46, arg2)
						end

						return tbl15
					end

					local function fn32(arg)
						if type(arg.getChoices) ~= "function" then
							return nil
						end
						local ok, result = pcall(arg.getChoices)

						do
							if not ok or type(result) ~= "table" then
								return nil
							end
							local tbl15 = {}

							for _, v46 in ipairs(result) do
								table.insert(tbl15, tostring(v46))
							end

							if not (#tbl15 > 0) then
								tbl15 = nil
							end

							return tbl15
						end

						while true do
						end
					end

					local function fn33(arg, arg2)
						local tbl15 = {
							id = arg.id,
							optionKey = arg.optionKey,
							type = arg.type,
							title = arg.title,
							description = arg.description,
							path = arg.path,
							windowTitle = arg.windowTitle,
							categoryTitle = arg.categoryTitle,
							tabTitle = arg.tabTitle,
							sectionTitle = arg.sectionTitle,
							sectionKind = arg.sectionKind,
							side = arg.side,
							style = arg.style,
							multi = arg.multi == true or nil,
							defaultValue = fn30(arg.defaultValue),
							minimum = arg.minimum,
							maximum = arg.maximum,
							step = arg.step,
							writable = arg.writable,
							triggerable = arg.triggerable,
							risk = arg.risk,
						}

						local choices = fn32(arg)

						if choices then
							tbl15.choices = choices
						end

						if arg2 and type(arg.getValue) == "function" then
							local ok, result = pcall(arg.getValue)

							if ok then
								tbl15.currentValue = fn30(result)
							end
						end

						return tbl15
					end

					local function getMatches(query)
						local matches = {}

						for match in string.gmatch(fn25(query), "[%w_]+") do
							table.insert(matches, match)
						end

						return matches
					end

					local function fn34(arg, query)
						local v46 = fn25(query)
						local v47 = fn25(arg.title)
						local v48 = fn25(arg.description)
						local v49 = fn25(arg.optionKey)
						local v50 = fn25(arg.path)
						local v51 = 0
						if v46 == "" then
							return 1
						end

						if v47 == v46 then
							v51 += 120
						end

						if v49 ~= "" and v49 == v46 then
							v51 += 110
						end

						if arg.id == query then
							v51 += 140
						end

						if string.find(v47, v46, 1, true) then
							v51 += 75
						end

						if string.find(v49, v46, 1, true) then
							v51 += 70
						end

						if string.find(v50, v46, 1, true) then
							v51 += 35
						end

						if string.find(v48, v46, 1, true) then
							v51 += 30
						end

						for _, match in ipairs(getMatches(query)) do
							if string.find(v47, match, 1, true) then
								v51 += 22
							end

							if string.find(v49, match, 1, true) then
								v51 += 20
							end

							if string.find(v48, match, 1, true) then
								v51 += 10
							end

							if string.find(v50, match, 1, true) then
								v51 += 6
							end

							if fn25(arg.type) == match then
								v51 += 18
							end
						end

						return v51
					end

					local function fn35(arg, arg2)
						if type(arg2) ~= "table" then
							return true
						end
						local type_ = arg2.type or arg2.controlType
						if type(type_) == "string" and type_ ~= "" and fn25(arg.type) ~= fn25(type_) then
							return false
						end
						local categoryTitle = arg2.categoryTitle
						if
							type(categoryTitle) == "string"
							and categoryTitle ~= ""
							and fn25(arg.categoryTitle) ~= fn25(categoryTitle)
						then
							return false
						end
						local tabTitle = arg2.tabTitle
						if type(tabTitle) == "string" and tabTitle ~= "" and fn25(arg.tabTitle) ~= fn25(tabTitle) then
							return false
						end
						local sectionTitle = arg2.sectionTitle
						if
							type(sectionTitle) == "string"
							and sectionTitle ~= ""
							and fn25(arg.sectionTitle) ~= fn25(sectionTitle)
						then
							return false
						end
						return true
					end

					local function fn36(arg)
						local tbl15 = {}

						for _, v46 in ipairs(tbl14.controlOrder) do
							table.insert(tbl15, {
								value = v46,
								id = v46.id,
								aliases = fn29(v46.optionKey),
								name = v46.title,
								path = v46.path,
							})
						end

						local v46, v47 = v44.resolve(
							arg,
							{ kind = "control", entries = tbl15, direct = tbl14.controlsById, allowPartial = true }
						)

						if v46 == nil then
							v45.throw(v47.code, v47.message, { details = v47.details })
						end

						return v46
					end

					local function fn37(arg, arg2)
						v45.throw("INVALID_CONTROL_VALUE", arg, { details = arg2 })
					end

					local function fn38(arg)
						if type(arg) == "boolean" then
							return arg
						end

						if type(arg) == "number" then
							return arg ~= 0
						end

						if type(arg) == "string" then
							local v46 = fn25(arg)
							if v46 == "true" or v46 == "on" or v46 == "enabled" or v46 == "enable" or v46 == "1" then
								return true
							end

							if
								v46 == "false"
								or v46 == "off"
								or v46 == "disabled"
								or v46 == "disable"
								or v46 == "0"
							then
								return false
							end
						end

						fn37("Value could not be converted to a boolean.")
					end

					local function fn39(arg)
						if typeof(arg) == "Color3" then
							return arg
						end

						if type(arg) ~= "string" then
							fn37("Color value must be a string like '#ff0000' or '255,0,0'.")
						end

						local v46 = string.match(fn24(arg), "^#?(%x%x%x%x%x%x)$")

						if v46 then
							local num = tonumber(string.sub(v46, 1, 2), 16)
							local num2 = tonumber(string.sub(v46, 3, 4), 16)
							local num3 = tonumber(string.sub(v46, 5, 6), 16)
							return Color3.fromRGB(num, num2, num3)
						end

						local v47, v48, v49 = string.match(arg, "^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$")
						if v47 and v48 and v49 then
							return Color3.fromRGB(tonumber(v47), tonumber(v48), tonumber(v49))
						end
						fn37("Color value must be '#RRGGBB' or 'R,G,B'.")
					end

					local tbl15

					tbl15 = {
						reset = function()
							tbl14.window = nil
							tbl14.categories = {}
							tbl14.tabs = {}
							tbl14.sections = {}
							tbl14.controlsById = {}
							tbl14.controlsByOptionKey = {}
							tbl14.controlOrder = {}
							tbl14.nextId = 0
							tbl14.changeListeners = {}
							tbl14.nextChangeListenerId = 0

							for k in pairs(tbl14.options) do
								tbl14.options[k] = nil
							end
						end,
						onControlChanged = function(arg)
							assert(type(arg) == "function", "control change listener must be a function")
							tbl14.nextChangeListenerId += 1
							local nextChangeListenerId = tbl14.nextChangeListenerId
							tbl14.changeListeners[nextChangeListenerId] = arg

							return function()
								tbl14.changeListeners[nextChangeListenerId] = nil
							end
						end,
						notifyControlChanged = function(arg)
							for _, changeListener in pairs(tbl14.changeListeners) do
								local ok, result = pcall(changeListener, arg)

								if not ok then
									warn("control change listener failed: " .. tostring(result))
								end
							end
						end,
						registerWindow = function(arg)
							tbl15.reset()
							tbl14.window = {
								id = fn27("window", arg.title or "window"),
								title = arg.title or "Window",
								tag = arg.tag,
							}
							return tbl14.window
						end,
						registerCategory = function(arg)
							local tbl16 = {
								id = fn27("category", arg.title or "category"),
								title = arg.title or "Category",
								order = arg.order or 0,
								windowId = arg.windowId,
								windowTitle = arg.windowTitle or tbl14.window and tbl14.window.title or "",
							}

							tbl14.categories[tbl16.id] = tbl16
							return tbl16
						end,
						registerTab = function(arg)
							local tbl16 = {
								id = fn27("tab", arg.title or "tab"),
								title = arg.title or "Tab",
								order = arg.order or 0,
								windowId = arg.windowId,
								windowTitle = arg.windowTitle or tbl14.window and tbl14.window.title or "",
								categoryId = arg.categoryId,
								categoryTitle = arg.categoryTitle or "",
							}

							tbl14.tabs[tbl16.id] = tbl16
							return tbl16
						end,
						registerSection = function(arg)
							local tbl16 = {
								id = fn27("section", arg.title or "section"),
								title = arg.title or "Section",
								order = arg.order or 0,
								kind = arg.kind or "tab",
								side = arg.side,
								windowId = arg.windowId,
								windowTitle = arg.windowTitle or tbl14.window and tbl14.window.title or "",
								categoryId = arg.categoryId,
								categoryTitle = arg.categoryTitle or "",
								tabId = arg.tabId,
								tabTitle = arg.tabTitle or "",
							}

							tbl14.sections[tbl16.id] = tbl16
							return tbl16
						end,
						registerControl = function(arg)
							local context = type(arg.context) == "table" and arg.context or {}
							local optionKey = arg.optionKey

							if optionKey ~= nil and optionKey ~= "" and tbl14.controlsByOptionKey[optionKey] ~= nil then
								error(("Control optionKey '%s' is already registered."):format(tostring(optionKey)), 2)
							end

							local title = arg.title or optionKey or "Untitled"
							local v46 = fn29(
								context.windowTitle,
								context.categoryTitle,
								context.tabTitle,
								context.sectionTitle,
								title
							)

							local tbl16 = {
								id = fn28(optionKey, title, arg.type),
								optionKey = optionKey or "",
								type = arg.type or "Unknown",
								title = title,
								description = arg.description or "",
								windowTitle = context.windowTitle or "",
								categoryTitle = context.categoryTitle or "",
								tabTitle = context.tabTitle or "",
								sectionTitle = context.sectionTitle or "",
								sectionKind = context.sectionKind,
								side = context.side,
								style = arg.style,
								multi = arg.multi == true,
								path = table.concat(v46, " > "),
								defaultValue = arg.defaultValue,
								minimum = arg.minimum,
								maximum = arg.maximum,
								step = arg.step,
								risk = arg.risk,
								getValue = arg.getValue,
								setValue = arg.setValue,
								getChoices = arg.getChoices,
								trigger = arg.trigger,
								raw = arg.element,
							}

							local writable

							if arg.writable ~= nil then
								writable = arg.writable == true
							else
								writable = type(tbl16.setValue) == "function"
							end

							tbl16.writable = writable
							tbl16.triggerable = type(tbl16.trigger) == "function"
							tbl14.controlsById[tbl16.id] = tbl16

							if tbl16.optionKey ~= "" then
								tbl14.controlsByOptionKey[tbl16.optionKey] = tbl16
							end

							table.insert(tbl14.controlOrder, tbl16)

							if optionKey ~= nil then
								tbl14.options[optionKey] = arg.element
							end

							return tbl16
						end,
						unregisterControl = function(arg)
							if arg == nil then
								return
							end
							local v46 = tbl14.controlsByOptionKey[arg]

							if v46 then
								tbl14.controlsById[v46.id] = nil

								for i, v47 in ipairs(tbl14.controlOrder) do
									if v47 == v46 then
										table.remove(tbl14.controlOrder, i)
										break
									end
								end

								tbl14.controlsByOptionKey[arg] = nil
							end

							tbl14.options[arg] = nil
						end,
						getOptions = function()
							return tbl14.options
						end,
						getSummary = function()
							local categories = {}

							for _, category in pairs(tbl14.categories) do
								table.insert(
									categories,
									{ id = category.id, title = category.title, order = category.order }
								)
							end

							table.sort(categories, function(arg, arg2)
								do
									return arg.order < arg2.order
								end

								while true do
								end
							end)

							local tabs = {}

							for _, tab in pairs(tbl14.tabs) do
								table.insert(
									tabs,
									{
										id = tab.id,
										title = tab.title,
										categoryTitle = tab.categoryTitle,
										order = tab.order,
									}
								)
							end

							table.sort(tabs, function(arg, arg2)
								if arg.categoryTitle == arg2.categoryTitle then
									return arg.order < arg2.order
								end
								return arg.categoryTitle < arg2.categoryTitle
							end)

							local controlTypeCounts = {}

							for _, v46 in ipairs(tbl14.controlOrder) do
								controlTypeCounts[v46.type] = (controlTypeCounts[v46.type] or 0) + 1
							end

							local tbl16 = {
								window = tbl14.window
										and { id = tbl14.window.id, title = tbl14.window.title, tag = tbl14.window.tag }
									or nil,
							}

							local function getCount()
								local count5 = 0

								for k in pairs(tbl14.sections) do
									count5 += 1
								end

								return count5
							end

							tbl16.counts = {
								categories = #categories,
								tabs = #tabs,
								sections = getCount(),
								controls = #tbl14.controlOrder,
							}
							tbl16.controlTypeCounts = controlTypeCounts
							tbl16.categories = categories
							tbl16.tabs = tabs
							return tbl16
						end,
						listControls = function(arg)
							if type(arg) ~= "table" then
								arg = {}
							end

							local flag19 = arg.includeValues == true or arg.include_values == true
							local n = math.max(0, math.floor(tonumber(arg.offset) or 0))
							local n27 = math.clamp(math.floor(tonumber(arg.limit) or 100), 1, 250)
							local tbl16 = {}

							for _, v46 in ipairs(tbl14.controlOrder) do
								if fn35(v46, arg) then
									table.insert(tbl16, v46)
								end
							end

							local tbl17 = {}
							local n28 = n + 1
							local n29 = math.min(#tbl16, n28 + n27 - 1)

							for i = n28, n29 do
								table.insert(tbl17, fn33(tbl16[i], flag19))
							end

							return {
								count = #tbl17,
								totalCount = #tbl16,
								offset = n,
								hasMore = n29 < #tbl16,
								controls = tbl17,
							}
						end,
						searchControls = function(arg)
							if type(arg) ~= "table" then
								arg = {}
							end

							local query = arg.query or arg.text or ""
							local flag19 = arg.includeValues == true or arg.include_values == true
							local n = math.clamp(math.floor(tonumber(arg.limit) or 25), 1, 100)
							local tbl16 = {}

							for _, v46 in ipairs(tbl14.controlOrder) do
								if fn35(v46, arg) then
									local v47 = fn34(v46, query)

									if v47 > 0 then
										table.insert(tbl16, { score = v47, entry = v46 })
									end
								end
							end

							table.sort(tbl16, function(arg2, arg3)
								if arg2.score == arg3.score then
									return arg2.entry.path < arg3.entry.path
								end
								return arg2.score > arg3.score
							end)

							local tbl17 = {}

							for i = 1, math.min(#tbl16, n) do
								local v46 = fn33(tbl16[i].entry, flag19)
								v46.score = tbl16[i].score
								table.insert(tbl17, v46)
							end

							return { query = query, count = #tbl17, results = tbl17 }
						end,
						inspectControl = function(arg)
							return fn33(fn36(arg), true)
						end,
					}

					local function fn40(arg, arg2)
						local v46 = tonumber

						if type(arg2) == "string" then
							arg2 = fn24(arg2)
						end

						local v47 = v46(arg2)

						if v47 == nil or v47 ~= v47 then
							fn37(("Slider '%s' expects a number."):format(arg.title))
						end

						if arg.minimum ~= nil and v47 < arg.minimum then
							fn37(
								("Slider '%s' minimum is %s, got %s."):format(
									arg.title,
									tostring(arg.minimum),
									tostring(v47)
								)
							)
						end

						if arg.maximum ~= nil and v47 > arg.maximum then
							fn37(
								("Slider '%s' maximum is %s, got %s."):format(
									arg.title,
									tostring(arg.maximum),
									tostring(v47)
								)
							)
						end

						return v47
					end

					local function fn41(arg, arg2)
						local v46 = fn32(arg)

						if arg.multi then
							if type(arg2) ~= "table" then
								fn37(("Dropdown '%s' expects an array of choices."):format(arg.title))
							end

							local tbl16 = {}

							for i, v47 in ipairs(arg2) do
								local str7 = tostring(v47)

								if v46 and not table.find(v46, str7) then
									fn37(
										("Dropdown '%s' has no choice '%s'. Allowed: %s."):format(
											arg.title,
											str7,
											table.concat(v46, ", ")
										)
									)
								end

								tbl16[i] = str7
							end

							return tbl16
						end

						if type(arg2) == "table" then
							fn37(("Dropdown '%s' expects a single choice string."):format(arg.title))
						end

						local str7 = tostring(arg2)

						if v46 and not table.find(v46, str7) then
							fn37(
								("Dropdown '%s' has no choice '%s'. Allowed: %s."):format(
									arg.title,
									str7,
									table.concat(v46, ", ")
								)
							)
						end

						return str7
					end

					local function fn42(arg, arg2)
						if type(arg2) == "string" then
							return { key = fn24(arg2), mode = nil }
						end

						if type(arg2) ~= "table" then
							fn37(
								("Keybind '%s' expects a string key or a table with 'key' and optional 'mode'."):format(
									arg.title
								)
							)
						end

						if type(arg2.key) ~= "string" or fn24(arg2.key) == "" then
							fn37(("Keybind '%s' requires a non-empty string 'key'."):format(arg.title))
						end

						if arg2.mode ~= nil and type(arg2.mode) ~= "string" then
							fn37(("Keybind '%s' mode must be a string."):format(arg.title))
						end

						return { key = fn24(arg2.key), mode = arg2.mode }
					end

					local function fn43(arg, arg2)
						if arg2 == nil then
							fn37("Missing required control value.")
						end

						local v46 = fn25(arg.type)
						if v46 == "toggle" then
							return fn38(arg2)
						end

						if v46 == "slider" then
							return fn40(arg, arg2)
						end

						if v46 == "input" then
							if type(arg2) == "table" then
								fn37(("Input '%s' expects a text value."):format(arg.title))
							end

							return tostring(arg2)
						end

						if v46 == "colorpicker" then
							if typeof(arg2) == "Color3" then
								return arg2
							end
							return fn39(arg2)
						end

						if v46 == "dropdown" then
							return fn41(arg, arg2)
						end

						if v46 == "keybind" then
							return fn42(arg, arg2)
						end

						if type(arg2) == "table" then
							fn37(("Control '%s' does not accept structured values."):format(arg.title))
						end

						return arg2
					end

					tbl15.validateControlValue = function(arg, arg2)
						return fn43(fn36(arg), arg2)
					end

					tbl15.setControlValue = function(arg, arg2)
						local v46 = fn36(arg)

						if type(v46.setValue) ~= "function" then
							v45.throw("CONTROL_READ_ONLY", ("Control '%s' cannot be set."):format(v46.title))
						end

						if type(arg2) == "table" then
							arg2 = arg2.value
						end

						v46.setValue(fn43(v46, arg2))
						return fn33(v46, true)
					end

					local function fn44(arg, arg2)
						local function fn45()
							local ok, result = pcall(fn36, arg.target)
							if not ok then
								return nil, result
							end
							return result, nil
						end

						local v46, v47 = fn45()

						if v46 == nil then
							v45.throw(
								v47.code,
								("changes[%d]: %s"):format(arg2, v47.message),
								{ details = v47.details }
							)
						end

						if type(v46.setValue) ~= "function" then
							v45.throw(
								"CONTROL_READ_ONLY",
								("changes[%d]: Control '%s' cannot be set."):format(arg2, v46.title)
							)
						end

						local ok, result = pcall(fn43, v46, arg.value)

						if not ok then
							v45.throw(
								result.code or "INVALID_CONTROL_VALUE",
								("changes[%d]: %s"):format(arg2, result.message or tostring(result)),
								{ details = result.details }
							)
						end

						return v46, result
					end

					local function fn45(entry, arg)
						if type(entry.getValue) ~= "function" then
							v45.throw(
								"CONTROL_ROLLBACK_UNAVAILABLE",
								("changes[%d]: Control '%s' cannot participate in an atomic batch because its current value is unavailable."):format(
									arg,
									entry.title
								)
							)
						end

						local ok, result = pcall(entry.getValue)

						if not ok then
							local v46 = v45.sanitize(result)
							v45.throw(
								"CONTROL_ROLLBACK_UNAVAILABLE",
								("changes[%d]: Could not capture the current value of control '%s': %s"):format(
									arg,
									entry.title,
									v46.message
								),
								{ details = { cause = v46 } }
							)
						end

						return fn31(result)
					end

					local function fn46(arg, arg2)
						local tbl16 = {}
						local tbl17 = {}

						for i = arg2, 1, -1 do
							local v46 = arg[i]

							if not tbl17[v46.entry] then
								tbl17[v46.entry] = true
								local ok, result = pcall(v46.entry.setValue, v46.originalValue)

								if not ok then
									local v47 = v45.sanitize(result)
									table.insert(
										tbl16,
										{ index = i, target = v46.entry.id, code = v47.code, message = v47.message }
									)
								end
							end
						end

						return tbl16
					end

					tbl15.batchSetControlValues = function(arg)
						if type(arg) ~= "table" or #arg == 0 then
							v45.throw(
								"INVALID_BATCH_INPUT",
								"changes must be a non-empty array of { target, value } objects."
							)
						end

						for i, v46 in ipairs(arg) do
							if type(v46) ~= "table" or type(v46.target) ~= "string" or fn24(v46.target) == "" then
								v45.throw(
									"INVALID_BATCH_INPUT",
									("changes[%d] must include a non-empty string target."):format(i)
								)
							end
						end

						local tbl16 = {}

						for i, v46 in ipairs(arg) do
							local v47, v48 = fn44(v46, i)
							table.insert(tbl16, { entry = v47, value = v48 })
						end

						for i, v46 in ipairs(tbl16) do
							v46.originalValue = fn45(v46.entry, i)
						end

						local tbl17 = {}

						for i, v46 in ipairs(tbl16) do
							local ok, result = pcall(v46.entry.setValue, v46.value)

							if not ok then
								local v47 = v45.sanitize(result)
								local v48 = fn46(tbl16, i)

								if #v48 > 0 then
									v45.throw(
										"CONTROL_BATCH_ROLLBACK_FAILED",
										("changes[%d] failed and the batch could not be fully rolled back: %s"):format(
											i,
											v47.message
										),
										{ details = { applyFailure = v47, failedIndex = i, rollbackFailures = v48 } }
									)
								end

								v45.throw(
									v47.code,
									("changes[%d]: %s"):format(i, v47.message),
									{ retryable = v47.retryable, details = v47.details }
								)
							end

							tbl17[i] = fn33(v46.entry, true)
						end

						return { applied = #tbl17, count = #tbl17, results = tbl17 }
					end

					tbl15.resetControl = function(arg)
						local v46 = fn36(arg)

						if type(v46.setValue) ~= "function" then
							v45.throw("CONTROL_READ_ONLY", ("Control '%s' cannot be set."):format(v46.title))
						end

						if v46.defaultValue == nil then
							v45.throw(
								"CONTROL_NO_DEFAULT",
								("Control '%s' has no registered default value."):format(v46.title)
							)
						end

						v46.setValue(fn43(v46, v46.defaultValue))
						return fn33(v46, true)
					end

					tbl15.pressButton = function(arg)
						local v46 = fn36(arg)

						if type(v46.trigger) ~= "function" then
							v45.throw("CONTROL_READ_ONLY", ("Control '%s' is not an action button."):format(v46.title))
						end

						v46.trigger()
						return fn33(v46, true)
					end

					return tbl15
				end)()
			)
		end,
		[165] = function()
			local v, instance, v43 = fn23(165)

			return (
				(function()
					local children = v43(instance.Parent.Parent.Parent.packages.fusion).Children

					return function(...)
						local e = {}
						local M = {}
						local x = { ... }

						for O, O in x, nil, nil do
							if typeof(O) == "table" then
								for x, R in O, nil, nil do
									if x == children then
										table.insert(M, R)
									else
										e[x] = R
									end
								end
							end
						end

						if #M ~= 0 then
							e[children] = M
						end

						return e
					end
				end)()
			)
		end,
		[166] = function()
			local v, instance, v43 = fn23(166)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.utils.fusionUtils.combineProps)

					return {
						Component = function(e)
							return function(M, x, ...)
								return e(M, v44(x, ...))
							end
						end,
						ConstructorComponent = function(e)
							return function(M, x, O, ...)
								return e(M, x, v44(O, ...))
							end
						end,
					}
				end)()
			)
		end,
		[167] = function()
			local v, instance, v43 = fn23(167)

			return (
				(function()
					local computed = v43(instance.Parent.Parent.Parent.packages.fusion).Computed

					return function(e, M, x)
						return computed(e, function(g)
							return 1 - ((1 - math.clamp(g(M), 0, 1)) * (1 - math.clamp(g(x), 0, 1)))
						end)
					end
				end)()
			)
		end,
		[168] = function()
			local v, instance, v43 = fn23(168)

			return (
				(function()
					local RunService = game:GetService("RunService")
					local TweenService = game:GetService("TweenService")
					local parent = instance.Parent.Parent.Parent
					local v44 = v43(parent.packages.fusion)
					local v45 = v43(parent.utils.colorSpace)
					local oklab = v45.Oklab
					local observer = v44.Observer
					local peek = v44.peek
					local value = v44.Value
					local tweenInfo = TweenInfo.new()
					local n27 = 1e-06
					local function fn24(g)
						if g.RepeatCount <= -1 then
							return math.huge
						end
						local e = g.DelayTime + g.Time
						return (if g.Reverses then e + g.Time else e) * (g.RepeatCount + 1)
					end

					local function fn25(e, M)
						local x, O = e.DelayTime, e.Time
						local R = x + O
						R = if e.Reverses then R + O else R
						if M == math.huge then
							return 1
						end

						if (e.RepeatCount > -1) and (M >= (R * (e.RepeatCount + 1))) then
							return 1
						end

						if R == 0 then
							return 1
						end
						local d = M % R
						if d <= x then
							return 0
						end
						local M = (d - x) / O
						return TweenService:GetValue(if M > 1 then 2 - M else M, e.EasingStyle, e.EasingDirection)
					end

					local function getColor(g)
						local e, M, x = g.R, g.G, g.B
						return Color3.new(
							math.clamp(if e ~= e then 0 else e, 0, 1),
							math.clamp(if M ~= M then 0 else M, 0, 1),
							math.clamp(if x ~= x then 0 else x, 0, 1)
						)
					end

					local function fn26(e, M, x)
						local O, R, d = oklab.From(e):Components()
						local e, p, I = oklab.From(M):Components()
						M = 1 - x
						return oklab.new((O - (e * x)) / M, (R - (p * x)) / M, (d - (I * x)) / M)
					end

					return function(e, M, x)
						local O = x or tweenInfo
						x = peek(M)
						local R = value(e, getColor(x))
						local d = oklab.From(x)
						local p = 0
						local I = 0
						local E, w, S = fn24(O), false
						local f = x

						local function x()
							if not S then
								return
							end
							S:Disconnect()
							S = nil
						end

						local function a()
							local n = peek(M)
							local Q = n ~= f

							if Q then
								d, f = if math.abs(1 - p) > n27 then fn26(peek(R), n, p) else oklab.From(peek(R)), n
							end

							local Z = os.clock() - I
							n = fn25(O, Z)
							R:set(getColor(v45.ToGamutMappedColor3(d:Lerp(oklab.From(f), n))))
							p = n

							if Z >= E then
								R:set(getColor(f))
								p = 1

								if not Q then
									x()
								end
							end
						end

						local n = observer(e, M):onChange(function()
							if w or S then
								return
							end
							f = peek(M)
							d, p = oklab.From(peek(R)), 0
							I = os.clock()
							E = fn24(O)
							S = RunService.Heartbeat:Connect(a)
						end)

						table.insert(e, function()
							w = true
							n()
							x()
						end)

						return R
					end
				end)()
			)
		end,
		[169] = function()
			local v, instance, v43 = fn23(169)

			return (
				(function()
					local provider = "UntitledUI"
					local parent = instance.Parent.Parent
					local v44 = v43(instance.Parent.runtimeAssets)
					local tbl14 = { Dropshadow = "rbxassetid://6049668989", Shadow = "rbxassetid://9313765853" }
					local tbl15 = { Dropshadow = true, Shadow = true }

					local tbl16 = {
						ChatWarningIcon = 48,
						ChatSendIcon = 18,
						ChevronDownIcon = 20,
						DropdownArrowIcon = 14,
						MinimizeIcon = 22,
						CloseIcon = 22,
						SettingsIcon = 16,
						CheckIcon = 14,
						KeyboardIcon = 16,
						LikeIcon = 12,
						DownloadIcon = 12,
						SearchIcon = 16,
						StatusSuccessIcon = 20,
						StatusErrorIcon = 20,
						StatusWarningIcon = 20,
						StatusInfoIcon = 20,
						DashboardHomeIcon = 36,
						DashboardHomeActiveIcon = 36,
						DashboardAppsIcon = 36,
						DashboardAppsActiveIcon = 36,
						DashboardScriptsIcon = 36,
						DashboardScriptsActiveIcon = 36,
						DashboardOptionsIcon = 36,
						DashboardOptionsActiveIcon = 36,
						ModPanelIcon = 18,
						ModPanelActiveIcon = 18,
						ChatIcon = 18,
						ChatActiveIcon = 18,
						AIChatIcon = 18,
						AIChatActiveIcon = 18,
						CloudConfigsIcon = 18,
						CloudConfigsActiveIcon = 18,
						ClientControlIcon = 18,
						ClientControlActiveIcon = 18,
						AgentSendIcon = 20,
						AgentStopIcon = 20,
						AgentGuidesIcon = 16,
						AgentPromptsIcon = 16,
						AgentChatSessionIcon = 14,
						AgentChatSessionActiveIcon = 14,
						AgentThinkingIcon = 14,
						AgentToolSearchIcon = 14,
						AgentToolWebIcon = 14,
						AgentToolCodeIcon = 14,
						AgentToolGenericIcon = 14,
						NetworkPingIcon = 20,
						FrameRateIcon = 20,
						ServerCapacityIcon = 32,
						MemoryIcon = 20,
						RegionIcon = 20,
						UptimeIcon = 20,
						PlaceLoadingIcon = 22,
						PlaceAvailableIcon = 22,
						PlaceIcon = 20,
						CopyIcon = 12,
						EditIcon = 12,
						ThumbsUpIcon = 12,
						ThumbsDownIcon = 12,
						RegenerateIcon = 12,
					}

					local tbl17 = {
						"ChatWarningIcon",
						"ChatSendIcon",
						"ChevronDownIcon",
						"DropdownArrowIcon",
						"MinimizeIcon",
						"CloseIcon",
						"SettingsIcon",
						"CheckIcon",
						"KeyboardIcon",
						"LikeIcon",
						"DownloadIcon",
						"SearchIcon",
						"StatusSuccessIcon",
						"StatusErrorIcon",
						"StatusWarningIcon",
						"StatusInfoIcon",
						"ModPanelIcon",
						"ModPanelActiveIcon",
						"ChatIcon",
						"ChatActiveIcon",
						"AIChatIcon",
						"AIChatActiveIcon",
						"CloudConfigsIcon",
						"CloudConfigsActiveIcon",
						"ClientControlIcon",
						"ClientControlActiveIcon",
						"AgentSendIcon",
						"AgentStopIcon",
						"AgentGuidesIcon",
						"AgentPromptsIcon",
						"AgentChatSessionIcon",
						"AgentChatSessionActiveIcon",
						"AgentThinkingIcon",
						"AgentToolSearchIcon",
						"AgentToolWebIcon",
						"AgentToolCodeIcon",
						"AgentToolGenericIcon",
						"NetworkPingIcon",
						"FrameRateIcon",
						"ServerCapacityIcon",
						"MemoryIcon",
						"RegionIcon",
						"UptimeIcon",
						"PlaceLoadingIcon",
						"PlaceAvailableIcon",
						"PlaceIcon",
						"CopyIcon",
						"EditIcon",
						"ThumbsUpIcon",
						"ThumbsDownIcon",
						"RegenerateIcon",
					}

					local providers = { "UntitledUI", "Remix", "Heroicons", "Phosphor" }

					local tbl18 = {
						untitledui = "UntitledUI",
						["untitled ui"] = "UntitledUI",
						["untitled-ui"] = "UntitledUI",
						remix = "Remix",
						remixicon = "Remix",
						remixicons = "Remix",
						["remix icon"] = "Remix",
						["remix icons"] = "Remix",
						heroicons = "Heroicons",
						["hero icons"] = "Heroicons",
						["hero-icons"] = "Heroicons",
						phosphor = "Phosphor",
						["phosphor icons"] = "Phosphor",
					}

					local tbl19 = {}
					local v45 = v43(instance.Parent.pendingTasks)
					local tbl20 = {}

					local function fn24(arg)
						return type(arg) == "string" and arg ~= "" and arg ~= "rbxassetid://0"
					end

					local function fn25(arg)
						if fn24(arg) then
							return v44.resolve(arg)
						end

						if type(arg) == "table" and fn24(arg.Image) then
							return v44.resolve(arg.Image)
						end
						return nil
					end

					local function fn26(arg)
						if type(arg) ~= "table" then
							return nil
						end
						local imageRectOffset = arg.ImageRectOffset
						local imageRectSize = arg.ImageRectSize
						if imageRectOffset and imageRectSize then
							return { offset = imageRectOffset, size = imageRectSize }
						end
						return nil
					end

					local function fn27(generatedImage)
						return fn25(generatedImage) ~= nil
					end

					local function fn28(ok, arg, arg2)
						if not ok then
							warn("Failed to load Tungsten-generated " .. arg2 .. ": " .. tostring(arg))
							return {}
						end

						if type(arg) ~= "table" then
							warn("Tungsten-generated " .. arg2 .. " must return a table")
							return {}
						end
						return arg
					end

					local function fn29(name, arg)
						local assets = parent:FindFirstChild("assets")
						assets = assets and assets:FindFirstChild("icons")
						assets = assets and assets:FindFirstChild(name)
						if not assets or assets.ClassName ~= "ModuleScript" then
							return {}
						end

						local ok, result = pcall(function()
							return v43(assets)
						end)

						return fn28(ok, result, arg)
					end

					local generatedImages = fn29("generatedImages", "image assets")
					local generatedLegacyImages = fn29("generatedLegacyImages", "legacy image assets")

					for k, generatedLegacyImage in pairs(generatedLegacyImages) do
						if not tbl15[k] then
							generatedImages[k] = generatedLegacyImage
						end
					end

					local function fn30(arg, arg2, arg3)
						local v46 = fn29(arg, arg2)
						if next(v46) ~= nil then
							return v46
						end
						local ok, result = pcall(arg3)
						if ok and type(result) == "table" then
							return result
						end
						return v46
					end

					local providers2 = {
						UntitledUI = fn30("generatedUntitledUiImages", "Untitled UI image assets", function()
							return v43(instance.Parent.Parent.assets.icons.generatedUntitledUiImages)
						end),
						Remix = fn30("generatedRemixImages", "Remix Icon image assets", function()
							return v43(instance.Parent.Parent.assets.icons.generatedRemixImages)
						end),
						Heroicons = fn30("generatedHeroiconsImages", "Heroicons image assets", function()
							return v43(instance.Parent.Parent.assets.icons.generatedHeroiconsImages)
						end),
						Phosphor = fn30("generatedPhosphorImages", "Phosphor image assets", function()
							return v43(instance.Parent.Parent.assets.icons.generatedPhosphorImages)
						end),
					}

					local function getGeneratedImage(arg)
						local generatedImage = generatedImages[arg]
						if fn27(generatedImage) then
							return generatedImage
						end
						return nil
					end

					local function fn31(arg, arg2)
						local v46 = fn25(arg2)

						if v46 then
							tbl19[arg] = v46
							tbl20[arg] = fn26(arg2)
						else
							tbl20[arg] = nil
						end
					end

					for k, v46 in pairs(tbl14) do
						fn31(k, v46)
					end

					local tbl21 = {}
					local tbl22 = {}

					for k, v46 in pairs(tbl19) do
						if type(v46) == "string" then
							tbl21[k] = v46
							tbl22[k] = tbl20[k]
						end
					end

					for k, generatedImage in pairs(generatedImages) do
						if fn27(generatedImage) then
							fn31(k, generatedImage)
						end
					end

					local instances = {}
					local obj = setmetatable({}, { __mode = "k" })

					local function fn32(unknownImageProvider)
						assert(type(unknownImageProvider) == "string", "Image provider must be a string")
						local v46 = tbl18[string.lower(unknownImageProvider)]
						assert(v46, "Unknown image provider: " .. unknownImageProvider)
						return v46
					end

					local function getIsImageLabel(instance2)
						return instance2:IsA("ImageLabel")
							or instance2:IsA("ImageButton")
							or instance2:IsA("ImageHandleAdornment")
					end

					local function fn33(arg, arg2)
						local image = tbl19[arg2]
						if not fn24(image) then
							return
						end

						pcall(function()
							if arg.Image == image then
								arg.Image = ""
							end

							arg.Image = image
							local v46 = tbl20[arg2]

							if v46 then
								arg.ImageRectOffset = v46.offset
								arg.ImageRectSize = v46.size
							else
								arg.ImageRectOffset = Vector2.new(0, 0)
								arg.ImageRectSize = Vector2.new(0, 0)
							end
						end)
					end

					local function fn34()
						local tbl23 = {}
						local tbl24 = {}

						local function fn35(arg, arg2)
							if not fn24(arg) or tbl24[arg] then
								return
							end

							if tbl23[arg] and tbl23[arg] ~= arg2 then
								tbl23[arg] = nil
								tbl24[arg] = true
							else
								tbl23[arg] = arg2
							end
						end

						for _, v46 in ipairs(tbl17) do
							fn35(tbl19[v46], v46)
							fn35(tbl21[v46], v46)
						end

						return tbl23
					end

					local function fn35(arg)
						for k, v46 in pairs(obj) do
							fn33(k, v46)
						end

						for i = #instances, 1, -1 do
							local instance2 = instances[i]

							local ok, result = pcall(function()
								return instance2:GetDescendants()
							end)

							if not ok then
								table.remove(instances, i)
								continue
							end
							table.insert(result, 1, instance2)

							for _, v46 in ipairs(result) do
								if not (getIsImageLabel(v46) and not obj[v46]) then
									continue
								end

								local ok2, result2 = pcall(function()
									return v46.Image
								end)

								ok2 = ok2 and arg[result2]

								if ok2 then
									fn33(v46, ok2)
								end
							end
						end
					end

					local function fn36(provider2, arg)
						local provider3 = providers2[provider2]
						local provider4 = providers2[provider]
						local count5 = 0

						for _, v46 in ipairs(tbl17) do
							local provider5 = provider3 and provider3[v46]
							local v47 = fn25(provider5)

							if v47 then
								count5 += 1
							end

							if v47 then
								tbl19[v46] = v47
								tbl20[v46] = fn26(provider5)
							else
								local provider6 = provider4 and provider4[v46]
								local generatedImage = getGeneratedImage(v46)
								tbl19[v46] = fn25(provider6) or fn25(generatedImage) or tbl21[v46]
								tbl20[v46] = fn26(provider6) or fn26(generatedImage) or tbl22[v46]
							end
						end

						if count5 == 0 then
							warn(
								"Image provider '"
									.. provider2
									.. "' did not load any generated assets; using fallback images."
							)
						end

						fn35(arg)
					end

					tbl19.Provider = provider
					tbl19.Providers = providers

					tbl19.SetProvider = function(arg, arg2)
						local provider2 = fn32(arg2)
						local v46 = fn34()
						tbl19.Provider = provider2
						fn36(provider2, v46)
						return provider2
					end

					tbl19.GetProvider = function()
						return tbl19.Provider
					end

					tbl19.GetProviders = function()
						local tbl23 = {}

						for i, provider2 in ipairs(providers) do
							tbl23[i] = provider2
						end

						return tbl23
					end

					tbl19.IconSizes = table.freeze(tbl16)
					tbl19.IconKeys = table.freeze(tbl17)

					local function fn37(arg)
						local v46 = fn25(arg)
						if not v46 then
							return nil
						end
						local v47 = fn26(arg)
						if v47 then
							return { Image = v46, ImageRectOffset = v47.offset, ImageRectSize = v47.size }
						end
						return { Image = v46 }
					end

					tbl19.GetIcon = function(arg, arg2)
						return tbl19[arg2]
					end

					tbl19.GetIconData = function(arg, arg2)
						return fn37({
							Image = tbl19[arg2],
							ImageRectOffset = tbl20[arg2] and tbl20[arg2].offset,
							ImageRectSize = tbl20[arg2] and tbl20[arg2].size,
						})
					end

					tbl19.GetProviderIconData = function(arg, arg2, arg3)
						local provider2 = providers2[fn32(arg2)]
						return fn37(provider2 and provider2[arg3])
					end

					tbl19.GetProviderCoverage = function(arg, arg2)
						local provider2 = providers2[fn32(arg2)]
						local v46 = 0

						for _, v47 in ipairs(tbl17) do
							if fn25(provider2 and provider2[v47]) then
								v46 += 1
							end
						end

						return v46, #tbl17
					end

					tbl19.Track = function(arg, arg2, arg3)
						if arg3 then
							obj[arg3] = arg2
							fn33(arg3, arg2)
						end

						return arg3
					end

					tbl19.RegisterRoot = function(arg, instance2)
						if not instance2 or not instance2.GetDescendants then
							return
						end

						for _, instance3 in ipairs(instances) do
							if instance3 == instance2 then
								return
							end
						end

						table.insert(instances, instance2)
						local v46 = fn34()
						fn35(v46)

						v45.defer(function()
							fn35(fn34())
						end)
					end

					tbl19.UnregisterRoot = function(arg, arg2)
						for i = #instances, 1, -1 do
							if instances[i] == arg2 then
								table.remove(instances, i)
							end
						end
					end

					tbl19.cleanup = function()
						for i = #instances, 1, -1 do
							instances[i] = nil
						end

						obj = setmetatable({}, { __mode = "k" })
					end

					tbl19:SetProvider("UntitledUI")
					return tbl19
				end)()
			)
		end,
		[170] = function()
			local v, instance, v43 = fn23(170)

			return (
				(function()
					local peek = v43(instance.Parent.Parent.packages.fusion).peek

					return function(arg, arg2)
						local tbl14 = peek(arg)

						if type(tbl14) ~= "table" then
							tbl14 = {}
						end

						local v44 = table.create(#tbl14 + 1)

						for i = 1, #tbl14 do
							v44[i] = tbl14[i]
						end

						v44[#tbl14 + 1] = arg2
						arg:set(table.freeze(v44))
					end
				end)()
			)
		end,
		[171] = function()
			local v, instance, v43 = fn23(171)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.packages.fusion)
					local RunService = game:GetService("RunService")
					local peek = v44.peek

					local function fn24(arg)
						return type(arg) == "table" and arg.type == "State"
					end

					return {
						new = function(e, M, x, O)
							assert(e ~= nil, "KeyedListState.new requires scope")
							assert(type(x) == "function", "KeyedListState.new requires keyOf")
							local R, d, p, I, E, w, S =
								if fn24(M) then M else (e:Value(M or {})),
								{},
								e:Value({}),
								true,
								{},
								if O ~= nil
									then (math.max(1, math.floor(O.maxNewEntriesPerFrame or math.huge)))
									else math.huge
							local M, f = R, w

							local function R(w)
								local a = {}

								for n in pairs(w) do
									local w = d[n]

									if w ~= nil then
										a[n] = w
									end
								end

								p:set(a)
							end

							local function w(a, n)
								local Q = 0

								while (#E > 0) and (Q < a) do
									local a = O ~= nil
									local Z = table.remove(E, if a and O.newestFirst then #E else 1)

									if n[Z.key] and (d[Z.key] == nil) then
										a = e:innerScope()
										d[Z.key] = {
											key = Z.key,
											scope = a,
											value = a:Value(Z.item),
											index = a:Value(Z.index),
										}
										Q += 1
									end
								end

								return Q
							end

							local O = {}

							local function a()
								if S ~= nil then
									S:Disconnect()
									S = nil
								end
							end

							local function n()
								if not I or (#E == 0) then
									a()
									return
								end
								w(f, O)
								R(O)

								if #E == 0 then
									a()
								end
							end

							local function Q()
								if not I then
									return
								end
								local Z = {}
								local t = {}
								local z = {}
								local L = {}

								for l, P in ipairs(peek(M) or {}) do
									local r = tostring(x(P, l) or l)
									local x = (L[r] or 0) + 1
									L[r] = x
									local L = if x == 1 then r else r .. ("#" .. tostring(x))
									r = d[L]

									if r == nil then
										table.insert(z, { key = L, item = P, index = l })
									else
										r.value:set(P)
										r.index:set(l)
										Z[L] = r
									end

									t[L] = true
								end

								for x, L in pairs(d) do
									if Z[x] == nil then
										L.scope:doCleanup()
									end
								end

								d, O, E = Z, t, z
								w(f, O)
								R(O)
								Z = (#E > 0) and (S == nil)

								if Z then
									S = RunService.Heartbeat:Connect(n)
								elseif #E == 0 then
									a()
								end
							end

							Q()
							e:Observer(M):onChange(Q)

							e:insert(function()
								I = false
								a()
								E, d = {}, {}
							end)

							return p
						end,
					}
				end)()
			)
		end,
		[172] = function()
			fn23(172)

			return (function()
				local function fn24(arg)
					if type(debug) == "table" and type(debug.traceback) == "function" then
						return debug.traceback(tostring(arg), 2)
					end
					return tostring(arg)
				end

				return table.freeze({
					run = function(arg, arg2, arg3)
						local ok, result = xpcall(arg2, fn24)
						if ok then
							return result
						end

						if arg3 ~= nil then
							pcall(arg3, result)
						end

						local ok2, result2 = pcall(function()
							arg:Destroy()
						end)

						if ok2 then
							error(result, 0)
						end

						error(result .. "\nBootstrap cleanup also failed: " .. tostring(result2), 0)
					end,
				})
			end)()
		end,
		[173] = function()
			fn23(173)

			return (
				(function()
					local tbl14 = { 24, 22, 20, 18, 16, 15 }

					local function fn24(arg)
						return (string.gsub(string.gsub(string.gsub(arg, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"))
					end

					local function fn25(arg)
						return arg ~= nil and arg ~= "" and string.match(arg, "[%w]") ~= nil
					end

					local function fn26(arg, arg2, arg3)
						if arg3 and arg3 ~= "" then
							return string.format("<%s %s>%s</%s>", arg, arg3, arg2, arg)
						end
						return string.format("<%s>%s</%s>", arg, arg2, arg)
					end

					local function getFont(arg)
						return fn26("font", arg, string.format('color="%s"', "#F0C674"))
					end

					local function fn27(arg, arg2)
						return fn26("u", fn26("font", arg, string.format('color="%s"', "#8AB4FF")))
							.. " "
							.. fn26("font", "(" .. arg2 .. ")", string.format('color="%s"', "#8F8F8F"))
					end

					local function fn28(arg)
						local tbl15 = {}
						local n = 1

						while true do
							local v = string.find(arg, "\n", n, true)
							if not v then
								table.insert(tbl15, string.sub(arg, n))
								break
							end
							table.insert(tbl15, string.sub(arg, n, v - 1))
							n = v + 1
						end

						return tbl15
					end

					local function fn29(arg, arg2, arg3)
						return string.find(arg, arg2, arg3, true)
					end

					local function fn30(arg, arg2, arg3)
						local str7 = arg2 > 1 and string.sub(arg, arg2 - 1, arg2 - 1) or ""
						local str8 = string.sub(arg, arg2 + 1, arg2 + 1)
						if str8 == "" or string.match(str8, "%s") then
							return false
						end

						if arg3 == "_" and str7 ~= "" and fn25(str7) then
							return false
						end
						return true
					end

					local function fn31(arg, arg2, arg3)
						local str7 = arg2 > 1 and string.sub(arg, arg2 - 1, arg2 - 1) or ""
						local str8 = string.sub(arg, arg2 + 1, arg2 + 1)
						if str7 == "" or string.match(str7, "%s") then
							return false
						end

						if arg3 == "_" and str8 ~= "" and fn25(str8) then
							return false
						end
						return true
					end

					local function fn32(arg, arg2, arg3)
						local n = arg3 + 1

						while n <= #arg do
							local v = fn29(arg, arg2, n)
							if not v then
								return nil
							end

							if fn31(arg, v, arg2) then
								return v
							end
							n = v + 1
						end

						return nil
					end

					local function fn33(arg, arg2)
						local flag19 = arg2 and arg2 ~= ""
						local str7 = ""

						if flag19 then
							str7 = fn26("font", string.upper(fn24(arg2)), string.format('color="%s"', "#8F8F8F"))
								.. "\n"
						end

						return str7 .. fn26("font", fn24(arg), string.format('color="%s"', "#F0C674"))
					end

					local function fn34(arg)
						local tbl15 = {}
						local n = 1

						while n <= #arg do
							local str7 = string.sub(arg, n, n)
							local str8 = string.sub(arg, n, n + 1)
							local str9 = string.sub(arg, n, n + 2)

							if str7 == "\\" then
								local str10 = string.sub(arg, n + 1, n + 1)

								if str10 ~= "" then
									table.insert(tbl15, fn24(str10))
									n += 2
								else
									table.insert(tbl15, "\\")
									n += 1
								end
							elseif str9 == "***" or str9 == "___" then
								local v, v43 = fn29(arg, str9, n + 3)

								if not v then
									table.insert(tbl15, fn24(str9))
									n += 3
									continue
								end

								local str10 = string.sub(arg, n + 3, v - 1)

								if str10 ~= "" then
									table.insert(tbl15, fn26("b", fn26("i", fn34(str10))))
									n = v43 + 1
								else
									table.insert(tbl15, fn24(str9))
									n += 3
								end
							elseif str8 == "**" or str8 == "__" then
								local v, v43 = fn29(arg, str8, n + 2)

								if not v then
									table.insert(tbl15, fn24(str8))
									n += 2
									continue
								end

								local str10 = string.sub(arg, n + 2, v - 1)

								if str10 ~= "" then
									table.insert(tbl15, fn26("b", fn34(str10)))
									n = v43 + 1
								else
									table.insert(tbl15, fn24(str8))
									n += 2
								end
							elseif str8 == "~~" then
								local v, v43 = fn29(arg, str8, n + 2)

								if not v then
									table.insert(tbl15, fn24(str8))
									n += 2
									continue
								end

								local str10 = string.sub(arg, n + 2, v - 1)

								if str10 ~= "" then
									table.insert(tbl15, fn26("s", fn34(str10)))
									n = v43 + 1
								else
									table.insert(tbl15, fn24(str8))
									n += 2
								end
							elseif str7 == "`" then
								local v = fn29(arg, "`", n + 1)

								if v then
									local str10 = string.sub(arg, n + 1, v - 1)
									local insert = table.insert
									local v43 = table.pack(getFont(fn24(str10)))
									insert(tbl15, table.unpack(v43, 1, v43.n))
									n = v + 1
								else
									table.insert(tbl15, fn24(str7))
									n += 1
								end
							elseif str7 == "[" then
								local v, v43 = fn29(arg, "](", n + 1)

								if not v then
									table.insert(tbl15, fn24(str7))
									n += 1
									continue
								end

								local v44 = fn29(arg, ")", v43 + 1)

								if not v44 then
									table.insert(tbl15, fn24(str7))
									n += 1
									continue
								end

								local str10 = string.sub(arg, n + 1, v - 1)
								local str11 = string.sub(arg, v43 + 1, v44 - 1)

								if str10 ~= "" and str11 ~= "" then
									table.insert(tbl15, fn27(fn34(str10), fn24(str11)))
									n = v44 + 1
								else
									table.insert(tbl15, fn24(str7))
									n += 1
								end
							else
								if not ((str7 == "*" or str7 == "_") and fn30(arg, n, str7)) then
									table.insert(tbl15, fn24(str7))
									n += 1
									continue
								end

								local v = fn32(arg, str7, n)

								if not v then
									table.insert(tbl15, fn24(str7))
									n += 1
									continue
								end

								local str10 = string.sub(arg, n + 1, v - 1)

								if str10 ~= "" then
									table.insert(tbl15, fn26("i", fn34(str10)))
									n = v + 1
								else
									table.insert(tbl15, fn24(str7))
									n += 1
								end
							end
						end

						return table.concat(tbl15)
					end

					return {
						toBlocks = function(arg)
							if type(arg) ~= "string" or arg == "" then
								return {}
							end
							local v = string.gsub(string.gsub(arg, "\r\n", "\n"), "\r", "\n")
							local tbl15 = {}
							local tbl16 = {}
							local tbl17 = {}
							local v43 = nil

							local function fn35()
								if #tbl16 == 0 then
									return
								end
								table.insert(tbl15, { kind = "markdown", text = table.concat(tbl16, "\n") })
								tbl16 = {}
							end

							local function fn36()
								table.insert(
									tbl15,
									{ kind = "code", language = v43 or "", text = table.concat(tbl17, "\n") }
								)
								tbl17 = {}
								v43 = nil
							end

							local v44, v45, v46 = ipairs(fn28(v))
							local flag19 = false

							for _, v47 in v44, v45, v46 do
								local v48 = string.match(v47, "^%s*```%s*([%w_%-]*)%s*$")

								if v48 ~= nil then
									if flag19 then
										fn36()
										flag19 = false
									else
										fn35()
										v43 = v48
										flag19 = true
									end
								elseif flag19 then
									table.insert(tbl17, v47)
								else
									table.insert(tbl16, v47)
								end
							end

							if flag19 then
								fn36()
							else
								fn35()
							end

							return tbl15
						end,
						toRichText = function(arg)
							if type(arg) ~= "string" then
								return ""
							end
							local v = string.gsub(string.gsub(arg, "\r\n", "\n"), "\r", "\n")
							if v == "" then
								return ""
							end
							local fonts = {}
							local tbl15 = {}
							local flag19 = false
							local v43 = nil

							local function fn35()
								if not flag19 then
									return
								end
								table.insert(fonts, fn33(table.concat(tbl15, "\n"), v43))
								tbl15 = {}
								v43 = nil
								flag19 = false
							end

							for _, v44 in ipairs(fn28(v)) do
								local v45 = string.match(v44, "^%s*```%s*([%w_%-]*)%s*$")

								if v45 ~= nil then
									if flag19 then
										fn35()
									else
										flag19 = true
										v43 = v45
									end
								elseif flag19 then
									table.insert(tbl15, v44)
								else
									if v44 == "" then
										table.insert(fonts, "")
										continue
									end
									local v46, v47 = string.match(v44, "^%s*(#+)%s+(.-)%s*$")

									if v46 and v47 then
										local v48 = tbl14[math.clamp(#v46, 1, #tbl14)]
										table.insert(
											fonts,
											fn26("font", fn26("b", fn34(v47)), string.format('size="%d"', v48))
										)
										continue
									end

									local v48 = string.match(v44, "^%s*>%s?(.-)%s*$")
									if v48 then
										table.insert(
											fonts,
											fn26("font", "|", string.format('color="%s"', "#B0B0B0"))
												.. " "
												.. fn26("i", fn34(v48))
										)
										continue
									end
									local v49, v50 = string.match(v44, "^(%s*)[-%*+]%s+(.-)%s*$")

									if v50 then
										local n = math.floor(#v49 / 2)
										table.insert(fonts, string.rep("    ", n) .. "* " .. fn34(v50))
										continue
									end

									local v51, v52, v53 = string.match(v44, "^(%s*)(%d+)%.%s+(.-)%s*$")

									if v53 then
										local n = math.floor(#v51 / 2)
										table.insert(
											fonts,
											string.rep("    ", n) .. fn26("b", fn24(v52) .. ".") .. " " .. fn34(v53)
										)
									elseif string.match(v44, "^%s*[-*_][%s%-%*_]*[-*_]%s*$") then
										table.insert(
											fonts,
											fn26("font", "----------------", string.format('color="%s"', "#5F5F5F"))
										)
									else
										table.insert(fonts, fn34(v44))
									end
								end
							end

							if flag19 then
								fn35()
							end

							return table.concat(fonts, "\n")
						end,
						escape = fn24,
					}
				end)()
			)
		end,
		[174] = function()
			fn23(174)

			return (
				(function()
					local tbl14 = {}
					local flag19 = true

					local function fn24(arg, arg2, ...)
						assert(type(arg2) == "function", "pending task callback must be a function")
						if not flag19 then
							return nil
						end
						local v = table.pack(...)

						local v43 = arg(function()
							local v43 = coroutine.running()

							if not flag19 then
								if v43 ~= nil then
									tbl14[v43] = nil
								end

								return
							end

							arg2(table.unpack(v, 1, v.n))

							if v43 ~= nil then
								tbl14[v43] = nil
							end
						end)

						if flag19 and coroutine.status(v43) ~= "dead" then
							tbl14[v43] = true
						end

						return v43
					end

					return {
						spawn = function(arg, ...)
							local spawn_ = task.spawn
							local v = table.pack(...)
							local v43 = fn24
							v.n = 3 + v.n - 1
							table.move(v, 1, v.n, 3, v)
							v[1] = spawn_
							v[2] = arg
							return v43(table.unpack(v, 1, v.n))
						end,
						defer = function(arg, ...)
							local defer = task.defer
							local v = table.pack(...)
							local v43 = fn24
							v.n = 3 + v.n - 1
							table.move(v, 1, v.n, 3, v)
							v[1] = defer
							v[2] = arg
							return v43(table.unpack(v, 1, v.n))
						end,
						delay = function(delay, arg, ...)
							return fn24(function(arg2)
								return task.delay(delay, arg2)
							end, arg, ...)
						end,
						cancel = function(arg)
							if arg == nil then
								return
							end
							tbl14[arg] = nil
							if arg == coroutine.running() or coroutine.status(arg) == "dead" then
								return
							end
							pcall(task.cancel, arg)
						end,
						cleanup = function()
							if not flag19 then
								return
							end
							flag19 = false
							local v = tbl14
							tbl14 = {}

							for k in pairs(v) do
								if k ~= coroutine.running() and coroutine.status(k) ~= "dead" then
									pcall(task.cancel, k)
								end
							end
						end,
					}
				end)()
			)
		end,
		[175] = function()
			fn23(175)

			return (
				(function()
					local flag19 = false
					local flag20 = false
					local tbl14 = {}
					local tbl15 = {}
					local delay = 5
					local thread = nil

					local function fn24()
						return flag20
							and type(debug) == "table"
							and type(debug.profilebegin) == "function"
							and type(debug.profileend) == "function"
					end

					local function fn25(arg, arg2, arg3)
						local v = fn24()

						if v then
							debug.profilebegin(arg)
						end

						local now2 = 0

						if arg2 then
							now2 = os.clock()
						end

						local v43 = table.pack(pcall(arg3))
						local elapsed = arg2 and os.clock() - now2 or nil

						if v then
							debug.profileend()
						end

						if arg2 and elapsed ~= nil then
							local tbl16 = tbl15[arg] or { total = 0, count = 0, max = 0 }
							tbl16.total += elapsed
							tbl16.count += 1

							if tbl16.max < elapsed then
								tbl16.max = elapsed
							end

							tbl15[arg] = tbl16
						end

						if not v43[1] then
							error(v43[2], 0)
						end

						return table.unpack(v43, 2, v43.n)
					end

					local function fn26()
						tbl14 = {}
						tbl15 = {}
					end

					local function fn27()
						if thread then
							return
						end

						thread = task.spawn(function()
							while flag19 do
								task.wait(delay)
								if not flag19 then
									break
								end
								local flag21 = next(tbl14) ~= nil
								local flag22 = next(tbl15) ~= nil

								if flag21 or flag22 then
									print("[Perf] Report (" .. tostring(delay) .. "s)")
								end

								for k, v in pairs(tbl14) do
									print(("[Perf] %s count=%d"):format(k, v))
								end

								for k, v in pairs(tbl15) do
									print(
										("[Perf] %s avg=%.3fms max=%.3fms count=%d"):format(
											k,
											(v.count > 0 and v.total / v.count or 0) * 1000,
											(v.max or 0) * 1000,
											v.count
										)
									)
								end

								if flag21 or flag22 then
									print("[Perf] End")
								end

								fn26()
							end

							thread = nil
						end)
					end

					local function fn28()
						if thread then
							task.cancel(thread)
							thread = nil
						end
					end

					return {
						isEnabled = function()
							return flag19
						end,
						setEnabled = function(arg, arg2)
							flag19 = arg == true

							if type(arg2) == "number" and arg2 > 0 then
								delay = arg2
							end

							if flag19 then
								fn27()
							else
								fn28()
								fn26()
							end
						end,
						setMicroProfilerEnabled = function(arg)
							flag20 = arg == true
						end,
						cleanup = function()
							flag19 = false
							flag20 = false
							fn28()
							fn26()
						end,
						mark = function(arg, arg2)
							if not flag19 then
								return
							end
							tbl14[arg] = (tbl14[arg] or 0) + (arg2 or 1)
						end,
						profile = function(arg, arg2)
							if not fn24() then
								return arg2()
							end
							return fn25(arg, false, arg2)
						end,
						time = function(arg, arg2)
							if not flag19 and not fn24() then
								return arg2()
							end
							return fn25(arg, flag19, arg2)
						end,
					}
				end)()
			)
		end,
		[176] = function()
			local v, instance, v43 = fn23(176)

			return (
				(function()
					local players = v43(instance.Parent.services).Players
					local tbl14 = { "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", "Head" }

					local function fn24(arg, arg2)
						if string.sub(arg, 1, #arg2) == arg2 then
							return true
						end
						return false
					end

					local tbl15

					tbl15 = {
						me = function()
							return players.LocalPlayer
						end,
						getCharacter = function()
							local localPlayer = players.LocalPlayer
							return localPlayer.Character or localPlayer.CharacterAdded:Wait()
						end,
						others = function()
							local tbl16 = {}

							for _, v44 in players:GetPlayers(), nil do
								if v44 ~= tbl15.me() then
									table.insert(tbl16, v44)
								end
							end

							return tbl16
						end,
						getByName = function(arg)
							for _, player in players:GetPlayers(), nil do
								if
									fn24(string.lower(player.Name), arg) or fn24(string.lower(player.DisplayName), arg)
								then
									return player
								end
							end

							return nil
						end,
						setPosition = function(cframe)
							tbl15.getCharacter():PivotTo(cframe)
						end,
						getRoot = function(player)
							for _, v44 in player.Character:GetChildren() do
								if table.find(tbl14, v44.Name) then
									return v44
								end
							end

							return nil
						end,
						getHumanoid = function()
							return tbl15.getCharacter():FindFirstChildWhichIsA("Humanoid")
						end,
					}

					return tbl15
				end)()
			)
		end,
		[177] = function()
			local v, instance, v43 = fn23(177)

			return (
				(function()
					local peek = v43(instance.Parent.Parent.packages.fusion).peek

					return function(arg, arg2)
						local v44 = peek(arg)
						if type(v44) ~= "table" then
							return false
						end
						local v45 = table.find(v44, arg2)
						if v45 == nil then
							return false
						end
						local v46 = table.clone(v44)
						table.remove(v46, v45)
						arg:set(table.freeze(v46))
						return true
					end
				end)()
			)
		end,
		[178] = function()
			fn23(178)

			return (function()
				local v = table.freeze({})

				return table.freeze({
					isSupported = function()
						return false
					end,
					isReady = function()
						return true
					end,
					prepare = function()
						return true
					end,
					resolve = function(arg)
						return arg
					end,
					resolveCatalog = function(arg)
						return arg
					end,
					getVersion = function()
						return "roblox-assets"
					end,
					getRequiredAssetIds = function()
						return v
					end,
				})
			end)()
		end,
		[179] = function()
			fn23(179)

			return (
				(function()
					return function(arg)
						local ok, result = pcall(arg)

						if not ok then
							error(result)
						end

						return result
					end
				end)()
			)
		end,
		[180] = function()
			fn23(180)

			return (
				(function()
					return (
						setmetatable({}, {
							__index = function(serviceNames, serviceName)
								local ok, result = pcall(Instance.new, serviceName)
								local ok2 = ok and result
									or game:GetService(serviceName)
									or settings():GetService(serviceName)
									or UserSettings():GetService(serviceName)

								if cloneref then
									ok2 = cloneref(ok2)
								end

								if ok2 then
									serviceNames[serviceName] = ok2
								end

								return ok2
							end,
						})
					)
				end)()
			)
		end,
		[181] = function()
			fn23(181)

			return (
				(function()
					local function fn24(arg, arg2, arg3)
						local v = arg[arg2]
						if v ~= nil then
							arg[arg2] = nil
							return arg, v
						end
						return arg, arg3
					end

					local function fn25(arg)
						if type(arg) ~= "table" then
							return arg
						end
						local tbl14 = {}

						for k, v in pairs(arg) do
							tbl14[fn25(k)] = fn25(v)
						end

						return tbl14
					end

					return { Extract = fn24, DeepClone = fn25 }
				end)()
			)
		end,
		[182] = function()
			fn23(182)

			return (function()
				local function fn24(arg)
					if type(arg) ~= "string" then
						return ""
					end
					return string.match(arg, "^%s*(.-)%s*$") or ""
				end

				local function fn25(arg)
					return string.lower(fn24(arg))
				end

				local function fn26(arg)
					local v = fn24(arg.name)
					local v43 = fn24(arg.path)
					if v ~= "" and v43 ~= "" and v ~= v43 then
						return string.format("%s (%s)", v, v43)
					end

					if v43 ~= "" then
						return v43
					end

					if v ~= "" then
						return v
					end
					return fn24(arg.id)
				end

				local function fn27(arg)
					local str7 = fn24(arg.kind)

					if str7 == "" then
						str7 = "target"
					end

					local str8 = fn24(arg.pluralKind)

					if str8 == "" then
						str8 = str7 .. "s"
					end

					return str7, str8
				end

				local function fn28(entries, arg, entry)
					local value = entry.value

					if value ~= nil and not arg[value] then
						arg[value] = true
						table.insert(entries, entry)
					end
				end

				local function fn29(entry, arg)
					if fn24(entry.id) == arg then
						return true
					end
					local v = ipairs
					local aliases = entry.aliases or {}

					for _, aliase in v(aliases) do
						if fn24(aliase) == arg then
							return true
						end
					end

					return false
				end

				local function fn30(entry, arg)
					return fn25(entry.name) == arg or fn25(entry.path) == arg
				end

				local function fn31(entry, arg)
					if string.find(fn25(entry.id), arg, 1, true) then
						return true
					end

					if string.find(fn25(entry.name), arg, 1, true) then
						return true
					end

					if string.find(fn25(entry.path), arg, 1, true) then
						return true
					end
					local v = ipairs
					local aliases = entry.aliases or {}

					for _, aliase in v(aliases) do
						if string.find(fn25(aliase), arg, 1, true) then
							return true
						end
					end

					return false
				end

				local function fn32(arg, arg2, arg3)
					local v, v43 = fn27(arg2)
					local tbl14 = {}

					for i = 1, math.min(#arg3, 5) do
						tbl14[i] = fn26(arg3[i])
					end

					local v44 = fn24(arg2.ambiguousHint)
					local str7

					if v44 ~= "" then
						str7 = " " .. v44
					else
						str7 = v44
					end

					return {
						code = "CONTROL_AMBIGUOUS",
						message = ("Multiple %s matched '%s': %s.%s"):format(v43, arg, table.concat(tbl14, "; "), str7),
						details = { matches = tbl14 },
					}
				end

				return table.freeze({
					resolve = function(arg, arg2)
						local v = fn24(arg)
						local v43 = fn27(arg2)

						if v == "" then
							return nil,
								{
									code = "CONTROL_NOT_FOUND",
									message = ("Target must be a non-empty string for %s resolution."):format(v43),
								}
						end

						if type(arg2.direct) == "table" and arg2.direct[v] ~= nil then
							return arg2.direct[v], nil
						end
						local entries

						if type(arg2.entries) == "table" then
							entries = arg2.entries
						else
							entries = {}
						end

						for _, entry in ipairs(entries) do
							if fn29(entry, v) then
								return entry.value, nil
							end
						end

						local v44 = fn25(v)
						local tbl14 = {}
						local tbl15 = {}

						for _, entry in ipairs(entries) do
							if fn30(entry, v44) then
								fn28(tbl14, tbl15, entry)
							end
						end

						if #tbl14 == 1 then
							return tbl14[1].value, nil
						end

						if #tbl14 > 1 then
							return nil, fn32(v, arg2, tbl14)
						end

						if arg2.allowPartial == true then
							local tbl16 = {}
							local tbl17 = {}

							for _, entry in ipairs(entries) do
								if fn31(entry, v44) then
									fn28(tbl16, tbl17, entry)
								end
							end

							if #tbl16 == 1 then
								return tbl16[1].value, nil
							end

							if 1 < #tbl16 then
								return nil, fn32(v, arg2, tbl16)
							end
						end

						return nil, { code = "CONTROL_NOT_FOUND", message = ("No %s matched '%s'."):format(v43, v) }
					end,
				})
			end)()
		end,
		[183] = function()
			local v, v43, v44 = fn23(183)

			return (
				(function()
					local v45 = v44(v43.types)
					local v46 = v44(v43.constants)
					local v47 = v44(v43.createTheme)
					local v48 = v44(v43.manageTheme)
					local v49 = v44(v43.themeHelpers)
					local v50 = v44(v43.defaultThemeConfig)

					return {
						CreateTheme = v47,
						SetThemeForScope = v48.SetThemeForScope,
						GetThemeForScope = v48.GetThemeForScope,
						CalcColorModifier = v49.CalcColorModifier,
						ApplyColorModifier = v49.ApplyColorModifier,
						GetNextVariant = v49.GetNextVariant,
						DefaultThemeConfig = v50.DefaultThemeConfig,
						WithConfigDefaults = v50.WithConfigDefaults,
						Types = v45,
						Constants = v46,
					}
				end)()
			)
		end,
		[184] = function()
			fn23(184)

			return (
				(function()
					return {
						BASE_LIGHT_TEXT_COLOR = Color3.fromHex("#F8FAFC"),
						BASE_DARK_TEXT_COLOR = Color3.fromHex("#09090B"),
						COLOR_SEEDS = {
							Blue = Color3.fromRGB(40, 80, 180),
							Brown = Color3.fromRGB(120, 80, 50),
							Cyan = Color3.fromRGB(40, 170, 190),
							Gray = Color3.fromRGB(80, 80, 80),
							Green = Color3.fromRGB(40, 150, 80),
							Magenta = Color3.fromRGB(180, 60, 180),
							Orange = Color3.fromRGB(230, 120, 40),
							Pink = Color3.fromRGB(230, 100, 150),
							Purple = Color3.fromRGB(110, 60, 170),
							Red = Color3.fromRGB(200, 50, 50),
							Success = Color3.fromRGB(50, 200, 70),
							Violet = Color3.fromRGB(140, 80, 200),
							White = Color3.fromRGB(200, 200, 200),
							Yellow = Color3.fromRGB(230, 200, 60),
						},
					}
				end)()
			)
		end,
		[185] = function()
			local v, instance, v43 = fn23(185)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.colorSpace)
					v43(instance.Parent.types)
					local v45 = v43(instance.Parent.constants)
					local n = 3
					local v46 = 6
					local n27 = 9
					local v47 = 6
					local n28 = 0.225
					local n29 = 4.5
					local n30 = 0.18
					local tbl14 = { 0, 0.18, 0.36, 0.46, 0.56 }
					local tbl15 = { 0, 0.25, 0.5, 0.64, 0.76 }

					local function fn24(arg, arg2, arg3)
						return v44.ToGamutMappedColor3(v44.Oklab.From(arg):Lerp(v44.Oklab.From(arg2), arg3))
					end

					local function fn25(bgBaseColor, bgTintColor)
						local v48 = v44.Oklab.From(bgBaseColor)
						local v49 = v48:ToOklch()
						local v50 = v44.Oklch.From(bgTintColor)
						local n31

						if v49:IsDark() then
							n31 = 1
						else
							n31 = 0
						end

						local v51 = v44.Oklch
							.new(v49.lightness, math.min(v50.chroma, math.max(v49.chroma, 0.035)), v50.hue)
							:ToOklab()
						local v52 = table.create(v47)
						v52[1] = bgBaseColor

						for i = 2, v47 do
							local n32 = (i - 1) / (v47 - 1)
							v52[i] = v44.ToGamutMappedColor3(
								v44.Oklab.new(
									v48.lightness + (n31 - v48.lightness) * n32 * n28,
									v48.a + (v51.a - v48.a) * n32,
									v48.b + (v51.b - v48.b) * n32
								)
							)
						end

						return v52
					end

					local function fn26(arg, arg2)
						local v48 = table.create(#arg - 1)

						for i = 1, #arg - 1 do
							v48[i] = fn24(arg[i], arg[i + 1], arg2)
						end

						return v48
					end

					local function fn27(arg, arg2)
						local v48 = v44.Srgb
							.From(
								v44.Srgb.From(arg):BestContrast(
									v44.Srgb.From(v45.BASE_LIGHT_TEXT_COLOR),
									v44.Srgb.From(v45.BASE_DARK_TEXT_COLOR)
								)
							)
							:ToColor3()
						local v49 = v44.Oklab.From(v48)
						local v50 = v44.Oklab.From(arg)
						local v51

						if v49:IsDark() then
							v51 = tbl15
						else
							v51 = tbl14
						end

						arg2 = arg2 or 3
						assert(arg2 <= #v51, "Foreground palette exceeds configured tiers")
						local v52 = table.create(arg2)
						v52[1] = v48

						for i = 2, arg2 do
							v52[i] = v44.ToGamutMappedColor3(v49:Lerp(v50, v51[i]))
						end

						return v52
					end

					local function fn28(arg, arg2, bgBaseColor)
						local v48 = v44.Oklch.From(arg)
						local lightness = v48.lightness
						local v49 = v44.ToGamutMappedColor3(
							v44.Oklch.new(
								v48.lightness + (v44.Oklch.From(arg2).lightness - lightness) * 0.6,
								math.min(math.max(v48.chroma * 0.7, 0.08), 0.16),
								v48.hue
							)
						)
						if v44.Srgb.From(bgBaseColor):CheckContrast(v49).ratio >= n29 then
							return v49
						end
						local v50 = 0
						local n31 = 1
						local v51 = arg2

						for i = 1, 12 do
							local n32 = (v50 + n31) / 2
							local v52 = fn24(v49, arg2, n32)

							if not (n29 <= v44.Srgb.From(bgBaseColor):CheckContrast(v52).ratio) then
								v50 = n32
							else
								n31 = n32
								v51 = v52
							end
						end

						return v51
					end

					local function fn29(bgBaseColor)
						local v48 = v44.Oklch.From(bgBaseColor)
						local lightness = v48.lightness
						local n31 = lightness + n30
						local n32 = lightness - n30
						local tbl16 = {}

						for k, v49 in v45.COLOR_SEEDS do
							local v50 = v44.Oklch.From(v49)
							local n33

							if v48:IsDark() then
								n33 = math.max(v50.lightness, n31)
							else
								n33 = math.min(v50.lightness, n32)
							end

							tbl16[k] = v44.ToGamutMappedColor3(v44.Oklch.new(n33, v50.chroma, v50.hue))
						end

						return tbl16
					end

					return function(arg)
						local bgBaseColor = arg.BgBaseColor
						local accentPrimary = arg.AccentPrimary
						local accentSecondary = arg.AccentSecondary
						local accentCaution = arg.AccentCaution
						local accentDestructive = arg.AccentDestructive
						local v48 = fn25(bgBaseColor, arg.BgTintColor or bgBaseColor)
						local v49 = fn26(v48, 0.5)
						local v50 = fn27(bgBaseColor, 5)
						local v51 = fn27(accentPrimary)
						local v52 = fn27(accentSecondary)
						local v53 = fn27(accentCaution)
						local v54 = fn27(accentDestructive)
						local v55 = v50[1]
						local v56 = fn29(bgBaseColor)

						return {
							BgPrimary = v48[1],
							BgSecondary = v48[2],
							BgTertiary = v48[3],
							BgQuaternary = v48[4],
							BgQuinary = v48[5],
							BgPrimaryHighlight = v49[1],
							BgSecondaryHighlight = v49[2],
							BgTertiaryHighlight = v49[3],
							BgQuaternaryHighlight = v49[4],
							BgQuinaryHighlight = v49[5],
							FgPrimary = v55,
							FgSecondary = v50[2],
							FgTertiary = v50[3],
							FgQuaternary = v50[4],
							FgQuinary = v50[5],
							AccentPrimary = accentPrimary,
							AccentSecondary = accentSecondary,
							AccentCaution = accentCaution,
							AccentDestructive = accentDestructive,
							AccentPrimaryFgPrimary = v51[1],
							AccentPrimaryFgSecondary = v51[2],
							AccentPrimaryFgTertiary = v51[3],
							AccentSecondaryFgPrimary = v52[1],
							AccentSecondaryFgSecondary = v52[2],
							AccentSecondaryFgTertiary = v52[3],
							AccentCautionFgPrimary = v53[1],
							AccentCautionFgSecondary = v53[2],
							AccentCautionFgTertiary = v53[3],
							AccentDestructiveFgPrimary = v54[1],
							AccentDestructiveFgSecondary = v54[2],
							AccentDestructiveFgTertiary = v54[3],
							AccentFgPrimary = fn28(accentPrimary, v55, bgBaseColor),
							AccentFgSecondary = fn28(accentSecondary, v55, bgBaseColor),
							AccentFgCaution = fn28(accentCaution, v55, bgBaseColor),
							AccentFgDestructive = fn28(accentDestructive, v55, bgBaseColor),
							Success = v56.Success,
							Blue = v56.Blue,
							Brown = v56.Brown,
							Cyan = v56.Cyan,
							Gray = v56.Gray,
							Green = v56.Green,
							Magenta = v56.Magenta,
							Orange = v56.Orange,
							Pink = v56.Pink,
							Purple = v56.Purple,
							Red = v56.Red,
							Violet = v56.Violet,
							White = v56.White,
							Yellow = v56.Yellow,
							HeightSm = arg.HeightSm,
							HeightMd = arg.HeightMd,
							HeightLg = arg.HeightLg,
							CornerRadiusSm = n,
							CornerRadiusMd = v46,
							CornerRadiusLg = n27,
							FontMain = arg.FontMain,
							FontMono = arg.FontMono,
							FontMainTitleSize = arg.FontMainTitleSize,
							FontMainBodySize = arg.FontMainBodySize,
							FontMainCaptionSize = arg.FontMainCaptionSize,
							FontMonoTitleSize = arg.FontMonoTitleSize,
							FontMonoBodySize = arg.FontMonoBodySize,
							FontMonoCaptionSize = arg.FontMonoCaptionSize,
						}
					end
				end)()
			)
		end,
		[186] = function()
			local v, instance, v43 = fn23(186)

			return (
				(function()
					v43(instance.Parent.types)

					local function fn24()
						return {
							BgBaseColor = Color3.fromRGB(18, 18, 22),
							AccentPrimary = Color3.fromRGB(70, 100, 210),
							AccentSecondary = Color3.fromRGB(55, 165, 185),
							AccentCaution = Color3.fromHex("#A47103"),
							AccentDestructive = Color3.fromHex("#BE123C"),
							HeightSm = 24,
							HeightMd = 28,
							HeightLg = 36,
							FontMain = Font.new("rbxassetid://12187365364"),
							FontMono = Font.fromName("RobotoMono"),
							FontMainTitleSize = 15,
							FontMainBodySize = 14,
							FontMainCaptionSize = 12,
							FontMonoTitleSize = 14,
							FontMonoBodySize = 13,
							FontMonoCaptionSize = 12,
						}
					end

					return {
						DefaultThemeConfig = fn24,
						WithConfigDefaults = function(arg)
							if not arg then
								return fn24()
							end
							local v44 = table.clone(fn24())

							for k, v45 in pairs(arg) do
								v44[k] = v45
							end

							return v44
						end,
					}
				end)()
			)
		end,
		[187] = function()
			local v, instance, v43 = fn23(187)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local v45 = v43(instance.Parent.Parent.fusionUtils.oktween)
					v43(instance.Parent.types)
					local v46 = v43(instance.Parent.themeHelpers)
					local v47 = v43(instance.Parent.createTheme)
					local value = v44.Value
					local tweenInfo = TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
					local obj = setmetatable({}, { __mode = "k" })

					local function fn24(arg, arg2)
						local v48 = v47(arg2)
						local tbl14 = {}

						local tbl15 = {
							GetToken = v46.GetToken,
							GetBg = v46.GetBg,
							GetBgHighlight = v46.GetBgHighlight,
							GetFg = v46.GetFg,
							GetAccent = v46.GetAccent,
							GetAccentFg = v46.GetAccentFg,
							GetHeight = v46.GetHeight,
							GetCornerRadius = v46.GetCornerRadius,
							GetFont = v46.GetFont,
							GetFontSize = v46.GetFontSize,
							HighlightGradient = v46.HighlightGradient,
							ApplyColorModifier = v46.ApplyColorModifier,
							GetNextVariant = v46.GetNextVariant,
						}

						for k, v49 in pairs(v48) do
							local v50 = value(arg, v49)
							tbl14[k] = v50
							local v51

							if typeof(v49) == "Color3" then
								v51 = v45(arg, v50, tweenInfo)
							else
								v51 = v50
							end

							tbl15[k] = v51
						end

						return { Public = tbl15, Targets = tbl14 }
					end

					local function fn25(arg, arg2)
						local v48 = v47(arg2)

						for k, target in pairs(arg.Targets) do
							target:set(v48[k])
						end
					end

					return {
						SetThemeForScope = function(arg, arg2)
							local v48 = obj[arg]

							if v48 then
								fn25(v48, arg2)
							else
								obj[arg] = fn24(arg, arg2)
							end
						end,
						GetThemeForScope = function(arg)
							local v48 = obj[arg]
							return v48 and v48.Public or nil
						end,
					}
				end)()
			)
		end,
		[188] = function()
			local v, instance, v43 = fn23(188)

			return (
				(function()
					local v44 = v43(instance.Parent.Parent.Parent.packages.fusion)
					local v45 = v43(instance.Parent.Parent.colorSpace)
					v43(instance.Parent.types)
					local v46 = v43(instance.Parent.constants)
					local computed = v44.Computed
					local new = v44.New

					local v47 = table.freeze({
						accent = "AccentPrimary",
						background = "BgPrimary",
						["background.secondary"] = "BgPrimaryHighlight",
						stroke = "BgTertiary",
						text = "FgPrimary",
						["text.secondary"] = "FgSecondary",
						["text.tertiary"] = "FgTertiary",
						["text.quaternary"] = "FgQuaternary",
						["text.quinary"] = "FgQuinary",
						danger = "AccentDestructive",
						warning = "AccentCaution",
						success = "Success",
						blue = "Blue",
						brown = "Brown",
						cyan = "Cyan",
						gray = "Gray",
						green = "Green",
						magenta = "Magenta",
						orange = "Orange",
						pink = "Pink",
						purple = "Purple",
						red = "Red",
						violet = "Violet",
						white = "White",
						yellow = "Yellow",
						["font.main"] = "FontMain",
						["font.mono"] = "FontMono",
					})

					local function fn24(arg, arg2, arg3)
						return computed(arg2, function(arg4)
							local v48 = arg4(arg3)
							local v49 = arg[v47[v48] or v48]
							assert(v49 ~= nil, ("Unknown theme token %q"):format(v48))
							return arg4(v49)
						end)
					end

					local function fn25(arg, arg2, arg3)
						return v45.ToGamutMappedColor3(v45.Oklab.From(arg):Lerp(v45.Oklab.From(arg2), arg3))
					end

					local function fn26(arg, arg2, arg3, arg4)
						return computed(arg2, function(arg5)
							return arg5(arg[arg5(arg3)]) or arg4
						end)
					end

					local function fn27(arg, arg2, arg3, arg4)
						local v48

						if arg4 == "Hover" then
							v48 = fn25(arg3, arg2(arg.BgPrimary), 0.1)
						elseif arg4 == "HoverStroke" then
							v48 = fn25(arg3, arg2(arg.FgPrimary), 0.1)
						elseif arg4 ~= "Press" then
							v48 = arg3
						else
							v48 = fn25(arg3, arg2(arg.BgPrimary), 0.2)
						end

						return v48
					end

					local function fn28(arg, arg2, arg3, arg4)
						return computed(arg2, function(arg5)
							return fn27(arg, arg5, arg5(arg3), arg5(arg4))
						end)
					end

					local function fn29(arg, arg2, arg3, arg4, arg5)
						return computed(arg2, function(arg6)
							return fn27(arg, arg6, arg6(arg[arg6(arg3)]) or arg6(arg4), arg6(arg5))
						end)
					end

					local function fn30(arg, arg2, arg3, arg4)
						return fn29(
							arg,
							arg2,
							computed(arg2, function(arg5)
								local v48 = arg5(arg3)
								return (("Bg%*"):format(v48))
							end),
							arg.BgPrimary,
							arg4
						)
					end

					local function fn31(arg, arg2, arg3, arg4)
						return fn29(
							arg,
							arg2,
							computed(arg2, function(arg5)
								local v48 = arg5(arg3)
								return (("Bg%*Highlight"):format(v48))
							end),
							arg.BgPrimaryHighlight,
							arg4
						)
					end

					local function fn32(arg, arg2, arg3, arg4, arg5)
						return fn29(
							arg,
							arg2,
							computed(arg2, function(arg6)
								local v48 = arg6(arg3)
								local v49 = arg6(arg4)
								local str7

								if v49 then
									str7 = ("Accent%*Fg%*"):format(v49, v48)
								else
									str7 = ("Fg%*"):format(v48)
								end

								return str7
							end),
							arg.FgPrimary,
							arg5
						)
					end

					local function fn33(arg, arg2, arg3, arg4)
						return fn29(
							arg,
							arg2,
							computed(arg2, function(arg5)
								local v48 = arg5(arg3)
								return (("Accent%*"):format(v48))
							end),
							arg.AccentPrimary,
							arg4
						)
					end

					local function fn34(arg, arg2, arg3, arg4)
						return fn29(
							arg,
							arg2,
							computed(arg2, function(arg5)
								local v48 = arg5(arg3)
								return (("AccentFg%*"):format(v48))
							end),
							arg.AccentPrimary,
							arg4
						)
					end

					local function fn35(arg, arg2, arg3)
						return fn26(
							arg,
							arg2,
							computed(arg2, function(arg4)
								local v48 = arg4(arg3)
								return (("Height%*"):format(v48))
							end),
							arg.HeightLg
						)
					end

					local function fn36(arg, arg2, arg3)
						return fn26(
							arg,
							arg2,
							computed(arg2, function(arg4)
								local v48 = arg4(arg3)
								return (("CornerRadius%*"):format(v48))
							end),
							arg.CornerRadiusMd
						)
					end

					local function fn37(arg, arg2, arg3, arg4, arg5)
						return computed(arg2, function(arg6)
							local v48 = arg6(arg3)
							return Font.new(
								(arg6(arg[("Font%*"):format(v48)]) or arg6(arg.FontMain)).Family,
								arg6(arg4) or Enum.FontWeight.Medium,
								arg6(arg5) or Enum.FontStyle.Normal
							)
						end)
					end

					local function fn38(arg, arg2, arg3, arg4)
						return fn26(
							arg,
							arg2,
							computed(arg2, function(arg5)
								local v48 = arg5(arg3)
								local v49 = arg5(arg4)
								return (("Font%*%*Size"):format(v48, v49))
							end),
							arg.FontMainBodySize
						)
					end

					local colorSequence = ColorSequence.new({
						ColorSequenceKeypoint.new(0, v46.BASE_LIGHT_TEXT_COLOR),
						ColorSequenceKeypoint.new(1, v46.BASE_DARK_TEXT_COLOR),
					})

					return {
						GetToken = fn24,
						GetBg = fn30,
						GetBgHighlight = fn31,
						GetFg = fn32,
						GetAccent = fn33,
						GetAccentFg = fn34,
						GetHeight = fn35,
						GetCornerRadius = fn36,
						GetFont = fn37,
						GetFontSize = fn38,
						HighlightGradient = function(arg, arg2, arg3, arg4)
							local colorSequence2

							if arg4 == nil then
								colorSequence2 = colorSequence
							else
								colorSequence2 = computed(arg2, function(arg5)
									return arg5(arg4) or colorSequence
								end)
							end

							return (
								new(arg2, "UIGradient")({
									Color = colorSequence2,
									Rotation = 90,
									Transparency = computed(arg2, function(arg5)
										return NumberSequence.new(arg5(arg3))
									end),
								})
							)
						end,
						ApplyColorModifier = fn28,
						CalcColorModifier = function(arg, arg2, arg3, arg4)
							return v44.Computed(arg, function(arg5)
								local v48 = arg5(arg2)
								local str7

								if arg5(arg3) then
									str7 = "Press"
								elseif v48 then
									if arg4 == "Stroke" then
										str7 = "HoverStroke"
									else
										str7 = "Hover"
									end
								else
									str7 = nil
								end

								return str7
							end)
						end,
						GetNextVariant = function(arg, arg2)
							return computed(arg, function(arg3)
								local v48 = arg3(arg2)
								local str7

								if v48 == "Primary" then
									str7 = "Secondary"
								elseif v48 == "Secondary" then
									str7 = "Tertiary"
								elseif v48 == "Tertiary" then
									str7 = "Quaternary"
								elseif v48 == "Quaternary" then
									str7 = "Quinary"
								else
									str7 = "Secondary"
								end

								return str7
							end)
						end,
					}
				end)()
			)
		end,
		[189] = function()
			local v, instance, v43 = fn23(189)

			return ((function()
				v43(instance.Parent.Parent.Parent.packages.fusion)
				return nil
			end)())
		end,
		[190] = function()
			fn23(190)

			return (
				(function()
					local tbl14

					tbl14 = {
						new = function(arg, arg2, arg3)
							local tbl15 = { code = arg, message = arg2 }

							if arg3 then
								if arg3.retryable ~= nil then
									tbl15.retryable = arg3.retryable
								end

								if arg3.details ~= nil then
									tbl15.details = arg3.details
								end
							end

							return tbl15
						end,
						throw = function(arg, arg2, arg3)
							error(tbl14.new(arg, arg2, arg3), 2)
						end,
						is = function(arg)
							return type(arg) == "table" and type(arg.code) == "string" and type(arg.message) == "string"
						end,
						sanitize = function(arg)
							if tbl14.is(arg) then
								return arg
							end

							if typeof(arg) ~= "string" then
								arg = tostring(arg)
							end

							local str7 = string.gsub(arg, "^.-:%d+: ", "")

							if str7 == "" then
								str7 = "The operation failed with an empty error."
							end

							return tbl14.new("LUA_RUNTIME_ERROR", str7)
						end,
					}

					return tbl14
				end)()
			)
		end,
		[191] = function()
			fn23(191)

			return (
				(function()
					local function fn24(arg)
						local n = 0

						for i = 1, #arg do
							n = (n * 31 + string.byte(arg, i)) % 2147483647
						end

						return n
					end

					return {
						getUserColor = function(arg, arg2)
							local tbl14 = { "red", "orange", "yellow", "green", "cyan", "blue", "magenta", "pink" }
							return arg2[tbl14[fn24(arg) % #tbl14 + 1]] or Color3.new(1, 1, 1)
						end,
						hashString = fn24,
					}
				end)()
			)
		end,
	}

	local tbl15 = {
		{
			1,
			2,
			{ "Courage Hub" },
			{
				{
					12,
					1,
					{ "components" },
					{
						{
							15,
							1,
							{ "commandbar" },
							{
								{ 17, 2, { "suggestion" } },
								{ 16, 2, { "bar" } },
								{ 18, 2, { "suggestions" } },
							},
						},
						{
							20,
							1,
							{ "notification" },
							{
								{ 22, 2, { "notificationHolder" } },
								{ 21, 2, { "notification" } },
							},
						},
						{ 13, 2, { "actionButton" } },
						{
							23,
							2,
							{ "ui" },
							{
								{
									45,
									2,
									{ "input" },
									{ { 47, 2, { "view" } }, { 46, 2, { "interactions" } } },
								},
								{ 65, 2, { "text" } },
								{
									66,
									2,
									{ "toggle" },
									{ { 67, 2, { "input" } }, { 68, 2, { "keybindMenu" } } },
								},
								{
									48,
									2,
									{ "keybind" },
									{
										{ 50, 2, { "interactions" } },
										{ 51, 2, { "view" } },
										{ 49, 2, { "constants" } },
									},
								},
								{
									36,
									1,
									{ "components" },
									{ { 37, 2, { "checkbox" } } },
								},
								{
									24,
									2,
									{ "accordion" },
									{
										{ 27, 2, { "model" } },
										{ 28, 2, { "view" } },
										{ 25, 2, { "constants" } },
										{ 26, 2, { "interactions" } },
									},
								},
								{
									61,
									2,
									{ "table" },
									{
										{ 64, 2, { "view" } },
										{ 62, 2, { "constants" } },
										{ 63, 2, { "interactions" } },
									},
								},
								{
									39,
									2,
									{ "dropdown" },
									{
										{ 40, 2, { "constants" } },
										{ 43, 2, { "model" } },
										{ 44, 2, { "view" } },
										{ 41, 2, { "controller" } },
										{ 42, 2, { "interactions" } },
									},
								},
								{
									53,
									2,
									{ "shared" },
									{
										{ 57, 2, { "layout" } },
										{ 54, 2, { "AddonsContainer" } },
										{ 56, 2, { "fonts" } },
										{ 55, 2, { "TextHolder" } },
									},
								},
								{
									58,
									2,
									{ "slider" },
									{ { 59, 2, { "drag" } }, { 60, 2, { "view" } } },
								},
								{ 38, 2, { "container" } },
								{ 30, 2, { "button" } },
								{
									31,
									2,
									{ "colorpicker" },
									{
										{ 35, 2, { "view" } },
										{ 32, 2, { "constants" } },
										{ 34, 2, { "utils" } },
										{ 33, 2, { "interactions" } },
									},
								},
								{ 52, 2, { "separator" } },
								{ 29, 2, { "adaptiveHighlight" } },
							},
						},
						{ 14, 2, { "button" } },
						{ 19, 2, { "keybindViewer" } },
						{
							69,
							1,
							{ "window" },
							{
								{ 81, 2, { "section" } },
								{ 83, 2, { "tooltip" } },
								{
									72,
									1,
									{ "pages" },
									{
										{ 74, 2, { "pageContainer" } },
										{ 75, 2, { "pageManager" } },
										{ 73, 2, { "mainPage" } },
									},
								},
								{ 71, 2, { "dialog" } },
								{
									85,
									1,
									{ "window_modules" },
									{
										{ 96, 2, { "statusView" } },
										{ 94, 2, { "robloxTopbarToggle" } },
										{ 97, 2, { "view" } },
										{ 95, 2, { "statusLogic" } },
										{
											87,
											1,
											{ "interactions" },
											{
												{ 88, 2, { "cursor" } },
												{ 92, 2, { "viewport" } },
												{ 91, 2, { "resize" } },
												{ 90, 2, { "keybind" } },
												{ 89, 2, { "drag" } },
											},
										},
										{ 86, 2, { "constants" } },
										{ 93, 2, { "responsive" } },
									},
								},
								{ 82, 2, { "tab" } },
								{ 84, 2, { "window" } },
								{ 70, 2, { "category" } },
								{
									76,
									1,
									{ "parts" },
									{
										{ 78, 2, { "resizeHandle" } },
										{ 80, 2, { "topbar" } },
										{ 79, 2, { "statusBar" } },
										{ 77, 2, { "dropshadow" } },
									},
								},
							},
						},
					},
				},
				{ 2, 2, { "Internal" } },
				{
					118,
					2,
					{ "server" },
					{
						{ 124, 2, { "utils" } },
						{ 120, 2, { "capabilities" } },
						{ 121, 2, { "config" } },
						{ 123, 2, { "http" } },
						{ 119, 2, { "auth" } },
						{ 122, 2, { "events" } },
					},
				},
				{
					156,
					1,
					{ "utils" },
					{
						{
							164,
							1,
							{ "fusionUtils" },
							{
								{ 167, 2, { "composeTransparency" } },
								{ 165, 2, { "combineProps" } },
								{ 168, 2, { "oktween" } },
								{ 166, 2, { "component" } },
							},
						},
						{ 180, 2, { "services" } },
						{
							183,
							2,
							{ "themeUtils" },
							{
								{ 185, 2, { "createTheme" } },
								{ 189, 2, { "types" } },
								{ 186, 2, { "defaultThemeConfig" } },
								{ 184, 2, { "constants" } },
								{ 188, 2, { "themeHelpers" } },
								{ 187, 2, { "manageTheme" } },
							},
						},
						{ 163, 2, { "controlRegistry" } },
						{ 170, 2, { "insertitem" } },
						{ 159, 2, { "coalescedValue" } },
						{ 160, 2, { "color3" } },
						{ 174, 2, { "pendingTasks" } },
						{ 161, 2, { "colorSpace" }, { { 162, 2, { "contrast" } } } },
						{ 176, 2, { "player" } },
						{ 172, 2, { "loadGuard" } },
						{ 171, 2, { "keyedListState" } },
						{ 182, 2, { "targetResolver" } },
						{ 157, 2, { "agentSegmenter" } },
						{ 178, 2, { "runtimeAssets" } },
						{ 158, 2, { "animate" } },
						{ 173, 2, { "markdownRichText" } },
						{ 190, 2, { "toolError" } },
						{ 191, 2, { "userColorAssigner" } },
						{ 179, 2, { "safecallback" } },
						{ 181, 2, { "tableUtils" } },
						{ 175, 2, { "perf" } },
						{ 169, 2, { "images" } },
						{ 177, 2, { "removeitem" } },
					},
				},
				{
					100,
					1,
					{ "packages" },
					{
						{ 105, 2, { "keybindDispatcher" } },
						{ 104, 2, { "fusion" } },
						{ 114, 2, { "states" } },
						{ 103, 2, { "damerau" } },
						{ 101, 2, { "audio" } },
						{
							107,
							2,
							{ "snapdragon" },
							{
								{ 111, 2, { "SnapdragonRef" } },
								{ 109, 2, { "Signal" } },
								{ 113, 2, { "objectAssign" } },
								{ 108, 2, { "Maid" } },
								{ 112, 2, { "Symbol" } },
								{ 110, 2, { "SnapdragonController" } },
							},
						},
						{ 106, 2, { "maid" } },
						{
							115,
							1,
							{ "supercorner" },
							{ { 116, 1, { "figma_squircle" } }, { 117, 1, { "fusion" } } },
						},
						{ 102, 2, { "cmdr" } },
					},
				},
				{ 154, 1, { "systems" }, { { 155, 2, { "commandbar" } } } },
				{
					125,
					1,
					{ "storage" },
					{
						{ 126, 2, { "theme" } },
						{
							127,
							2,
							{ "themes" },
							{
								{ 144, 2, { "petrol" } },
								{ 129, 2, { "axiom" } },
								{ 151, 2, { "vapor" } },
								{ 132, 2, { "clay" } },
								{ 140, 2, { "moraine" } },
								{ 149, 2, { "strata" } },
								{ 136, 2, { "ember" } },
								{ 147, 2, { "shadow" } },
								{ 153, 2, { "wine" } },
								{ 137, 2, { "granite" } },
								{ 133, 2, { "crimson" } },
								{ 134, 2, { "dark" } },
								{ 152, 2, { "velvet" } },
								{ 150, 2, { "utils" } },
								{ 148, 2, { "slate" } },
								{ 138, 2, { "mauve" } },
								{ 139, 2, { "midnight" } },
								{ 145, 2, { "pine" } },
								{ 143, 2, { "onyx" } },
								{ 130, 2, { "bone" } },
								{ 128, 2, { "amber" } },
								{ 142, 2, { "obsidian" } },
								{ 131, 2, { "bronze" } },
								{ 141, 2, { "nocturne" } },
								{ 146, 2, { "sage" } },
								{ 135, 2, { "eclipse" } },
							},
						},
					},
				},
				{
					3,
					1,
					{ "assets" },
					{
						{
							4,
							1,
							{ "icons" },
							{
								{ 11, 2, { "generatedUntitledUiImages" } },
								{ 10, 2, { "generatedRemixImages" } },
								{ 6, 2, { "generatedImages" } },
								{ 9, 2, { "generatedPhosphorImages" } },
								{ 8, 2, { "generatedLucideImages" } },
								{ 5, 2, { "generatedHeroiconsImages" } },
								{ 7, 2, { "generatedLegacyImages" } },
							},
						},
					},
				},
				{ 98, 1, { "modules" }, { { 99, 2, { "saveManager" } } } },
			},
		},
	}

	local tbl16 = {
		8,
		870,
		[5] = 879,
		[6] = 1158,
		[7] = 1237,
		[8] = 1269,
		[9] = 1573,
		[10] = 1852,
		[11] = 2131,
		[13] = 2410,
		[14] = 2830,
		[16] = 3283,
		[17] = 3531,
		[18] = 3718,
		[19] = 3878,
		[21] = 4063,
		[22] = 4447,
		[23] = 4498,
		[24] = 4513,
		[25] = 4663,
		[26] = 4709,
		[27] = 4797,
		[28] = 4879,
		[29] = 5154,
		[30] = 5432,
		[31] = 5519,
		[32] = 5944,
		[33] = 6002,
		[34] = 6251,
		[35] = 6281,
		[37] = 6737,
		[38] = 6912,
		[39] = 7021,
		[40] = 7268,
		[41] = 7313,
		[42] = 7719,
		[43] = 7962,
		[44] = 8367,
		[45] = 9059,
		[46] = 9206,
		[47] = 9271,
		[48] = 9398,
		[49] = 9650,
		[50] = 9663,
		[51] = 9746,
		[52] = 9836,
		[53] = 9904,
		[54] = 9912,
		[55] = 9991,
		[56] = 10088,
		[57] = 10097,
		[58] = 10117,
		[59] = 10390,
		[60] = 10489,
		[61] = 10834,
		[62] = 11078,
		[63] = 11103,
		[64] = 11172,
		[65] = 11633,
		[66] = 11773,
		[67] = 12055,
		[68] = 12106,
		[70] = 12987,
		[71] = 13218,
		[73] = 13851,
		[74] = 14145,
		[75] = 14218,
		[77] = 14377,
		[78] = 14418,
		[79] = 14455,
		[80] = 14521,
		[81] = 14983,
		[82] = 15192,
		[83] = 15542,
		[84] = 15897,
		[86] = 16407,
		[88] = 16441,
		[89] = 16549,
		[90] = 16640,
		[91] = 16667,
		[92] = 16767,
		[93] = 16863,
		[94] = 16917,
		[95] = 17258,
		[96] = 17474,
		[97] = 17581,
		[99] = 17720,
		[101] = 18730,
		[102] = 18754,
		[103] = 18929,
		[104] = 19011,
		[105] = 23095,
		[106] = 23281,
		[107] = 23441,
		[108] = 23463,
		[109] = 23587,
		[110] = 23632,
		[111] = 24055,
		[112] = 24090,
		[113] = 24122,
		[114] = 24135,
		[118] = 24247,
		[119] = 24388,
		[120] = 24630,
		[121] = 24839,
		[122] = 24882,
		[123] = 24930,
		[124] = 25106,
		[126] = 25205,
		[127] = 25314,
		[128] = 25403,
		[129] = 25437,
		[130] = 25472,
		[131] = 25508,
		[132] = 25544,
		[133] = 25580,
		[134] = 25614,
		[135] = 25648,
		[136] = 25682,
		[137] = 25716,
		[138] = 25752,
		[139] = 25788,
		[140] = 25824,
		[141] = 25860,
		[142] = 25896,
		[143] = 25930,
		[144] = 25964,
		[145] = 26000,
		[146] = 26036,
		[147] = 26072,
		[148] = 26106,
		[149] = 26142,
		[150] = 26175,
		[151] = 26193,
		[152] = 26227,
		[153] = 26263,
		[155] = 26299,
		[157] = 26520,
		[158] = 26824,
		[159] = 26853,
		[160] = 26899,
		[161] = 26943,
		[162] = 27676,
		[163] = 27720,
		[165] = 28814,
		[166] = 28847,
		[167] = 28871,
		[168] = 28895,
		[169] = 29063,
		[170] = 29667,
		[171] = 29687,
		[172] = 29851,
		[173] = 29884,
		[174] = 30321,
		[175] = 30412,
		[176] = 30601,
		[177] = 30682,
		[178] = 30703,
		[179] = 30752,
		[180] = 30763,
		[181] = 30786,
		[182] = 30817,
		[183] = 30997,
		[184] = 31034,
		[185] = 31069,
		[186] = 31335,
		[187] = 31383,
		[188] = 31484,
		[189] = 31880,
		[190] = 32019,
		[191] = 32083,
	}

	local str7 = "0.4.2"
	local str8 = "WaxRuntime"

	local Library = (function()
		local e, M, x, O, R, d, p, I, E, w, S, f, a, n, Q =
			string,
			task,
			setmetatable,
			error,
			next,
			table,
			unpack,
			coroutine,
			script,
			type,
			require,
			pcall,
			tostring,
			tonumber,
			_VERSION

		local Z, t, z, L, l, P, r =
			d.insert, d.remove, d.freeze or function(D)
				return D
			end, I.wrap, e.sub, e.match, e.gmatch

		if Q and (l(Q, 1, 4) == "Lune") then
			I, d = f(S, "@lune/task")
			M = if I and d then d else M
		end

		local e, d, Q, D, W, F, _, k, N =
			(M and M.defer) or function(M, ...)
				L(M)(...)
			end, { [1] = "Folder", [2] = "ModuleScript", [3] = "Script", [4] = "LocalScript", [5] = "StringValue" }, {}, {}, {}, {}, {}, {}, {}

		local M, L =
			{ GetFullName = {
				{},
				function(s)
					local q, U = s.Parent, s.Name

					while q do
						U, q = q.Name .. ("." .. U), q.Parent
					end

					return U
				end,
			}, GetChildren = {
				{},
				function(s)
					local q = {}

					for U in R, N[s], nil do
						Z(q, U)
					end

					return q
				end,
			}, GetDescendants = {
				{},
				function(s)
					local q = {}

					for U in R, N[s], nil do
						Z(q, U)
						local s, B = U:GetDescendants()

						for U, U in R, s, B do
							Z(q, U)
						end
					end

					return q
				end,
			}, FindFirstChild = {
				{ "string", "boolean?" },
				function(s, q, U)
					local B = N[s]

					for s in R, B, nil do
						if s.Name == q then
							return s
						end
					end

					if U then
						for s in R, B, nil do
							return s:FindFirstChild(q, true)
						end
					end
				end,
			}, FindFirstAncestor = {
				{ "string" },
				function(s, q)
					local U = s.Parent

					while U do
						if U.Name == q then
							return U
						end
						U = U.Parent
					end
				end,
			}, WaitForChild = {
				{ "string", "number?" },
				function(s, q)
					return s:FindFirstChild(q)
				end,
			} }, {}

		for s, q in R, M, nil do
			local M, U, B = q[1], q[2], {}

			for A, V in R, M, nil do
				I, q = P(V, "^([^%?]+)(%??)")
				B[A] = { I, q }
			end

			L[s] = function(M, ...)
				if not N[M] then
					O("Expected ':' not '.' calling member function " .. s, 2)
				end

				local s = { ... }

				for q, A in R, B, nil do
					local B = s[q]
					local s, V, j = w(B), A[1], A[2]

					if (B == nil) and not j then
						O("Argument " .. (B .. " missing or nil"), 3)
					end

					if ((V ~= "any") and (s ~= V)) and not ((s == "nil") and j) then
						O("Argument " .. (q .. (' expects type "' .. (V .. ('", got "' .. (s .. '"'))))), 2)
					end
				end

				return U(M, ...)
			end
		end

		local function M(s, q, U)
			local B = x({}, { __mode = "k" })

			local function A(V)
				O(V .. (" is not a valid (virtual) member of " .. (s .. (' "' .. (q .. '"')))), 3)
			end

			local function V(j)
				O("Unable to assign (virtual) property " .. (j .. ". Property is read only"), 3)
			end

			local j, m, G = {}, {}
			m.__metatable = false

			m.__index = function(X, y)
				if y == "ClassName" then
					return s
				elseif y == "Name" then
					return q
				elseif y == "Parent" then
					return U
				elseif (s == "StringValue") and (y == "Value") then
					return G
				else
					X = L[y]
					if X then
						return X
					end
				end

				for L in R, B, nil do
					if L.Name == y then
						return L
					end
				end

				A(y)
			end

			m.__newindex = function(L, X, y)
				if X == "ClassName" then
					V(X)
				elseif X == "Name" then
					q = y
				elseif X == "Parent" then
					if y == j then
						return
					end

					if U ~= nil then
						N[U][j] = nil
					end

					U = y

					if y ~= nil then
						N[y][j] = true
					end
				else
					L = (s == "StringValue") and (X == "Value")

					if L then
						G = y
					else
						A(X)
					end
				end
			end

			m.__tostring = function()
				return q
			end

			x(j, m)
			N[j] = B

			if U ~= nil then
				N[U][j] = true
			end

			return j
		end

		local function L(s, q)
			local U, B, A, V = s[1], s[2], s[3], s[4]
			s = d[B]
			B = M(s, (A and (t(A, 1))) or s, q)
			Q[U] = B

			if A then
				for d, s in R, A, nil do
					B[d] = s
				end
			end

			if V then
				for d, d in R, V, nil do
					L(d, B)
				end
			end

			return B
		end

		local d = M("Folder", "[" .. (str8 .. "]"))

		for M, M in R, tbl15, nil do
			L(M, d)
		end

		for M, L in R, tbl14, nil do
			I = Q[M]
			D[I] = L
			W[I] = M
			M = I.ClassName

			if (M == "LocalScript") or (M == "Script") then
				Z(_, I)
			end
		end

		local function M(I)
			local Z, L = I.ClassName, F[I]
			if L and (Z == "ModuleScript") then
				return p(L)
			end
			L = D[I]

			local function D(s)
				s = a(s)
				local a, q, U = I:GetFullName(), P(s, "[^:]+:(%d+): (.+)")
				if not q or not tbl16 then
					return a .. (":*: " .. (U or s))
				end
				s = (n(q) - tbl16[W[I]]) + 1
				return a .. (":" .. ((if s < 0 then "?" else s) .. (": " .. U)))
			end

			if (Z == "LocalScript") or (Z == "Script") then
				local a, n = f(L)

				if not a then
					O(D(n), 0)
				end
			else
				local a = { f(L) }

				if not t(a, 1) then
					O(D((t(a, 1))), 0)
				end

				F[I] = a
				return p(a)
			end
		end

		fn23 = function(I)
			local a = Q[I]

			local function I(n, ...)
				local Q = { f(n, ...) }

				if not t(Q, 1) then
					O(Q[1], 3)
				end

				return p(Q)
			end

			return z({
				version = str7,
				envname = str8,
				shared = z(x({}, {
					__index = k,
					__newindex = function(g, g, x)
						k[g] = x
					end,
					__len = function()
						return #k
					end,
					__iter = function()
						return R, k
					end,
				})),
				script = E,
				require = S,
			}),
				a,
				function(g, ...)
					local x, p, E, f =
						w(g),
						"Attempted to call require with a non-ModuleScript",
						"Attempted to call require with self",
						g

					if (x == "table") and N[g] then
						if f.ClassName ~= "ModuleScript" then
							O(p, 2)
						elseif f == a then
							O(E, 2)
						end

						return M(f)
					elseif (x == "string") and (l(f, 1, 1) ~= "@") then
						if #f == 0 then
							O("Attempted to call require with empty string", 2)
						end

						local x

						if l(f, 1, 1) == "/" then
							g, x = f, d
						else
							g, x = if l(f, 1, 2) == "./" then (l(f, 3)) else f, a
						end

						local w

						for n in r(g, "([^/]*)/?") do
							local Q = if n == ".." then "Parent" else n

							if Q ~= "" then
								local Z = x:FindFirstChild(Q)

								if not Z then
									local t = x.Parent
									Z = if t then (t:FindFirstChild(Q)) else Z
								end

								if Z then
									x = Z
								elseif
									(((n ~= w) and (n ~= "init")) and (n ~= "init.server")) and (n ~= "init.client")
								then
									O('Virtual script path "' .. (g .. '" not found'), 2)
								end
							end

							w = n
						end

						if x.ClassName ~= "ModuleScript" then
							O(p, 2)
						elseif x == a then
							O(E, 2)
						end

						return M(x)
					end

					return I(S, f, ...)
				end
		end

		for g, g in R, _, nil do
			e(M, g)
		end

		return M(d:GetChildren()[1])
	end)()

	return Library
-- COURAGE-END
			end)()
		end)

		if okCourage and type(resultCourage) == "table" and type(resultCourage.CreateWindow) == "function" then
			CourageLib = resultCourage
		else
			error("[CourageHub] Courage UI library failed to load (" .. tostring(resultCourage) .. ")")
		end
	end

	-- -----------------------------------------------------------------
	-- Shared helpers
	-- -----------------------------------------------------------------
	local function NormalizeMultiResult(result)
		if type(result) ~= "table" then
			return result
		end

		if result[1] ~= nil then
			local dict = {}

			for _, value in ipairs(result) do
				dict[value] = true
			end

			return dict
		end

		return result
	end

	local function MultiToArray(dict)
		local arr = {}

		if type(dict) == "table" then
			for value in pairs(dict) do
				table.insert(arr, value)
			end
		end

		return arr
	end

	local function KeyEnumFromString(name)
		if type(name) ~= "string" or name == "None" then
			return nil
		end

		if name == "MB1" then
			return Enum.UserInputType.MouseButton1
		elseif name == "MB2" then
			return Enum.UserInputType.MouseButton2
		end

		local ok, enum = pcall(function()
			return Enum.KeyCode[name]
		end)

		if ok then
			return enum
		end

		return nil
	end

	-- =================================================================
	-- UI backend
	-- =================================================================
	do
		local ShimLib = {}

		local currentMinimizeKey = nil
		local menuToggleListenerInstalled = false

		local function InstallMenuKeyListener()
			if menuToggleListenerInstalled then
				return
			end

			menuToggleListenerInstalled = true

			game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
				if processed then
					return
				end

				if input.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end

				if currentMinimizeKey and input.KeyCode == currentMinimizeKey then
					task.spawn(function()
						ShimLib.Toggle()
					end)
				end
			end)
		end

		function ShimLib:Window(Settings)
			Settings = Settings or {}

			local placeName = tostring(game.Name)
			pcall(function()
				local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
				if info and info.Name and info.Name ~= "" then
					placeName = info.Name
				end
			end)

			-- native minimize key is disabled; the shim drives all
			-- visibility changes so the silent-mode wrapper keeps working
			local ethWindow = CourageLib:CreateWindow({
				Title = Settings.Title or "No title",
				Tag = placeName,
				Size = Settings.Size or UDim2.fromOffset(555, 600),
				MinimizeKey = Enum.KeyCode.Unknown,
			})

			pcall(function()
				CourageLib.SetKeybindViewerVisible(CourageLib, false)
			end)

			InstallMenuKeyListener()

			local desiredOpen = true
			local initialized = false

			local Window = {
				Settings = Settings,
				Tabs = {},
			}

			local function EnsureInit()
				if initialized then
					return
				end

				initialized = true

				task.defer(function()
					pcall(function()
						ethWindow:Init()
					end)

					if not desiredOpen then
						pcall(function()
							ethWindow:Minimize()
						end)
					end
				end)
			end

			function Window:SetState(state)
				state = state and true or false

				if state ~= desiredOpen then
					desiredOpen = state

					if initialized then
						pcall(function()
							ethWindow:Minimize()
						end)
					end
				end
			end

			function Window:GetState()
				return desiredOpen
			end

			Window.Toggle = function()
				Window:SetState(not Window:GetState())
			end

			function Window:Notify(info)
				pcall(function()
					CourageLib:Notify({
						Title = info.Title or Settings.Title or "Notification",
						Description = tostring(info.Description or ""),
						Duration = info.Lifetime or 5,
						Type = "info",
					})
				end)
			end

			function Window:SetKeybind(keyEnum)
				currentMinimizeKey = keyEnum
			end

			function Window:Unload()
				pcall(function()
					CourageLib:Destroy()
				end)
			end

			function Window.onUnloaded(callback)
				pcall(function()
					CourageLib:OnDestroy(callback)
				end)
			end

			Window.ScreenGui = CourageLib.GUI
			Window.Holder = nil
			Window.CourageWindow = ethWindow

			function Window:TabGroup(Title)
				local category = ethWindow:AddCategory({ Title = Title or "MAIN" })
				local Group = {}

				function Group:Tab(info)
					local ethTab = category:AddTab({ Title = info.Name })

					local Tab = { Name = info.Name }

					function Tab:Section(sectionInfo)
						sectionInfo = sectionInfo or {}

						local lazy = {
							Side = sectionInfo.Side == "Right" and "right" or "left",
							EthSection = nil,
						}

						lazy.Hidden = false

						local function Materialize(title)
							if lazy.EthSection then
								return lazy.EthSection
							end

							lazy.EthSection = ethTab:AddSection({
								Title = title or "",
								Side = lazy.Side,
								Collapsed = lazy.Hidden or nil,
							})
							return lazy.EthSection
						end

						function lazy:Header(headerInfo)
							Materialize(headerInfo and (headerInfo.Text or headerInfo.Name) or "")
						end

						function lazy:SetCollapsed(hidden)
							lazy.Hidden = hidden and true or false

							if lazy.EthSection then
								pcall(function()
									lazy.EthSection.Component.Collapsed:set(lazy.Hidden)
								end)
							end
						end

						function lazy:Toggle(macInfo, flag)
							local ethSection = Materialize(macInfo.Text or macInfo.Name or flag)

							local ethToggle = ethSection:AddToggle(flag, {
								Title = macInfo.Text or macInfo.Name or tostring(flag),
								Default = macInfo.Default and true or false,
								Callback = macInfo.Callback or function() end,
							})

							local wrapper

							wrapper = {
								Eth = ethToggle,

								UpdateState = function(_, state)
									state = state and true or false

									local before = ethToggle.Value

									pcall(function()
										ethToggle:SetValue(state)
									end)

									if ethToggle.Value == before then
										if macInfo.Callback then
											macInfo.Callback(state)
										end
									end
								end,

								AddKeybind = function(_, subFlag, subInfo)
									return ethToggle:AddKeybind(subFlag, {
										Title = (subInfo and subInfo.Title) or subFlag,
										Default = (subInfo and subInfo.Default) or "None",
										Mode = (subInfo and subInfo.Mode) or "Toggle",
										Callback = (subInfo and subInfo.Callback) or function() end,
									})
								end,
							}

							return wrapper
						end

						function lazy:Slider(macInfo, flag)
							local ethSection = Materialize(macInfo.Text or macInfo.Name or flag)

							local ethSlider = ethSection:AddSlider(flag, {
								Title = macInfo.Text or macInfo.Name or tostring(flag),
								Default = macInfo.Default or macInfo.Minimum or 0,
								Min = macInfo.Minimum or 0,
								Max = macInfo.Maximum or 100,
								Rounding = macInfo.Precision or 0,
								Suffix = macInfo.Suffix,
								Callback = macInfo.Callback or function() end,
							})

							local syncing = true

							pcall(function()
								ethSlider:OnChanged(function(value)
									if not syncing and macInfo.Callback then
										macInfo.Callback(value)
									end
								end)
							end)

							syncing = false

							return {
								Eth = ethSlider,

								UpdateValue = function(_, value)
									syncing = true
									pcall(function()
										ethSlider:SetValue(value)
									end)
									syncing = false
								end,
							}
						end

						function lazy:Dropdown(macInfo, flag)
							local ethSection = Materialize(macInfo.Text or macInfo.Name or flag)

							local values = macInfo.Options or {}
							local multi = macInfo.Multi and true or false
							local defaultOut

							if multi then
								defaultOut = MultiToArray(macInfo.Default)
							elseif type(macInfo.Default) == "number" and values[macInfo.Default] ~= nil then
								defaultOut = values[macInfo.Default]
							elseif type(macInfo.Default) == "string" then
								defaultOut = macInfo.Default
							end

							local syncing = true

							local ethDropdown = ethSection:AddDropdown(flag, {
								Title = macInfo.Text or macInfo.Name or tostring(flag),
								Values = values,
								Default = defaultOut,
								Multi = multi,
								AllowNull = not macInfo.Required,
								Callback = function(value)
									if not syncing and macInfo.Callback then
										macInfo.Callback(multi and NormalizeMultiResult(value) or value)
									end
								end,
							})

							syncing = false

							return {
								Eth = ethDropdown,
								Settings = {},

								UpdateSelection = function(_, selection)
									syncing = true

									pcall(function()
										if multi then
											ethDropdown:SetValue(MultiToArray(selection))
										else
											ethDropdown:SetValue(selection)
										end
									end)

									syncing = false
								end,

								ClearSelection = function(_)
									syncing = true
									pcall(function()
										ethDropdown:SetValue(nil)
									end)
									syncing = false
								end,

								ClearOptions = function(_)
									syncing = true
									pcall(function()
										ethDropdown:SetValues({})
									end)
									syncing = false
								end,

								InsertOptions = function(_, newOptions)
									syncing = true
									pcall(function()
										ethDropdown:SetValues(newOptions or {})
									end)
									syncing = false
								end,
							}
						end

						function lazy:Input(macInfo, flag)
							local ethSection = Materialize(macInfo.Text or macInfo.Name or flag)

							local finished = macInfo.Finished and true or false

							local ethInput = ethSection:AddInput(flag, {
								Title = macInfo.Text or macInfo.Name or tostring(flag),
								Default = macInfo.Default or "",
								Placeholder = macInfo.Placeholder or "",
								Numeric = macInfo.Numeric and true or (macInfo.AcceptedCharacters == "Numeric"),
								Finished = finished,
								Callback = function(text)
									if macInfo.Callback then
										macInfo.Callback(text, finished)
									end
								end,
							})

							local syncing = true

							pcall(function()
								ethInput:OnChanged(function(text)
									if not syncing and macInfo.Callback then
										macInfo.Callback(text, finished)
									end
								end)
							end)

							syncing = false

							return {
								Eth = ethInput,

								UpdateText = function(_, text)
									syncing = true
									pcall(function()
										ethInput:SetValue(text)
									end)
									syncing = false
								end,
							}
						end

						function lazy:Button(macInfo)
							local ethSection = Materialize(macInfo.Name or "Button")

							return ethSection:AddButton({
								Title = macInfo.Name or "Button",
								Callback = macInfo.Callback or function() end,
							})
						end

						function lazy:Label(macInfo)
							local ethSection = Materialize(macInfo.Text or macInfo.Name or "")

							local ethText = ethSection:AddText({
								Title = macInfo.Text or macInfo.Name or "",
							})

							return {
								Eth = ethText,

								UpdateName = function(_, text)
									pcall(function()
										ethText:SetTitle(tostring(text))
									end)
								end,

								SetText = function(_, text)
									pcall(function()
										ethText:SetTitle(tostring(text))
									end)
								end,
							}
						end

						function lazy:Colorpicker(macInfo, flag)
							local ethSection = Materialize(macInfo.Name or flag or "Color")

							local ethColor = ethSection:AddColorpicker(flag, {
								Title = macInfo.Name or tostring(flag),
								Default = macInfo.Default,
								Callback = function(value)
									if macInfo.Callback then
										macInfo.Callback(value, macInfo.Alpha or 0)
									end
								end,
							})

							local wrapper = {
								Eth = ethColor,
								Color = macInfo.Default,
								Alpha = macInfo.Alpha or 0,
							}

							function wrapper:SetColor(color)
								wrapper.Color = color

								pcall(function()
									ethColor:SetValueRGB(color)
								end)
							end

							function wrapper:SetAlpha(alpha)
								wrapper.Alpha = alpha
							end

							return wrapper
						end

						function lazy:Divider()
							local ethSection = Materialize("")

							pcall(function()
								ethSection:AddSeparator()
							end)
						end

						function lazy:Spacer()
							Materialize("")
							return {}
						end

						function lazy:AddKeybind(flag, info)
							local ethSection = Materialize((info and info.Title) or flag or "")

							return ethSection:AddKeybind(flag, {
								Title = (info and info.Title) or flag,
								Default = (info and info.Default) or "None",
								Mode = (info and info.Mode) or "Toggle",
								Callback = (info and info.Callback) or function() end,
							})
						end

						return lazy
					end

					Window.Tabs[info.Name] = Tab

					return Tab
				end

				return Group
			end

			EnsureInit()

			return Window
		end

		ShimLib.Toggle = function()
			-- replaced per-window by the adapter; keep a safe default
		end

		-- native UI handle for scripts speaking the raw Fluent-style API
		-- (e.g. The Veil module via its UI-compat adapter)
		ShimLib.Native = CourageLib
		CourageUI = ShimLib
	end

return CourageUI