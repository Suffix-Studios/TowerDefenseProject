type Section = {
	readonly Positions: Vector3[];
	readonly Length: number;
	readonly Type: number;
	readonly TRanges: number[];
	readonly AccumulatedDistance: number;
};

type Methods = {
	CalculateUniformPosition: (this: Path, T: number) => Vector3;
	CalculateUniformCFrame: (this: Path, T: number) => CFrame;
	CalculateDerivative: (this: Path, T: number) => Vector3;
	GetPathLength: (this: Path) => number;
	CalculateClosestPoint: (this: Path, Position: Vector3, Iterations?: number) => LuaTuple<[CFrame, number]>;
	VisualizePath: (this: Path) => void;
};

type Path = {
	readonly Sections: Section[];
	readonly PathLength: number;
} & Methods;

interface BezierPath {
	new (Waypoints: Vector3[], CurveSize: number | number[]): Path;
}

declare const BezierPath: BezierPath;

export = BezierPath;
