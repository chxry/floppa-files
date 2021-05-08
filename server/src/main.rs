use std::{
  io::{Error, Write},
  fs::File,
};
use actix_web::{web, App, HttpResponse, HttpServer};
use actix_multipart::Multipart;
use actix_files::Files;
use futures::StreamExt;
use uuid::Uuid;

#[actix_web::main]
async fn main() -> Result<(), Error> {
  std::fs::create_dir_all("./files")?;

  HttpServer::new(|| {
    App::new()
      .route("/upload", web::post().to(upload))
      .service(Files::new("/files", "./files"))
      .service(
        Files::new(
          "/",
          if cfg!(debug_assertions) {
            "../web/public"
          } else {
            "./web"
          },
        )
        .index_file("index.html"),
      )
  })
  .bind("0.0.0.0:8080")?
  .run()
  .await?;
  Ok(())
}

async fn upload(mut payload: Multipart) -> Result<HttpResponse, Error> {
  let item = payload.next().await.unwrap();
  let mut field = item.unwrap();
  let content_type = field.content_disposition().unwrap();
  let filename = format!(
    "{}.{}",
    Uuid::new_v4().to_string(),
    content_type
      .get_filename()
      .unwrap()
      .split(".")
      .last()
      .unwrap()
  );
  let mut f = File::create(format!("./files/{}", filename))?;
  while let Some(chunk) = field.next().await {
    let data = chunk.unwrap();
    let mut pos = 0;
    while pos < data.len() {
      let bytes_written = f.write(&data[pos..])?;
      pos += bytes_written;
    }
  }
  Ok(HttpResponse::Ok().body(filename))
}
