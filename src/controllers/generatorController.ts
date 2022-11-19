import { NextFunction, Request, Response } from 'express';
import generatorService from '@services/generator.service';

class GeneratorController {
  public generatorService = new generatorService();

  public generateMetadata = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const generatedTokens= await this.generatorService.generateMetadata(req.params.metadata);

      res.status(200).json({ data: generatedTokens, message: '' });
    } catch (error) {
      next(error);
    }
  };
}

export default GeneratorController;
