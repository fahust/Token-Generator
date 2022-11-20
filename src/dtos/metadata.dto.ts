import { IsObject, IsString } from "class-validator";

export class CreateMetadataDto {
  @IsString()
  public name: string;

  @IsString()
  public description: string;

  @IsString()
  public image: string;

  @IsString()
  public edition: string;

  @IsObject()
  public collection: Object;

  @IsString()
  public symbol: string;

  @IsObject()
  public properties: Object;

  @IsString()
  public category: string;

  @IsString()
  public creators: string;

  @IsObject()
  public attributes: Object;
}
