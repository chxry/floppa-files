<script lang="ts">
  import "../scss/upload.scss";
  import type { FileUpload } from "../main";
  import { Layout, File } from "../components";

  let uploaded: FileUpload[] = [];

  let fileUploadHandler = async (e) => {
    let file = e.target.files[0];
    let formData = new FormData();
    formData.append(file.name, file);

    let tmp = uploaded;
    tmp.push({ name: file.name, url: null });
    uploaded = tmp;

    let response = await fetch("/upload", {
      method: "POST",
      body: formData,
    });

    tmp[tmp.length - 1].url =
      window.location.href + "files/" + (await response.text());
    uploaded = tmp;
  };
</script>

<Layout>
  <div class="upload">
    <input type="file" on:change={fileUploadHandler} />
    <h1>Drag or click here to upload</h1>
  </div>
  {#each uploaded as file}
    <File {file} />
  {/each}
</Layout>
