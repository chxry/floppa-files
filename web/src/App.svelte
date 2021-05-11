<script lang="ts">
  import Router from "svelte-spa-router";
  import Upload from "./pages/Upload.svelte";
  import FAQ from "./pages/FAQ.svelte";

  const routes = {
    "/": Upload,
    "/faq": FAQ,
  };
</script>

<Router {routes} />
