const getRequest = ({
  url,
  handleResponse,
  setLoading,
  setError,
}: {
  url: string;
  handleResponse: (data: Record<string, string>) => void;
  setLoading: (state: boolean) => void;
  setError: (state: boolean) => void;
}) => {
  setLoading(true);
  fetch(url)
    .then((response) => response.json())
    .then((json) => {
      handleResponse(json.data);
      setLoading(false);
    })
    .catch((error) => {
      console.error(error);
      setError(error);
    });
};

export default getRequest;
