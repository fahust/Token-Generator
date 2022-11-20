import { NextFunction, Request, Response } from "express";
import generatorService from "@services/generator.service";
import { CreateMetadataDto } from "@/dtos/metadata.dto";

class GeneratorController {
  public generatorService = new generatorService();

  public generateMetadata = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const generatedTokens = await this.generatorService.generateTokens(
        req.body.quantity,
        req.body.metadata as CreateMetadataDto,
      );

      res.status(200).json({ data: generatedTokens, message: "" });
    } catch (error) {
      next(error);
    }
  };

  public downloadMetadatas = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const generatedTokens = await this.generatorService.generateTokens(
        req.body.quantity,
        req.body.metadata as CreateMetadataDto,
      );

      await this.generatorService.writeJson(generatedTokens);

      await this.generatorService.updateZipArchive("./files/test.zip", req.body.quantity);

      res.download("./files/test.zip"); // Set disposition and send it.
    } catch (error) {
      next(error);
    }
  };
}

export default GeneratorController;
