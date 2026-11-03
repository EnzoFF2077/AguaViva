{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: { canvasKitBaseUrl: new URL('canvaskit/', document.baseURI).href },
  onEntrypointLoaded: async (initializer) => {
    try {
      const engine = await initializer.initializeEngine();
      await engine.runApp();
    } catch (error) {
      window.showStartupError(error);
    }
  }
}).catch(window.showStartupError);
