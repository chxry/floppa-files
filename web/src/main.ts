import App from "./App.svelte";

export type FileUpload = {
  name: string;
  url: string | null;
};

const app = new App({
  target: document.body,
});

export default app;
